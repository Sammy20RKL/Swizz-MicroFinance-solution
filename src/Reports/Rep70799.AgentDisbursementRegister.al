report 70799 "Agent Disbursement Register"
{
    ApplicationArea = All;
    Caption = 'Agent Disbursement Register';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './Layouts/AgentDisbursementRegister.rdl';

    dataset
    {
        dataitem(Loan; "Loans Register")
        {
            DataItemTableView = sorting("Agent No.") order(ascending) where("Agent No." = filter(<> ''), "Loan Disbursement Date" = filter(<> 0D));
            RequestFilterFields = "Agent No.", "Loan Disbursement Date", "Loan Product Type";

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
            column(LoanProductType; Loan."Loan Product Type")
            {
            }
            column(LoanDisbursementDate; Loan."Loan Disbursement Date")
            {
            }
            column(ApprovedAmount; Loan."Approved Amount")
            {
            }
            column(AmountDisbursed; Loan."Amount Disbursed")
            {
            }
            column(TotalAmountDisbursed; TotalAmountDisbursed)
            {
            }

            trigger OnAfterGetRecord()
            begin
                TotalAmountDisbursed += Loan."Amount Disbursed";
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
        ReportFilters: Text;
        TotalAmountDisbursed: Decimal;
}
