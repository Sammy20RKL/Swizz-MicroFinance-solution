table 59068 "Member Group"
{
    Caption = 'Member Group';
    DataClassification = CustomerContent;
    DrillDownPageId = "Member Group List";
    LookupPageId = "Member Group List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    SaccoNoSeries.Get;
                    NoSeriesMgt.TestManual(SaccoNoSeries."Micro Group Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(3; Name; Text[100])
        {
            Caption = 'Group Name';
            NotBlank = true;
        }
        field(4; "Group Type"; Option)
        {
            Caption = 'Group Type';
            OptionMembers = "General Group","Women Group",Agricultural,Cooperative;
        }
        field(5; "Agent No."; Code[20])
        {
            Caption = 'Agent No.';
            TableRelation = Agents."No.";
        }
        field(6; "Agent Name"; Text[100])
        {
            Caption = 'Agent Name';
            CalcFormula = lookup(Agents."Full Name" where("No." = field("Agent No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Formation Date"; Date)
        {
            Caption = 'Formation Date';
        }
        field(8; "Meeting Frequency"; Option)
        {
            Caption = 'Meeting Frequency';
            OptionMembers = Weekly,"Bi-Weekly",Monthly;
        }
        field(9; "Meeting Day"; Option)
        {
            Caption = 'Meeting Day';
            OptionMembers = " ",Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday;
        }
        field(10; "Meeting Location"; Text[100])
        {
            Caption = 'Meeting Location';
        }
        field(11; "Branch Code"; Code[20])
        {
            Caption = 'Branch';
            TableRelation = "Dimension Value".Code;
        }
        field(12; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = Active,Dormant,Dissolved;

            trigger OnValidate()
            begin
                if ("Status" = Status::Dissolved) and ("Status" <> xRec."Status") then begin
                    UpdateGuaranteeFundFigures();
                    if "Outstanding Group Loans" <> 0 then
                        Error('This group still guarantees %1 outstanding loan(s) totalling %2. Settle or reassign those loans before dissolving the group.', "Outstanding Group Loans", "Committed Amount");
                end;
            end;
        }

        // ---------- Guarantee fund (committed vs. available) ----------
        // The group's guarantee fund is bookkeeping internal to this system, not a
        // licensed deposit account: it exists purely so a member's loan can be
        // guaranteed against the group's pooled contributions. "Committed" is the
        // portion currently locked against an active guarantee; "Available" is the
        // remainder still free to guarantee a new application.
        field(20; "Total Contributions"; Decimal)
        {
            Caption = 'Total Contributions';
            CalcFormula = sum("Group Contribution"."Amount" where("Group No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        // "Committed Amount" and "Outstanding Group Loans" cannot be FlowFields:
        // "Outstanding Balance" on Loans Register is itself a FlowField (computed
        // from Cust. Ledger Entry), and SQL Server has no physical column to
        // aggregate or filter on for a FlowField-of-a-FlowField - both a sum() and a
        // count()-with-filter over it compile but throw "Invalid column name
        // 'Outstanding Balance'" at runtime. These are plain fields instead,
        // refreshed by UpdateGuaranteeFundFigures().
        field(21; "Committed Amount"; Decimal)
        {
            Caption = 'Committed Amount';
            Editable = false;
        }
        field(23; "Member Count"; Integer)
        {
            Caption = 'Member Count';
            CalcFormula = count("Group Member Line" where("Group No." = field("No."), Status = const(Active)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(24; "Outstanding Group Loans"; Integer)
        {
            Caption = 'Outstanding Group Loans';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Key2; Name) { }
        key(Key3; "Agent No.") { }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Name) { }
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            SaccoNoSeries.Get;
            SaccoNoSeries.TestField(SaccoNoSeries."Micro Group Nos.");
            "No. Series" := xRec."No. Series";
            "No." := NoSeriesMgt.GetNextNo(SaccoNoSeries."Micro Group Nos.", WorkDate(), true);
        end;
    end;

    procedure UpdateGuaranteeFundFigures()
    var
        Loan: Record "Loans Register";
    begin
        "Committed Amount" := 0;
        "Outstanding Group Loans" := 0;

        Loan.SetRange("Guarantor Group No.", "No.");
        if Loan.FindSet() then
            repeat
                Loan.CalcFields("Outstanding Balance");
                "Committed Amount" += Loan."Outstanding Balance";
                if Loan."Outstanding Balance" <> 0 then
                    "Outstanding Group Loans" += 1;
            until Loan.Next() = 0;
    end;

    var
        SaccoNoSeries: Record "Sacco No. Series";
        NoSeriesMgt: Codeunit "No. Series";
}
