report 70809 "Group Contribution Register"
{
    ApplicationArea = All;
    Caption = 'Group Contribution Register';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './Layouts/GroupContributionRegister.rdl';

    dataset
    {
        dataitem(Contribution; "Group Contribution")
        {
            DataItemTableView = sorting("Group No.", "Posting Date") order(ascending);
            RequestFilterFields = "Group No.", "Member No.", "Posting Date", "Contribution Type";

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
            column(GroupNo; Contribution."Group No.")
            {
            }
            column(PostingDate; Contribution."Posting Date")
            {
            }
            column(MemberNo; Contribution."Member No.")
            {
            }
            column(MemberName; Contribution."Member Name")
            {
            }
            column(ContributionType; Contribution."Contribution Type")
            {
            }
            column(Amount_; Contribution.Amount)
            {
            }
            column(PostedBy; Contribution."Posted By")
            {
            }
            column(TotalAmount; TotalAmount)
            {
            }

            trigger OnAfterGetRecord()
            begin
                TotalAmount += Contribution.Amount;
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
        ReportFilters := Contribution.GetFilters();
    end;

    var
        CompanyInfo: Record "Company Information";
        ReportFilters: Text;
        TotalAmount: Decimal;
}
