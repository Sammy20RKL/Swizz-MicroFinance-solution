page 70787 "Agent Statistics FactBox"
{
    Caption = 'Agent FactBox';
    Editable = false;
    PageType = CardPart;
    SourceTable = Agents;

    layout
    {
        area(content)
        {
            // field(Image; Rec.Image)
            // {
            //     ApplicationArea = All;
            //     Caption = 'Agent';
            // }
            group("Performance (YTD)")
            {
                Caption = 'Performance (YTD)';

                field("Customers Onboarded"; Rec."Customers Onboarded")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                }
                field("Groups Onboarded"; Rec."Groups Onboarded")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                }
                field("Loans Originated"; Rec."Loans Originated")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                }
                field("Total Disbursed"; Rec."Total Disbursed")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                }
                field("Outstanding Portfolio"; Rec."Outstanding Portfolio")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                }
                field("Current Collections"; Rec."Current Collections")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                }
                field("Interest Paid"; Rec."Interest Paid")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                }
                field("Portfolio at Risk (>30 Days)"; Rec."Portfolio at Risk (>30 Days)")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    StyleExpr = PARStyleExpr;
                }
                field("Default Rate"; Rec."Default Rate")
                {
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = PARStyleExpr;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields(
            "Customers Onboarded",
            "Groups Onboarded",
            "Loans Originated",
            "Total Disbursed",
            "Current Collections");
        Rec.UpdatePortfolioFigures();

        PARStyleExpr := 'Unfavorable';
        if Rec."Default Rate" = 0 then
            PARStyleExpr := 'Favorable';
    end;

    var
        PARStyleExpr: Text;
}
