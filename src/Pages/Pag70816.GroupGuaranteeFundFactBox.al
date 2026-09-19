#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
page 70816 "Group Guarantee Fund FactBox"
{
    Caption = 'Guarantee Fund';
    PageType = CardPart;
    SourceTable = "Member Group";
    Editable = false;

    layout
    {
        area(content)
        {
            field("Member Count"; Rec."Member Count")
            {
                ApplicationArea = All;
                DrillDown = true;
            }
            field("Total Contributions"; Rec."Total Contributions")
            {
                ApplicationArea = All;
                DrillDown = true;
            }
            field("Committed Amount"; Rec."Committed Amount")
            {
                ApplicationArea = All;
                DrillDown = true;
            }
            field("Available Guarantee Balance"; AvailableGuaranteeBalance)
            {
                ApplicationArea = All;
                Caption = 'Available Guarantee Balance';
                Editable = false;
                StyleExpr = AvailableStyleExpr;
            }
            field("Outstanding Group Loans"; Rec."Outstanding Group Loans")
            {
                ApplicationArea = All;
                DrillDown = true;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Total Contributions");
        Rec.UpdateGuaranteeFundFigures();
        AvailableGuaranteeBalance := Rec."Total Contributions" - Rec."Committed Amount";

        if AvailableGuaranteeBalance < 0 then
            AvailableStyleExpr := 'Unfavorable'
        else
            AvailableStyleExpr := 'Favorable';
    end;

    var
        AvailableGuaranteeBalance: Decimal;
        AvailableStyleExpr: Text;
}
