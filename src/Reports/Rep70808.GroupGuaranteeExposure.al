report 70808 "Group Guarantee Exposure"
{
    ApplicationArea = All;
    Caption = 'Group Guarantee Exposure';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './Layouts/GroupGuaranteeExposure.rdl';

    dataset
    {
        dataitem(Loan; "Loans Register")
        {
            DataItemTableView = sorting("Guarantor Group No.") order(ascending) where("Guarantor Group No." = filter(<> ''));
            RequestFilterFields = "Guarantor Group No.", "Days In Arrears", "Loan Status";

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
            column(GuarantorGroupNo; Loan."Guarantor Group No.")
            {
            }
            column(GroupName; GroupName)
            {
            }
            column(LoanNo; Loan."Loan  No.")
            {
            }
            column(ClientCode; Loan."Client Code")
            {
            }
            column(ClientName; Loan."Client Name")
            {
            }
            column(LoanDisbursementDate; Loan."Loan Disbursement Date")
            {
            }
            column(ApprovedAmount; Loan."Approved Amount")
            {
            }
            column(OutstandingBalance; Loan."Outstanding Balance")
            {
            }
            column(DaysInArrears; Loan."Days In Arrears")
            {
            }
            column(LoanStatus_; Loan."Loan Status")
            {
            }
            column(TotalOutstandingBalance; TotalOutstandingBalance)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Loan.CalcFields("Outstanding Balance");
                TotalOutstandingBalance += Loan."Outstanding Balance";

                GroupName := '';
                if Group.Get(Loan."Guarantor Group No.") then
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
        ReportFilters := Loan.GetFilters();
    end;

    var
        CompanyInfo: Record "Company Information";
        Group: Record "Member Group";
        ReportFilters: Text;
        GroupName: Text[100];
        TotalOutstandingBalance: Decimal;
}
