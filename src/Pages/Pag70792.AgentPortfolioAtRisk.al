page 70792 "Agent Portfolio at Risk"
{
    Caption = 'Agent Portfolio at Risk';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    SourceTable = "Loans Register";
    SourceTableView = where("Agent No." = filter(<> ''));
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
                field("Guarantor Group No."; Rec."Guarantor Group No.")
                {
                    ApplicationArea = All;
                }
                field("Loan Disbursement Date"; Rec."Loan Disbursement Date")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Balance"; Rec."Outstanding Balance")
                {
                    ApplicationArea = All;
                    StyleExpr = RiskStyleExpr;
                }
                field("Days In Arrears"; Rec."Days In Arrears")
                {
                    ApplicationArea = All;
                    StyleExpr = RiskStyleExpr;
                }
                field("Loans Category-SASRA"; Rec."Loans Category-SASRA")
                {
                    ApplicationArea = All;
                    Caption = 'Risk Classification';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Outstanding Balance");

        RiskStyleExpr := 'Favorable';
        if Rec."Days In Arrears" > 30 then
            RiskStyleExpr := 'Unfavorable';
    end;

    var
        RiskStyleExpr: Text;
}
