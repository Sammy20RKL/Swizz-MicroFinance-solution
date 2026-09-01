page 70778 "Agent Target Subpage"
{
    Caption = 'Targets (Monthly)';
    PageType = ListPart;
    SourceTable = "Agent Target";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Agent No."; Rec."Agent No.")
                {
                    Editable = false;
                    ApplicationArea = Basic;
                }
                field("Target Type"; Rec."Target Type")
                {
                    ApplicationArea = All;
                }
                field("Target Amount"; Rec."Target Amount")
                {
                    ApplicationArea = All;
                }
                field("Actual Amount"; Rec."Actual Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Achievement %"; Rec."Achievement %")
                {
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = AchievementStyleExpr;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.UpdateActual();

        if Rec."Achievement %" >= 100 then
            AchievementStyleExpr := 'Favorable'
        else
            AchievementStyleExpr := 'Unfavorable';
    end;

    var
        AchievementStyleExpr: Text;
}