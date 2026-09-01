table 59067 "Agent Target"
{
    Caption = 'Agent Target';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Agent No."; Code[20])
        {
            Caption = 'Agent No.';
            TableRelation = Agents."No.";
        }
        field(2; "Period"; Date)
        {
            Caption = 'Period';
            // store as first day of month, e.g. 01/06/2026 = June 2026 target
        }
        field(3; "Target Type"; Option)
        {
            Caption = 'Target Type';
            OptionMembers = Disbursements,Collections,"New Customers";
        }
        field(4; "Target Amount"; Decimal) { Caption = 'Target Amount'; }

        field(5; "Actual Amount"; Decimal)
        {
            Caption = 'Actual Amount';
            Editable = false;
            // Not a FlowField: which underlying figure counts as "actual" depends on
            // this record's own Target Type (Disbursements/Collections/New Customers),
            // and a single CalcFormula can't branch per record on another field's
            // value. GetActualAmount() below computes it and should be called
            // (e.g. from the card/list page's OnAfterGetRecord) to refresh this field
            // before display.
        }
        field(6; "Achievement %"; Decimal)
        {
            Caption = 'Achievement %';
            Editable = false;
        }
        field(7; "Agent Name"; Text[100])
        {
            Caption = 'Agent Name';
            CalcFormula = lookup(Agents."Full Name" where("No." = field("Agent No.")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(PK; "Agent No.", "Period", "Target Type")
        {
            Clustered = true;
        }
    }

    procedure GetActualAmount(): Decimal
    var
        Agent: Record Agents;
        PeriodStart: Date;
        PeriodEnd: Date;
    begin
        if not Agent.Get("Agent No.") then
            exit(0);

        if "Period" = 0D then
            exit(0);

        PeriodStart := CalcDate('<-CM>', "Period");
        PeriodEnd := CalcDate('<CM>', "Period");
        Agent.SetRange("Date Filter", PeriodStart, PeriodEnd);

        case "Target Type" of
            "Target Type"::Disbursements:
                begin
                    Agent.CalcFields("Total Disbursed");
                    exit(Agent."Total Disbursed");
                end;
            "Target Type"::Collections:
                begin
                    Agent.CalcFields("Current Collections");
                    exit(Agent."Current Collections");
                end;
            "Target Type"::"New Customers":
                begin
                    Agent.CalcFields("Customers Onboarded");
                    exit(Agent."Customers Onboarded");
                end;
        end;
    end;

    procedure UpdateActual()
    begin
        "Actual Amount" := GetActualAmount();
        if "Target Amount" <> 0 then
            "Achievement %" := Round("Actual Amount" / "Target Amount" * 100, 0.01)
        else
            "Achievement %" := 0;
    end;

    // Carries every target from the latest period on file forward to the next
    // calendar month, at the same Target Amount, for whichever (Agent, Target
    // Type) combinations don't already have a target in that next period. Saves
    // re-entering targets for every agent by hand each month; existing targets
    // for the next period are left untouched.
    procedure CopyTargetsToNextPeriod(): Integer
    var
        LatestTarget: Record "Agent Target";
        SourceTarget: Record "Agent Target";
        NewTarget: Record "Agent Target";
        LatestPeriod: Date;
        NextPeriod: Date;
        Created: Integer;
    begin
        LatestTarget.SetCurrentKey(Period);
        if not LatestTarget.FindLast() then
            exit(0);
        LatestPeriod := LatestTarget.Period;
        NextPeriod := CalcDate('<CM+1D>', LatestPeriod);

        SourceTarget.SetRange(Period, LatestPeriod);
        if SourceTarget.FindSet() then
            repeat
                if not NewTarget.Get(SourceTarget."Agent No.", NextPeriod, SourceTarget."Target Type") then begin
                    NewTarget.Init();
                    NewTarget."Agent No." := SourceTarget."Agent No.";
                    NewTarget.Period := NextPeriod;
                    NewTarget."Target Type" := SourceTarget."Target Type";
                    NewTarget."Target Amount" := SourceTarget."Target Amount";
                    NewTarget.Insert(true);
                    Created += 1;
                end;
            until SourceTarget.Next() = 0;

        exit(Created);
    end;
}