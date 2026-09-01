report 70801 "Agent Member Onboarding"
{
    ApplicationArea = All;
    Caption = 'Agent Member Onboarding';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './Layouts/AgentMemberOnboarding.rdl';

    dataset
    {
        dataitem(Member; Customer)
        {
            DataItemTableView = sorting("Agent No.") order(ascending) where("Agent No." = filter(<> ''));
            RequestFilterFields = "Agent No.", "Registration Date", "Group No.";

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
            column(AgentNo; Member."Agent No.")
            {
            }
            column(MemberNo; Member."No.")
            {
            }
            column(MemberName; Member.Name)
            {
            }
            column(RegistrationDate; Member."Registration Date")
            {
            }
            column(GroupNo; Member."Group No.")
            {
            }
            column(TotalMembers; TotalMembers)
            {
            }

            trigger OnAfterGetRecord()
            begin
                TotalMembers += 1;
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
        ReportFilters := Member.GetFilters();
    end;

    var
        CompanyInfo: Record "Company Information";
        ReportFilters: Text;
        TotalMembers: Integer;
}
