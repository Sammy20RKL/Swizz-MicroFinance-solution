report 70810 "Group Membership Roster"
{
    ApplicationArea = All;
    Caption = 'Group Membership Roster';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './Layouts/GroupMembershipRoster.rdl';

    dataset
    {
        dataitem(GroupMember; "Group Member Line")
        {
            DataItemTableView = sorting("Group No.", "Member No.") order(ascending);
            RequestFilterFields = "Group No.", Role, Status;

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
            column(GroupNo; GroupMember."Group No.")
            {
            }
            column(GroupName; GroupName)
            {
            }
            column(MemberNo; GroupMember."Member No.")
            {
            }
            column(MemberName; GroupMember."Member Name")
            {
            }
            column(Role_; GroupMember.Role)
            {
            }
            column(MemberStatus; GroupMember.Status)
            {
            }
            column(DateJoined; GroupMember."Date Joined")
            {
            }
            column(DateExited; GroupMember."Date Exited")
            {
            }
            column(MemberContributionBalance; GroupMember."Member Contribution Balance")
            {
            }

            trigger OnAfterGetRecord()
            begin
                GroupMember.CalcFields("Member Contribution Balance");

                GroupName := '';
                if Group.Get(GroupMember."Group No.") then
                    GroupName := Group.Name;
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
        ReportFilters := GroupMember.GetFilters();
    end;

    var
        CompanyInfo: Record "Company Information";
        Group: Record "Member Group";
        ReportFilters: Text;
        GroupName: Text[100];
}
