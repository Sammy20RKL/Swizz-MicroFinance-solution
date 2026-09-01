page 70805 "Agents at Risk"
{
    Caption = 'Agents at Risk';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Agents;
    SourceTableView = sorting("Default Rate") order(descending) where("Default Rate" = filter(> 10));
    CardPageId = "Agent Cards";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Full Name"; Rec."Full Name")
                {
                    ApplicationArea = All;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ApplicationArea = All;
                    Caption = 'Branch';
                }
                field("Outstanding Portfolio"; Rec."Outstanding Portfolio")
                {
                    ApplicationArea = All;
                }
                field("Portfolio at Risk (>30 Days)"; Rec."Portfolio at Risk (>30 Days)")
                {
                    ApplicationArea = All;
                }
                field("Default Rate"; Rec."Default Rate")
                {
                    ApplicationArea = All;
                    StyleExpr = 'Unfavorable';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RefreshFigures)
            {
                ApplicationArea = All;
                Caption = 'Refresh Risk Figures';
                Image = Refresh;
                ToolTip = 'Recalculate Outstanding Portfolio, Portfolio at Risk and Default Rate for every agent, then reapply this list''s filter.';

                trigger OnAction()
                var
                    AgentRiskRefresh: Codeunit "Agent Risk Refresh";
                    RefreshedCount: Integer;
                begin
                    RefreshedCount := AgentRiskRefresh.RefreshAll();
                    Message('%1 agent(s) refreshed.', RefreshedCount);
                    CurrPage.Update(false);
                end;
            }
        }
    }
}
