page 70803 "Agent Targets Setup"
{
    Caption = 'Agent Targets';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Agent Target";

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

    actions
    {
        area(Processing)
        {
            action("Copy Targets to Next Period")
            {
                ApplicationArea = All;
                Caption = 'Copy Targets to Next Period';
                Image = CopyDocument;
                ToolTip = 'Create next month''s targets for every agent/target type that had one in the latest period, at the same amount.';

                trigger OnAction()
                var
                    AgentTarget: Record "Agent Target";
                    Created: Integer;
                begin
                    Created := AgentTarget.CopyTargetsToNextPeriod();
                    if Created = 0 then
                        Message('No new targets were created - the next period may already have targets, or there are no targets on file yet.')
                    else
                        Message('%1 target(s) created for the next period.', Created);
                    CurrPage.Update(false);
                end;
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
