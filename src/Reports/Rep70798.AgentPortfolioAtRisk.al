report 70798 "Agent Portfolio at Risk"
{
    ApplicationArea = All;
    Caption = 'Agent Portfolio at Risk';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './Layouts/AgentPortfolioAtRisk.rdl';

    dataset
    {
        dataitem(Loan; "Loans Register")
        {
            DataItemTableView = sorting("Agent No.") order(ascending) where("Agent No." = filter(<> ''));
            RequestFilterFields = "Agent No.", "Guarantor Group No.", "Days In Arrears", "Loans Category-SASRA";

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
            column(AgentNo; Loan."Agent No.")
            {
            }
            column(AgentName; Loan."Agent Name")
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
            column(GuarantorGroupNo; Loan."Guarantor Group No.")
            {
            }
            column(LoanDisbursementDate; Loan."Loan Disbursement Date")
            {
            }
            column(OutstandingBalance; Loan."Outstanding Balance")
            {
            }
            column(DaysInArrears; Loan."Days In Arrears")
            {
            }
            column(RiskClassification; Loan."Loans Category-SASRA")
            {
            }
            column(TotalOutstandingBalance; TotalOutstandingBalance)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Loan.CalcFields("Outstanding Balance");
                TotalOutstandingBalance += Loan."Outstanding Balance";
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
        ReportFilters := Loan.GetFilters();
    end;

    var
        CompanyInfo: Record "Company Information";
        ReportFilters: Text;
        TotalOutstandingBalance: Decimal;
}
