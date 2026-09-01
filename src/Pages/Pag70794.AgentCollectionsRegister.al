page 70794 "Agent Collections Register"
{
    Caption = 'Agent Collections Register';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    SourceTable = "Cust. Ledger Entry";
    SourceTableView = where("Agent No." = filter(<> ''),
                             "Transaction Type" = filter("Loan Repayment"),
                             Reversed = const(false));
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Agent No."; Rec."Agent No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Member Name"; Rec."Member Name")
                {
                    ApplicationArea = All;
                }
                field("Loan No"; Rec."Loan No")
                {
                    ApplicationArea = All;
                }
                field("Amount Posted"; Rec."Amount Posted")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
