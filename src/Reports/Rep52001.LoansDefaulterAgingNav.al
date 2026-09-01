report 52001 "Loans Defaulter Aging Nav"
{
    ApplicationArea = All;
    Caption = 'Loans Defaulter Aging';
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Loans Defaulter Aging.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Loans Register"; "Loans Register")
        {
            DataItemTableView = where(Posted = const(true), "Outstanding Balance" = filter(> 0));
            RequestFilterFields = "Client Code", "Loan Product Type", "Outstanding Balance", "Loans Category-SASRA";
            column(ReportForNavId_4645; 4645)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }

            column(Company_Name; Company.Name)
            {
            }

            column(Company_Address; Company.Address)
            {
            }
            column(Company_Address_2; Company."Address 2")
            {
            }
            column(Company_Phone_No; Company."Phone No.")
            {
            }
            column(Company_Fax_No; Company."Fax No.")
            {
            }
            column(Company_Picture; Company.Picture)
            {
            }
            column(Company_Email; Company."E-Mail")
            {
            }
            column(CurrReport_PAGENO; CurrReport.PageNo)
            {
            }
            column(USERID; UserId)
            {
            }
            column(Loans__Loan__No__; "Loan  No.")
            {
            }
            column(Arrears; "Loans Register"."Amount in Arrears")
            {
            }
            column(Loans__Loan_Product_Type_; "Loan Product Type")
            {
            }
            column(Loans_Loans__Staff_No_; "Loans Register"."Staff No")
            {
            }
            column(Loans__Client_Name_; "Client Name")
            {
            }

            column(ClientCode_LoansRegister; "Loans Register"."Client Code")
            {
            }

            column(Loans_Loans__Outstanding_Balance_; "Loans Register"."Outstanding Balance")
            {
            }

            column(V2Month_; "2Month")
            {
            }

            column(V3Month_; "3Month")
            {
            }

            column(Over3Month; Over3Month)
            {
            }

            column(V1Month_; "1Month")
            {
            }

            column(V0Month_; "0Month")
            {
            }

            column(AmountinArrears_LoansRegister; "Loans Register"."Amount in Arrears")
            {
            }

            column(NoofMonthsinArrears_LoansRegister; "Loans Register"."No of Months in Arrears")
            {
            }

            column(Loans_Loans__Outstanding_Balance__Control1000000016; "Loans Register"."Outstanding Balance")
            {
            }

            column(InterestDue_LoansRegister; "Loans Register"."Interest Due")
            {
            }

            // column(Loan_Category; "Loans Register"."Loans Category")
            // {
            // }

            column(Loans__Approved_Amount_; "Approved Amount")
            {
            }

            column(Loans_Loans__Interest_Due_; "Loans Register"."Interest Due")
            {
            }

            column(TotalBalance; "Loans Register"."Outstanding Balance" + "Loans Register"."Interest Due")
            {
            }

            column(V1MonthC_; "1MonthC")
            {
            }

            column(V2MonthC_; "2MonthC")
            {
            }

            column(V3MonthC_; "3MonthC")
            {
            }

            column(Over3MonthC; Over3MonthC)
            {
            }

            column(NoLoans; NoLoans)
            {
            }

            column(GrandTotal; GrandTotal)
            {
            }

            column(V0Month__Control1102760031; "0Month")
            {
            }

            column(V1Month__Control1102760032; "1Month")
            {
            }

            column(V2Month__Control1102760033; "2Month")
            {
            }

            column(V3Month__Control1102760034; "3Month")
            {
            }

            column(Over3Month_Control1102760035; Over3Month)
            {
            }

            column(V0MonthC_; "0MonthC")
            {
            }

            column(Loans__Client_Name_Caption; FieldCaption("Client Name"))
            {
            }


            // Read directly from Loans Register
            column(Loan_Category; Loan_Category)
            {
            }

            column(Sorting; Sorting)
            {
            }

            column(LoanProductType_LoansRegister; "Loans Register"."Loan Product Type")
            {
            }
            column(Issued_Date; "Issued Date") { }
            column(RepaymentStartDate_LoansRegister; "Loans Register"."Repayment Start Date")
            {
            }

            column(CurrentRepayment_LoansRegister; "Loans Register"."Current Repayment")
            {
            }

            column(ExpectedDateofCompletion_LoansRegister; "Loans Register"."Expected Date of Completion")
            {
            }

            column(lastbalance; "Loans Register"."Outstanding Balance")
            {
            }

            // READ ONLY - Days In Arrears
            column(Days_Arrears; Days_Arrears)
            {
            }

            column(AsAt; AsAt)
            {
            }

            column(LBal; LBal)
            {
            }

            column(CurrentBal; CurrentBal)
            {
            }


            trigger OnAfterGetRecord()
            begin

                if "Loans Register"."Outstanding Balance" > 0 then
                    NoLoans := NoLoans + 1;

                Loan_Category := "Loans Register"."Loans Category-SASRA";
                Days_Arrears := "Loans Register"."Days In Arrears";


            end;

            trigger OnPreDataItem()
            begin
                Company.Get();
                Company.CalcFields(Company.Picture);

                if AsAt = 0D then
                    AsAt := Today;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                // field("As At"; AsAt)
                // {
                //     ApplicationArea = Basic;
                // }

                // field("Loan Number"; loanNumber)
                // {
                //     ApplicationArea = Basic;
                //     TableRelation = "Loans Register"."Loan  No.";
                // }
            }
        }
    }

    labels
    {

    }

    var
        // job  

        CurrentBal: Decimal;
        loanNumber: Code[20];

        LoansTotal: Integer;
        Reached: Integer;
        PercentageDone: Decimal;
        DialogBox: Dialog;

        periodArrear: Decimal;
        Rescheduledate: Date;
        ExpectedBalance: Decimal;

        "1Month": Decimal;
        "2Month": Decimal;
        "3Month": Decimal;
        Over3Month: Decimal;

        ShowLoan: Boolean;
        AsAt: Date;
        LastDueDate: Date;
        DFormula: DateFormula;

        "0MonthC": Decimal;
        "1MonthC": Decimal;
        "2MonthC": Decimal;
        "3MonthC": Decimal;
        Over3MonthC: Decimal;

        NoLoans: Integer;
        PhoneNo: Text[30];
        "StaffNo.": Text[30];
        Deposits: Decimal;
        GrandTotal: Decimal;

        "0Month": Decimal;

        LoanProduct: Record "Loan Products Setup";

        FirstMonthDate: Date;
        EndMonthDate: Date;

        "0Day": Decimal;
        "1Day": Decimal;
        "2Day": Decimal;
        "3Day": Decimal;
        Over3Day: Decimal;

        LSchedule: Record "Loan Repayment Schedule";
        RepaymentPeriod: Date;

        Loans: Record "Loans Register";
        LastMonth: Date;
        ScheduledLoanBal: Decimal;

        DateFilter: Text;
        LBal: Decimal;
        Arrears: Decimal;
        NoofMonthsinArrears: Decimal;

        Company: Record "Company Information";

        MonthlyRepayment: Decimal;
        Last2Months: Date;

        Sorting: Integer;
        ApprovedAmount: Decimal;
        ExpectedDateofCompletion: Date;
        DateDiff: Decimal;
        DFilter: Text;

        Cat: Text[30];
        OutstandBal: Decimal;

        issueddate: Date;
        ldate: Date;
        Expertdate: Decimal;
        Days_Arrears: Decimal;
        Loan_Category: Option " ",Perfoming,Watch,Substandard,Doubtful,Loss;

        LoanApp: Record "Loans Register";
        daysinarr: Decimal;

}