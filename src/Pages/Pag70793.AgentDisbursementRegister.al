page 70793 "Agent Disbursement Register"
{
    Caption = 'Agent Disbursement Register';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    SourceTable = "Loans Register";
    SourceTableView = where("Agent No." = filter(<> ''), "Loan Disbursement Date" = filter(<> 0D));
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
                field("Agent Name"; Rec."Agent Name")
                {
                    ApplicationArea = All;
                }
                field("Loan  No."; Rec."Loan  No.")
                {
                    ApplicationArea = All;
                    Caption = 'Loan No.';
                }
                field("Client Code"; Rec."Client Code")
                {
                    ApplicationArea = All;
                }
                field("Client Name"; Rec."Client Name")
                {
                    ApplicationArea = All;
                }
                field("Loan Product Type"; Rec."Loan Product Type")
                {
                    ApplicationArea = All;
                }
                field("Loan Disbursement Date"; Rec."Loan Disbursement Date")
                {
                    ApplicationArea = All;
                }
                field("Approved Amount"; Rec."Approved Amount")
                {
                    ApplicationArea = All;
                }
                field("Amount Disbursed"; Rec."Amount Disbursed")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
