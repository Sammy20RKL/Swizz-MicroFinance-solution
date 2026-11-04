page 70791 "Agent Target Achievement"
{
    Caption = 'Agent Target Achievement';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    SourceTable = "Agent Target";
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
                field(Period; Rec.Period)
                {
                    ApplicationArea = All;
                }
                field("Target Type"; Rec."Target Type")
                {
                    ApplicationArea = All;
                }
                field("Target Amount"; Rec."Target Amount")
                {
                    ApplicationArea = All;
                }
                field("Actual Amount"; Rec."Actual Amount1")
                {
                    ApplicationArea = All;
                }
                field("Achievement %"; Rec."Achievement %")
                {
                    ApplicationArea = All;
                    StyleExpr = AchievementStyleExpr;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.UpdateActual();

        AchievementStyleExpr := 'Unfavorable';
        if Rec."Achievement %" >= 100 then
            AchievementStyleExpr := 'Favorable';
    end;

    var
        AchievementStyleExpr: Text;
}
