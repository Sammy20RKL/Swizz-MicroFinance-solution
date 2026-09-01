page 70790 "Agent Performance Summary"
{
    Caption = 'Agent Performance Summary';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    SourceTable = Agents;
    Editable = false;

    layout
    {
        area(content)
        {
            group(Period)
            {
                Caption = 'Period';

                field(StartDate; StartDate)
                {
                    ApplicationArea = All;
                    Caption = 'From Date';
                }
                field(EndDate; EndDate)
                {
                    ApplicationArea = All;
                    Caption = 'To Date';
                }
            }
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Full Name"; Rec."Full Name")
                {
                    ApplicationArea = All;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ApplicationArea = All;
                    Caption = 'Branch';
                }
                field("Customers Onboarded"; Rec."Customers Onboarded")
                {
                    ApplicationArea = All;
                }
                field("Groups Onboarded"; Rec."Groups Onboarded")
                {
                    ApplicationArea = All;
                }
                field("Loans Originated"; Rec."Loans Originated")
                {
                    ApplicationArea = All;
                }
                field("Total Disbursed"; Rec."Total Disbursed")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Portfolio"; Rec."Outstanding Portfolio")
                {
                    ApplicationArea = All;
                }
                field("Current Collections"; Rec."Current Collections")
                {
                    ApplicationArea = All;
                }
                field("Portfolio at Risk (>30 Days)"; Rec."Portfolio at Risk (>30 Days)")
                {
                    ApplicationArea = All;
                    StyleExpr = PARStyleExpr;
                }
                field("Default Rate"; Rec."Default Rate")
                {
                    ApplicationArea = All;
                    StyleExpr = PARStyleExpr;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ApplyPeriod)
            {
                ApplicationArea = All;
                Caption = 'Apply Period';
                Image = Refresh;
                ToolTip = 'Recalculate the figures below for the selected From/To Date range.';

                trigger OnAction()
                begin
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if EndDate = 0D then
            EndDate := WorkDate();
        if StartDate = 0D then
            StartDate := CalcDate('<-CM>', WorkDate());
    end;

    trigger OnAfterGetRecord()
    begin
        Rec.SetRange("Date Filter", StartDate, EndDate);
        Rec.CalcFields(
            "Customers Onboarded",
            "Groups Onboarded",
            "Loans Originated",
            "Total Disbursed",
            "Current Collections");
        Rec.UpdatePortfolioFigures();

        PARStyleExpr := 'Favorable';
        if Rec."Default Rate" > 0 then
            PARStyleExpr := 'Unfavorable';
    end;

    var
        StartDate: Date;
        EndDate: Date;
        PARStyleExpr: Text;
}
