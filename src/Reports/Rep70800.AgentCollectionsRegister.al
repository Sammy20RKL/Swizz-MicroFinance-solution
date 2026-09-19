report 70800 "Agent Collections Register"
{
    ApplicationArea = All;
    Caption = 'Agent Collections Register';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './Layouts/AgentCollectionsRegister.rdl';

    dataset
    {
        dataitem(CustLedgerEntry; "Cust. Ledger Entry")
        {
            DataItemTableView = sorting("Agent No.", "Posting Date") order(ascending)
                                 where("Agent No." = filter(<> ''),
                                       "Transaction Type" = filter("Loan Repayment"),
                                       Reversed = const(false));
            RequestFilterFields = "Agent No.", "Posting Date";

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
            column(AgentNo; CustLedgerEntry."Agent No.")
            {
            }
            column(PostingDate; CustLedgerEntry."Posting Date")
            {
            }
            column(CustomerNo; CustLedgerEntry."Customer No.")
            {
            }
            column(MemberName; CustLedgerEntry."Member Name")
            {
            }
            column(LoanNo; CustLedgerEntry."Loan No")
            {
            }
            column(AmountPosted; CustLedgerEntry."Amount Posted")
            {
            }
            column(TotalAmountPosted; TotalAmountPosted)
            {
            }

            trigger OnAfterGetRecord()
            begin
                TotalAmountPosted += CustLedgerEntry."Amount Posted";
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
        ReportFilters := CustLedgerEntry.GetFilters();
    end;

    var
        CompanyInfo: Record "Company Information";
        ReportFilters: Text;
        TotalAmountPosted: Decimal;
}
