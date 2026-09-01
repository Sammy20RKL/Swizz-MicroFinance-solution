report 70797 "Agent Target Achievement"
{
    ApplicationArea = All;
    Caption = 'Agent Target Achievement';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './Layouts/AgentTargetAchievement.rdl';

    dataset
    {
        dataitem(AgentTarget; "Agent Target")
        {
            DataItemTableView = sorting("Agent No.", "Period", "Target Type") order(ascending);
            RequestFilterFields = "Agent No.", "Period", "Target Type";

            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(ReportFilters; ReportFilters)
            {
            }
            column(ExecutionDate; Today)
            {
            }
            column(PageNo; CurrReport.PageNo)
            {
            }
            column(AgentNo; AgentTarget."Agent No.")
            {
            }
            column(AgentName; AgentTarget."Agent Name")
            {
            }
            column(Period_; AgentTarget.Period)
            {
            }
            column(TargetType; AgentTarget."Target Type")
            {
            }
            column(TargetAmount; AgentTarget."Target Amount")
            {
            }
            column(ActualAmount; AgentTarget."Actual Amount")
            {
            }
            column(AchievementPct; AgentTarget."Achievement %")
            {
            }

            trigger OnAfterGetRecord()
            begin
                AgentTarget.UpdateActual();
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
            }
        }
        actions
        {
        }
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        ReportFilters := AgentTarget.GetFilters();
    end;

    var
        CompanyInfo: Record "Company Information";
        ReportFilters: Text;
}
