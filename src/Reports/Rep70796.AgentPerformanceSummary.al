report 70796 "Agent Performance Summary"
{
    ApplicationArea = All;
    Caption = 'Agent Performance Summary';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './Layouts/AgentPerformanceSummary.rdl';

    dataset
    {
        dataitem(Agent; Agents)
        {
            DataItemTableView = sorting("No.") order(ascending);
            RequestFilterFields = "No.", "Branch Code", "Date Filter";

            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(ReportFilters; ReportFilters)
            {
            }
            column(ExecutionDate; Today)
            {
            }
            column(UserID_; UserId)
            {
            }
            column(PageNo; CurrReport.PageNo)
            {
            }
            column(AgentNo; Agent."No.")
            {
            }
            column(AgentFullName; Agent."Full Name")
            {
            }
            column(BranchCode; Agent."Branch Code")
            {
            }
            column(CustomersOnboarded; Agent."Customers Onboarded")
            {
            }
            column(GroupsOnboarded; Agent."Groups Onboarded")
            {
            }
            column(LoansOriginated; Agent."Loans Originated")
            {
            }
            column(TotalDisbursed; Agent."Total Disbursed")
            {
            }
            column(OutstandingPortfolio; Agent."Outstanding Portfolio")
            {
            }
            column(CurrentCollections; Agent."Current Collections")
            {
            }
            column(PortfolioAtRisk; Agent."Portfolio at Risk (>30 Days)")
            {
            }
            column(DefaultRatePct; Agent."Default Rate")
            {
            }
            column(TotalCustomersOnboarded; TotalCustomersOnboarded)
            {
            }
            column(TotalGroupsOnboarded; TotalGroupsOnboarded)
            {
            }
            column(TotalLoansOriginated; TotalLoansOriginated)
            {
            }
            column(TotalDisbursedSum; TotalDisbursedSum)
            {
            }
            column(TotalOutstandingPortfolio; TotalOutstandingPortfolio)
            {
            }
            column(TotalCurrentCollections; TotalCurrentCollections)
            {
            }
            column(TotalPortfolioAtRisk; TotalPortfolioAtRisk)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Agent.CalcFields(
                    "Customers Onboarded",
                    "Groups Onboarded",
                    "Loans Originated",
                    "Total Disbursed",
                    "Current Collections");
                Agent.UpdatePortfolioFigures();

                TotalCustomersOnboarded += Agent."Customers Onboarded";
                TotalGroupsOnboarded += Agent."Groups Onboarded";
                TotalLoansOriginated += Agent."Loans Originated";
                TotalDisbursedSum += Agent."Total Disbursed";
                TotalOutstandingPortfolio += Agent."Outstanding Portfolio";
                TotalCurrentCollections += Agent."Current Collections";
                TotalPortfolioAtRisk += Agent."Portfolio at Risk (>30 Days)";
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
        ReportFilters := Agent.GetFilters();
    end;

    var
        CompanyInfo: Record "Company Information";
        ReportFilters: Text;
        TotalCustomersOnboarded: Integer;
        TotalGroupsOnboarded: Integer;
        TotalLoansOriginated: Integer;
        TotalDisbursedSum: Decimal;
        TotalOutstandingPortfolio: Decimal;
        TotalCurrentCollections: Decimal;
        TotalPortfolioAtRisk: Decimal;
}
