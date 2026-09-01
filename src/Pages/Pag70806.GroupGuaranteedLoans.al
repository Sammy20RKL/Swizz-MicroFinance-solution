page 70806 "Group Guaranteed Loans"
{
    Caption = 'Guaranteed Loans';
    PageType = ListPart;
    SourceTable = "Loans Register";
    Editable = false;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
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
                field("Loan Disbursement Date"; Rec."Loan Disbursement Date")
                {
                    ApplicationArea = All;
                }
                field("Approved Amount"; Rec."Approved Amount")
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
                field("Loan Status"; Rec."Loan Status")
                {
                    ApplicationArea = All;
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
