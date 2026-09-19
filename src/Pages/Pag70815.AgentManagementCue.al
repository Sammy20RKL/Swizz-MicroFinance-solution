#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
page 70815 "Agent Management Cue"
{
    PageType = CardPart;
    SourceTable = "Members Cues";
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            cuegroup(AgentPortfolio)
            {
                Caption = 'Agent Portfolio';
                field("All Agents Count"; Rec."All Agents Count")
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = StandardAccent;
                    StyleExpr = true;
                    DrillDownPageId = "Agent Lists";
                }
                field("Agents"; Rec.Agents)
                {
                    ApplicationArea = Basic;
                    Caption = 'Active Agents';
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                    DrillDownPageId = "Agent Lists";

                }
                field("Agents at Risk"; Rec."Agents at Risk")
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Unfavorable;
                    StyleExpr = true;
                    DrillDownPageId = "Agents at Risk";
                }
                field("Agents Exited"; Rec."Agents Exited")
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = StrongAccent;
                    StyleExpr = true;
                    DrillDownPageId = "Agent Lists";
                }
            }
            cuegroup(AgentBook)
            {
                Caption = 'Book, All Time';
                // Back to the raw figure for the meantime - the "M" formatted text
                // version ("Total Disbursed (M)" on Members Cues) is still there,
                // just not bound here, in case it's worth revisiting later.
                field("Agent Total Disbursed"; Rec."Agent Total Disbursed")
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = Favorable;
                    StyleExpr = true;
                    DrillDownPageId = "Agent Lists";
                }
                field("Agent Outstanding Portfolio"; Rec."Agent Outstanding Portfolio")
                {
                    ApplicationArea = Basic;
                    Image = none;
                    Style = StandardAccent;
                    StyleExpr = true;
                    DrillDownPageId = "Agent Lists";
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get(UserId) then begin
            Rec.Init;
            Rec."User ID" := UserId;
            Rec.Insert;
        end;
        Rec.UpdateTotalDisbursedFormatted();
        Rec.Modify();
    end;

    // RefreshOnActivate re-fires this, not OnOpenPage - the formatted text is a plain
    // field, not a FlowField, so it needs an explicit refresh here to avoid going
    // stale between visits the way a live FlowField never would.
    trigger OnAfterGetRecord()
    begin
        Rec.UpdateTotalDisbursedFormatted();
        Rec.Modify();
    end;
}
