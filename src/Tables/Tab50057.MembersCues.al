table 50057 "Members Cues"
{

    fields
    {
        field(1; "User ID"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(2; "All Members"; Integer)
        {
            CalcFormula = count(Customer where("Customer Posting Group" = filter('MICRO' | 'JUNIORS' | ' ')));
            FieldClass = FlowField;
        }

        field(3; "Active Members"; Integer)
        {
            CalcFormula = count(Customer where(Status = const("Active"), "Customer Posting Group" = filter('MICRO')));
            FieldClass = FlowField;
        }
        field(45; "Active Juniors"; Integer)
        {
            CalcFormula = count(Customer where(Status = const("Active"), "Customer Posting Group" = filter('MICRO')));
            FieldClass = FlowField;
        }

        field(4; "NonActive Mbrs"; Integer)
        {
            CalcFormula = count("Member Group" where(Status = const(Active))); //"Customer Posting Group" = filter('MICRO')));
            FieldClass = FlowField;
        }

        field(5; Deceased; Integer)
        {
            CalcFormula = count(Customer where(Status = const(Deceased), "Customer Posting Group" = filter('MICRO')));
            FieldClass = FlowField;
        }

        field(6; Exited; Integer)
        {
            CalcFormula = count(Customer where(Status = const(Withdrawal), "Customer Posting Group" = filter('MICRO')));
            FieldClass = FlowField;
        }
        field(8; "Requests to Approve"; Integer)
        {
            CalcFormula = count("Approval Entry" where("Approver ID" = field("User ID"),
                                                        Status = filter(Open)));
            Caption = 'Requests to Approve';
            FieldClass = FlowField;
        }
        field(9; "Requests Sent for Approval"; Integer)
        {
            CalcFormula = count("Approval Entry" where("Sender ID" = field("User ID"),
                                                        Status = filter(Open)));
            Caption = 'Requests Sent for Approval';
            FieldClass = FlowField;
        }

        field(10; "Awaiting Exit"; Integer)
        {
            CalcFormula = count(Customer where(Status = const("Awaiting Withdrawal"), "Customer Posting Group" = filter('MICRO')));
            FieldClass = FlowField;
        }
        field(13; Female; Integer)
        {
            CalcFormula = count(Customer where(Gender = Const(Female), Status = filter('Active'), "Customer Posting Group" = filter('MICRO')));
            FieldClass = FlowField;
        }
        field(14; Male; Integer)
        {
            CalcFormula = count(Customer where(Gender = Const(Male), Status = filter('Active'), "Customer Posting Group" = filter('MICRO')));
            FieldClass = FlowField;
        }
        field(15; "Agents"; Integer)
        {
            CalcFormula = count(Agents where("Approval Status" = const(Approved)));
            FieldClass = FlowField;
        }

        // ---------- Agent Management Cue ----------
        field(16; "All Agents Count"; Integer)
        {
            Caption = 'All Agents';
            CalcFormula = count(Agents where("Approval Status" = const(Approved)));
            FieldClass = FlowField;
        }
        field(17; "Agents Exited"; Integer)
        {
            Caption = 'Exited Agents';
            CalcFormula = count(Agents where(Status = const(Exited)));
            FieldClass = FlowField;
        }
        // Same >10% Default Rate threshold "Agents at Risk" (Pag70805) already filters on -
        // reusing it here instead of inventing a second threshold.
        field(18; "Agents at Risk"; Integer)
        {
            Caption = 'Agents at Risk';
            CalcFormula = count(Agents where("Default Rate" = filter(> 10)));
            FieldClass = FlowField;
        }
        field(19; "Agent Total Disbursed"; Decimal)
        {
            Caption = 'Total Disbursed';
            CalcFormula = sum("Loans Register"."Approved Amount" where(Posted = const(true), "Agent No." = filter(<> '')));
            FieldClass = FlowField;
        }
        // Total loan repayments collected across all agents. Same filters as
        // Agents."Current Collections", minus the per-agent link - that field is itself
        // a FlowField, so it can't be summed here; the ledger entries are summed directly.
        field(20; "Agent Outstanding Portfolio"; Decimal)
        {
            Caption = 'Current Collection';
            CalcFormula = - sum("Cust. Ledger Entry"."Amount Posted" where("Agent No." = filter(<> ''),
                                                                          "Transaction Type" = filter("Loan Repayment"),
                                                                          Reversed = const(false)));
            FieldClass = FlowField;
        }

        field(21; "Total Disbursed (M)"; Text[20])
        {

            Caption = 'Total Disbursed';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "User ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    // "0.5M", "12.3M" - one decimal place, always in millions, regardless of size.
    // The tile is for a glance; the exact figure is one click away via the tile's
    // own DrillDownPageId, so rounding here loses nothing that isn't already
    // recoverable.
    procedure UpdateTotalDisbursedFormatted()
    var
        MillionsValue: Decimal;
    begin
        CalcFields("Agent Total Disbursed");
        MillionsValue := "Agent Total Disbursed" / 1000000;
        "Total Disbursed (M)" := Format(MillionsValue, 0, '<Precision,1:1>') + 'M';
    end;
}

