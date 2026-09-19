table 59066 "Agents"
{
    Caption = 'Agent';
    DrillDownPageId = 70777;
    LookupPageId = 70777;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    SalesSetup.Get;
                    NoSeriesMgt.TestManual(SalesSetup."Agent No");
                    "No. Series" := '';
                end;
            end;
        }
        field(28; Image; Media)
        {
            Caption = 'Image';
        }
        field(2; "Full Name"; Text[100])
        {
            Caption = 'Full Name';
            NotBlank = true;
        }
        field(3; "National ID"; Code[20])
        {
            Caption = 'National ID';
            trigger OnValidate()
            var
                Agent2: Record Agent;
            begin
                // if "National ID" = '' then exit;
                // Agent2.SetRange("National ID", "National ID");
                // Agent2.SetFilter("No.", '<>%1', "No.");
                // if not Agent2.IsEmpty then
                //     Error('National ID %1 already belongs to another agent.', "National ID");
            end;
        }
        field(4; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(5; "Email"; Text[80])
        {
            Caption = 'Email';
            ExtendedDatatype = EMail;
        }
        field(6; "Region Code"; Code[20])
        {
            Caption = 'Region';
            TableRelation = "Region".Code;
        }
        // Filtered to branches within the selected Region - same cascading-filter
        // technique as "Guarantor Group No." on Loans Register, one level up.
        field(7; "Branch Code"; Code[20])
        {
            Caption = 'Branch';
            TableRelation = "Branch".Code where("Region Code" = field("Region Code"));

            trigger OnValidate()
            var
                BranchRec: Record "Branch";
            begin
                if "Branch Code" = '' then
                    exit;
                if "Region Code" = '' then
                    Error('Please select a Region before selecting a Branch.');
                BranchRec.Get("Branch Code");
                if BranchRec."Region Code" <> "Region Code" then
                    Error('Branch %1 does not belong to Region %2.', "Branch Code", "Region Code");
            end;
        }
        field(8; "Date Joined"; Date)
        {
            Caption = 'Date Joined';
        }
        field(9; "Status"; Option)
        {
            Caption = 'Status';
            OptionMembers = Active,Inactive,Suspended,Exited;

            trigger OnValidate()
            begin
                if "Status" <> xRec."Status" then
                    "Status Change Date" := Today;
            end;
        }
        field(29; "Status Change Date"; Date)
        {
            Caption = 'Status Change Date';
            Editable = false;
        }
        field(30; "Status Change Reason"; Text[100])
        {
            Caption = 'Status Change Reason';
        }
        field(10; "Approval Status"; Option)
        {
            OptionCaption = 'Open,Pending Approval,Approved,Rejected,Closed';
            OptionMembers = Open,"Pending Approval",Approved,Rejected,Closed;

        }

        // ---------- Performance (YTD) ----------
        // All figures are derived, live aggregations off the same Loans Register /
        // Cust. Ledger Entry data every other module reads - nothing here is a
        // separately maintained snapshot, so it can never drift out of sync.
        // Date-ranged views (e.g. "this month") are obtained by setting a filter
        // on the standard "Date Filter" FlowFilter before calling CalcFields.
        // "Outstanding Portfolio" and "Portfolio at Risk" are the exception: see the
        // note above field 24 for why those two are plain fields refreshed in code.

        field(15; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(20; "Customers Onboarded"; Integer)
        {
            Caption = 'Customers Onboarded';
            CalcFormula = count(Customer where("Agent No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(21; "Groups Onboarded"; Integer)
        {
            Caption = 'Groups Onboarded';
            CalcFormula = count("Member Group" where("Agent No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(22; "Loans Originated"; Integer)
        {
            Caption = 'Loans Originated';
            CalcFormula = count("Loans Register" where("Agent No." = field("No."),
                                                         "Loan Disbursement Date" = field("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        // "Approved Amount", not "Amount Disbursed" - see the matching field on
        // "Members Cues" for why: it's reliably populated on every loan, including
        // ones posted before the POST action was fixed to also set "Amount Disbursed",
        // and identical to it for every loan posted since that fix.
        field(23; "Total Disbursed"; Decimal)
        {
            Caption = 'Total Disbursed';
            CalcFormula = sum("Loans Register"."Approved Amount" where("Agent No." = field("No."),
                                                                        "Loan Disbursement Date" = field("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        // "Outstanding Portfolio" and "Portfolio at Risk (>30 Days)" cannot be
        // FlowFields: "Outstanding Balance" on Loans Register is itself a FlowField
        // (computed from Cust. Ledger Entry), and SQL Server has no physical column
        // to aggregate for a FlowField-of-a-FlowField - summing it as a CalcFormula
        // compiles but throws "Invalid column name 'Outstanding Balance'" at runtime.
        // These are plain fields instead, refreshed by UpdatePortfolioFigures().
        field(24; "Outstanding Portfolio"; Decimal)
        {
            Caption = 'Outstanding Portfolio';
            Editable = false;
        }
        field(25; "Current Collections"; Decimal)
        {
            Caption = 'Current Collections';
            CalcFormula = - sum("Cust. Ledger Entry"."Amount Posted" where("Agent No." = field("No."),
                                                                          "Transaction Type" = filter("Loan Repayment"),
                                                                          "Posting Date" = field("Date Filter"),
                                                                          Reversed = const(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(26; "Portfolio at Risk (>30 Days)"; Decimal)
        {
            Caption = 'Portfolio at Risk (>30 Days)';
            Editable = false;
        }
        field(27; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        // "Default Rate" = "Portfolio at Risk (>30 Days)" ÷ "Outstanding Portfolio" × 100.
        // Stored (not a FlowField) so it can be filtered on directly - e.g. by the
        // "Agents at Risk" list and the risk notification on the Agent Card - without
        // every caller re-deriving the ratio itself. Refreshed by UpdatePortfolioFigures().
        field(31; "Default Rate"; Decimal)
        {
            Caption = 'Default Rate %';
            Editable = false;
            DecimalPlaces = 2 : 2;
        }
    }

    keys
    {
        key(PK; "No.") { Clustered = true; }
        key(Key2; "Full Name") { }
        key(Key3; "National ID") { }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Full Name", "Phone No.")
        { }
    }
    trigger OnInsert()
    begin
        if "No." = '' then begin
            SalesSetup.Get;
            SalesSetup.TestField(SalesSetup."Agent No");
            "No. Series" := xRec."No. Series";
            "No." := NoSeriesMgt.GetNextNo(SalesSetup."Agent No", WorkDate(), true);
        end;
    end;

    // Moves the selected parts of the agent's book - members, groups and/or loans -
    // to another agent in one step, so an exit or territory change doesn't leave
    // records pointing at an agent nobody is following up. Callers choose which
    // categories to move; unselected categories stay with this agent. Logs a row
    // to Agent Reassignment Log so the move is auditable after the fact.
    procedure ReassignPortfolioTo(NewAgentNo: Code[20]; Reason: Text[100]; ReassignMembers: Boolean; ReassignGroups: Boolean; ReassignLoans: Boolean)
    var
        NewAgent: Record Agents;
        Member: Record Customer;
        Group: Record "Member Group";
        Loan: Record "Loans Register";
        ReassignmentLog: Record "Agent Reassignment Log";
        MembersMoved: Integer;
        GroupsMoved: Integer;
        LoansMoved: Integer;
    begin
        TestField("No.");
        if NewAgentNo = "No." then
            Error('The new agent cannot be the same as the current agent.');
        if not (ReassignMembers or ReassignGroups or ReassignLoans) then
            Error('Select at least one of Members, Groups or Loans to reassign.');
        NewAgent.Get(NewAgentNo);

        if ReassignMembers then begin
            Member.SetRange("Agent No.", "No.");
            if Member.FindSet(true) then
                repeat
                    Member."Agent No." := NewAgentNo;
                    Member.Modify();
                    MembersMoved += 1;
                until Member.Next() = 0;
        end;

        if ReassignGroups then begin
            Group.SetRange("Agent No.", "No.");
            if Group.FindSet(true) then
                repeat
                    Group."Agent No." := NewAgentNo;
                    Group.Modify();
                    GroupsMoved += 1;
                until Group.Next() = 0;
        end;

        if ReassignLoans then begin
            Loan.SetRange("Agent No.", "No.");
            if Loan.FindSet(true) then
                repeat
                    Loan."Agent No." := NewAgentNo;
                    Loan.Modify();
                    LoansMoved += 1;
                until Loan.Next() = 0;
        end;

        ReassignmentLog.Init();
        ReassignmentLog."From Agent No." := "No.";
        ReassignmentLog."To Agent No." := NewAgentNo;
        ReassignmentLog.Reason := Reason;
        ReassignmentLog."Members Moved" := MembersMoved;
        ReassignmentLog."Groups Moved" := GroupsMoved;
        ReassignmentLog."Loans Moved" := LoansMoved;
        ReassignmentLog.Insert(true);
    end;

    procedure UpdatePortfolioFigures()
    var
        Loan: Record "Loans Register";
    begin
        "Outstanding Portfolio" := 0;
        "Portfolio at Risk (>30 Days)" := 0;

        Loan.SetRange("Agent No.", "No.");
        if Loan.FindSet() then
            repeat
                Loan.CalcFields("Outstanding Balance");
                "Outstanding Portfolio" += Loan."Outstanding Balance";
                // "Days In Arrears" is the same field the Loan Aging job maintains for
                // every other aging report in this system - using it here (instead of
                // the SASRA Performing/Watch/... classification) is what actually makes
                // the ">30 Days" in the caption true.
                if Loan."Days In Arrears" > 30 then
                    "Portfolio at Risk (>30 Days)" += Loan."Outstanding Balance";
            until Loan.Next() = 0;

        if "Outstanding Portfolio" <> 0 then
            "Default Rate" := Round(("Portfolio at Risk (>30 Days)" / "Outstanding Portfolio") * 100, 0.01)
        else
            "Default Rate" := 0;
    end;

    var
        SalesSetup: Record "Sacco No. Series";
        NoSeriesMgt: Codeunit "No. Series";
}