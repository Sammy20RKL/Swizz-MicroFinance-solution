report 70807 "Group Performance Summary"
{
    ApplicationArea = All;
    Caption = 'Group Performance Summary';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './Layouts/GroupPerformanceSummary.rdl';

    dataset
    {
        dataitem(Group; "Member Group")
        {
            DataItemTableView = sorting("No.") order(ascending);
            RequestFilterFields = "No.", "Agent No.", "Branch Code", Status;

            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CompanyPic; CompanyInfo.Picture)
            {
            }
            column(CompanyAddress; CompanyInfo.Address)
            {
            }
            column(CompanyAddress2; CompanyInfo."Address 2")
            {
            }
            column(CompanyPhoneNo; CompanyInfo."Phone No.")
            {
            }
            column(CompanyFaxNo; CompanyInfo."Fax No.")
            {
            }
            column(CompanyEmail; CompanyInfo."E-Mail")
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
            column(GroupNo; Group."No.")
            {
            }
            column(GroupName; Group.Name)
            {
            }
            column(AgentNo; Group."Agent No.")
            {
            }
            column(AgentName; Group."Agent Name")
            {
            }
            column(BranchCode; Group."Branch Code")
            {
            }
            column(GroupStatus; Group.Status)
            {
            }
            column(MemberCount; Group."Member Count")
            {
            }
            column(TotalContributions; Group."Total Contributions")
            {
            }
            column(CommittedAmount; Group."Committed Amount")
            {
            }
            column(AvailableBalance; AvailableBalance)
            {
            }
            column(OutstandingGroupLoans; Group."Outstanding Group Loans")
            {
            }
            column(TotalMemberCount; TotalMemberCount)
            {
            }
            column(TotalContributionsSum; TotalContributionsSum)
            {
            }
            column(TotalCommittedAmount; TotalCommittedAmount)
            {
            }
            column(TotalAvailableBalance; TotalAvailableBalance)
            {
            }
            column(TotalOutstandingGroupLoans; TotalOutstandingGroupLoans)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Group.CalcFields("Total Contributions", "Member Count");
                Group.UpdateGuaranteeFundFigures();
                AvailableBalance := Group."Total Contributions" - Group."Committed Amount";

                TotalMemberCount += Group."Member Count";
                TotalContributionsSum += Group."Total Contributions";
                TotalCommittedAmount += Group."Committed Amount";
                TotalAvailableBalance += AvailableBalance;
                TotalOutstandingGroupLoans += Group."Outstanding Group Loans";
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
        CompanyInfo.CalcFields(CompanyInfo.Picture);
        ReportFilters := Group.GetFilters();
    end;

    var
        CompanyInfo: Record "Company Information";
        ReportFilters: Text;
        AvailableBalance: Decimal;
        TotalMemberCount: Integer;
        TotalContributionsSum: Decimal;
        TotalCommittedAmount: Decimal;
        TotalAvailableBalance: Decimal;
        TotalOutstandingGroupLoans: Integer;
}
