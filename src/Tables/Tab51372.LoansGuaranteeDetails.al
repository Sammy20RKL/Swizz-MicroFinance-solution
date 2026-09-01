#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Table 51372 "Loans Guarantee Details"
{
    DrillDownPageID = "Loans Guarantee Details";
    LookupPageID = "Loans Guarantee Details";

    fields
    {
        field(1; "Loan No"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Loans Register"."Loan  No.";
        }
        field(2; "Member No"; Code[20])
        {
            NotBlank = true;
            TableRelation = Customer."No." where(Status = filter(Active | "Re-instated"));

            // A guarantor here is a KYC + commitment record, not a deposit-capacity
            // record: this system has no member deposits/shares to compute guarantee
            // capacity from, so the only "capacity" control that still makes sense is
            // a cap on how many loans one person can simultaneously guarantee (see
            // UpdateGuaranteeCount below), not an amount derived from savings.
            trigger OnValidate()
            begin
                if Cust.Get("Member No") then begin
                    if Cust.Status <> Cust.Status::Active then
                        Error('Only Active Members can guarantee Loans');
                end;

                MemberCust.Reset();
                MemberCust.SetRange(MemberCust."No.", "Member No");
                if MemberCust.FindFirst() then begin
                    if MemberCust.Status = MemberCust.Status::Defaulter then
                        Error('THE MEMBER  IS  A  DEFAULTER');
                end;

                LnGuarantor.Reset();
                LnGuarantor.SetRange(LnGuarantor."Loan  No.", "Loan No");
                if LnGuarantor.FindFirst() then begin
                    if LnGuarantor."Client Code" = "Member No" then begin
                        "Self Guarantee" := true;
                        Self := true;
                    end;
                end;

                if Cust.Get("Member No") then begin
                    Cust.CalcFields(Cust."Outstanding Balance");
                    Name := Cust.Name;
                    "Staff/Payroll No." := Cust."Personal No";
                    "Loan Balance" := Cust."Outstanding Balance";
                end;

                UpdateGuaranteeCount();
                if GenSetUp.Get() and (GenSetUp."Maximum No of Guarantees" > 0) and
                   ("No Of Loans Guaranteed" > GenSetUp."Maximum No of Guarantees")
                then
                    Error('%1 is already guaranteeing %2 loan(s), at or above the maximum of %3 allowed per guarantor.', Name, "No Of Loans Guaranteed", GenSetUp."Maximum No of Guarantees");
            end;
        }
        field(3; Name; Text[200])
        {
            Editable = false;
        }
        field(4; "Loan Balance"; Decimal)
        {
            Editable = false;
        }
        field(5; Shares; Decimal)
        {
            Editable = false;
        }
        // Not a FlowField: "Outstanding Balance" (field 16) is itself a FlowField, and
        // SQL Server has no physical column to filter on for a FlowField-of-a-FlowField
        // (the same class of bug fixed on Agents/Member Group - this one compiles but
        // throws "Invalid column name 'Outstanding Balance'" at runtime). Refreshed by
        // UpdateGuaranteeCount() instead.
        field(6; "No Of Loans Guaranteed"; Integer)
        {
            Caption = 'No. of Loans Guaranteed';
            Editable = false;
        }
        field(7; Substituted; Boolean)
        {
            trigger OnValidate()
            begin
                TestField("Substituted Guarantor");
            end;
        }
        field(8; Date; Date)
        {
        }
        field(9; "Shares Recovery"; Boolean)
        {
        }
        field(10; "New Upload"; Boolean)
        {
        }
        field(11; "Amont Guaranteed"; Decimal)
        {
            // Previously capped against three deposit/share-based "ability" figures
            // from Guarantor Management (overall, self-guarantee, and per-loan) - all
            // computed from the guarantor's own savings/shares, which don't exist in
            // this system. A guarantor's commitment is now just recorded, not capped
            // against a balance; the per-guarantor exposure control is the loan-count
            // cap on "Member No" instead (see UpdateGuaranteeCount).
            trigger OnValidate()
            begin
                "Committed Shares" := "Amont Guaranteed";
                "Original Amount" := "Amont Guaranteed";
                Date := Today;
            end;
        }
        field(12; "Staff/Payroll No."; Code[20])
        {
            trigger OnValidate()
            begin
                Cust.Reset();
                Cust.SetRange(Cust."Personal No", "Staff/Payroll No.");
                if Cust.Find('-') then begin
                    "Member No" := Cust."No.";
                    Validate("Member No");
                end else begin
                    // Only clear if this is a new unsaved record
                    if Rec."Entry No." = 0 then
                        "Member No" := '';
                end;
            end;
        }
        // field(12; "Staff/Payroll No."; Code[20])
        // {

        //     trigger OnValidate()
        //     begin
        //         Cust.Reset;
        //         Cust.SetRange(Cust."Personal No", "Staff/Payroll No.");
        //         if Cust.Find('-') then begin
        //             "Member No" := Cust."No.";
        //             Validate("Member No");
        //         end
        //         //else
        //         //   "Member No" := '';//ERROR('Record not found.')
        //     end;
        // }
        field(13; "Account No."; Code[20])
        {
        }
        field(14; "Self Guarantee"; Boolean)
        {
        }
        field(15; "ID No."; Code[70])
        {
        }
        field(16; "Outstanding Balance"; Decimal)
        {
            CalcFormula = sum("Cust. Ledger Entry"."Amount Posted" where("Transaction Type" = filter(Loan | "Loan Repayment"),
                                                                  Reversed = const(false),
                                                                  "Loan No" = field("Loan No")));
            FieldClass = FlowField;
        }
        field(41; "Transferable shares"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Total Loans Guaranteed"; Decimal)
        {
            CalcFormula = sum("Loans Guarantee Details"."Original Amount" where("Loan No" = field("Loan No"),
                                                                                 Substituted = const(false)));
            FieldClass = FlowField;
        }
        field(18; "Loans Outstanding"; Decimal)
        {
            CalcFormula = sum("Cust. Ledger Entry"."Amount Posted" where("Transaction Type" = filter(Loan | "Loan Repayment"),
                                                                  "Loan No" = field("Loan No")));
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                /*"Total Loans Guaranteed":="Outstanding Balance";
                MODIFY;
                */

            end;
        }
        field(19; "Guarantor Outstanding"; Decimal)
        {
            CalcFormula = sum("Cust. Ledger Entry"."Amount Posted" where("Customer No." = field("Member No"),
                                                                  "Transaction Type" = filter(Loan | "Loan Repayment")));
            FieldClass = FlowField;
        }
        field(20; "Employer Code"; Code[20])
        {
            TableRelation = Customer."No.";
        }
        field(21; "Employer Name"; Text[100])
        {
        }
        field(22; "Substituted Guarantor"; Code[80])
        {
            TableRelation = Customer."No.";

            // The "guaranteed more than the maximum" check that used to live here
            // never actually ran - it compared against LoansG, a variable nothing in
            // this table ever assigned, so it was always 0. That cap is now enforced
            // for real on "Member No" instead (see UpdateGuaranteeCount).
            trigger OnValidate()
            begin
                Loans.Reset;
                Loans.SetRange(Loans."Client Code", "Member No");
                if Loans.Find('-') then begin
                    if LoanGuarantors."Self Guarantee" = true then
                        Error('This Member has Self Guaranteed and Can not Guarantee another Loan');
                end;
            end;
        }
        field(23; "Loanees  No"; Code[30])
        {
            CalcFormula = lookup("Loans Register"."Client Code" where("Loan  No." = field("Loan No")));
            FieldClass = FlowField;
        }
        field(24; "Loanees  Name"; Text[80])
        {
            CalcFormula = lookup("Loans Register"."Client Name" where("Loan  No." = field("Loan No")));
            FieldClass = FlowField;
        }
        field(25; "Loan Product"; Code[20])
        {
            CalcFormula = lookup("Loans Register"."Loan Product Type" where("Loan  No." = field("Loan No")));
            FieldClass = FlowField;
        }
        field(26; "Entry No."; Integer)
        {
        }
        field(27; "Loan Application Date"; Date)
        {
            CalcFormula = lookup("Loans Register"."Application Date" where("Loan  No." = field("Loan No")));
            FieldClass = FlowField;
        }
        field(28; "Free Shares"; Decimal)
        {
        }
        field(29; "Line No"; Integer)
        {
        }
        field(30; "Member Cell"; Code[10])
        {
        }
        field(31; "Share capital"; Decimal)
        {
        }
        field(32; "TotalLoan Guaranteed"; Decimal)
        {
        }
        field(33; Totals; Decimal)
        {
        }
        field(34; "Shares *3"; Decimal)
        {
        }
        field(35; "Deposits variance"; Decimal)
        {
        }
        field(36; "Defaulter Loan Installments"; Code[10])
        {
        }
        field(37; "Defaulter Loan Repayment"; Decimal)
        {
        }
        field(38; "Exempt Defaulter Loan"; Boolean)
        {
        }
        field(39; "Additional Defaulter Amount"; Decimal)
        {
        }
        field(40; "Total Guaranteed"; Decimal)
        {
            CalcFormula = sum("Loans Guarantee Details"."Loan Balance" where("Loan No" = field("Loan No"),
                                                                              Substituted = filter(false)));
            Description = '//>Sum total guaranteed amount for each loan';
            FieldClass = FlowField;
        }
        field(69161; "Total Committed Shares"; Decimal)
        {
            CalcFormula = sum("Loans Guarantee Details"."Amont Guaranteed" where("Member No" = field("Member No")));
            FieldClass = FlowField;
        }
        field(69162; "Oustanding Interest"; Decimal)
        {
            CalcFormula = sum("Cust. Ledger Entry"."Amount Posted" where("Customer No." = field("Member No"),
                                                                  "Transaction Type" = filter("Interest Paid"),
                                                                  "Loan No" = field("Loan No")));
            FieldClass = FlowField;
        }
        field(69163; "Guar Sub Doc No."; Code[20])
        {
        }
        field(69164; "Committed Shares"; Decimal)
        {
        }
        field(69165; "Substituted Guarantor Name"; Text[30])
        {
        }
        field(69166; "Member Liability"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(69167; "Original Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //  CALCFIELDS("Outstanding Balance","Total Loans Guaranteed");
                //  IF "Total Loans Guaranteed">0 THEN
                //  "Amont Guaranteed":=ROUND((("Original Amount"/"Total Loans Guaranteed")*("Outstanding Balance")),1,'=');
                //  MODIFY();
            end;
        }
        field(69168; LoanCount; Integer)
        {
            CalcFormula = count("Loans Guarantee Details" where("Loanees  No" = field("Loanees  No"),
                                                                 "Loan No" = field("Loan No")));
            FieldClass = FlowField;
        }
        field(69169; "Application Statu"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(69170; "free Share"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //"free Share" := Amont;
            end;
        }
        field(69171; Posted; Boolean)
        {
            DataClassification = ToBeClassified;
        }


        field(504; "Loan Outstanding Balance"; Decimal)
        {
            Caption = 'Loan Outstanding Balance';
            DataClassification = ToBeClassified;
            DecimalPlaces = 2 : 20;
        }
    }

    keys
    {
        key(Key1; "Loan No", "Staff/Payroll No.", "Member No", "Entry No.")
        {
            //Clustered = true;
        }
        key(Key2; "Loan No", "Member No")
        {
            Clustered = true;
            SumIndexFields = Shares;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Application Statu" := true;
    end;

    var
        AvailableSH: Decimal;
        MemberNo: Text;
        MemberName: Text;
        EmployerCode: Text;
        TotalOutstandingBal: Decimal;
        OutStandingBal: Decimal;
        FNo: Integer;
        // AmountGuar: Decimal;
        OutstandingBAlSt: Decimal;
        Company: Record "Company Information";
        CommittedShares: Decimal;
        ObjLoanGuar: Record "Loans Guarantee Details";
        ApprovedAmt: Decimal;
        LoanProductName: Text[50];
        Loantypes: Record "Loan Products Setup";
        AmountGuarT: Decimal;
        MDeposit: Decimal;
        MAmounttoG: Decimal;
        MLoanReg: Record "Loans Register";
        Cust: Record Customer;
        LoanGuarantors: Record "Loans Guarantee Details";
        Loans: Record "Loans Register";
        LoansR: Record "Loans Register";
        GenSetUp: Record "Sacco General Set-Up";
        SelfGuaranteedA: Decimal;
        StatusPermissions: Record "Status Change Permision";
        Employer: Record "Sacco Employers";
        loanG: Record "Loans Guarantee Details";
        CustomerRecord: Record Customer;
        MemberSaccoAge: Date;
        ComittedShares: Decimal;
        LoanApp: Record "Loans Register";
        DefaultInfo: Text;
        ok: Boolean;
        SharesVariance: Decimal;
        MemberCust: Record Customer;
        LnGuarantor: Record "Loans Register";
        LoanApps: Record "Loans Register";
        Text0001: label 'This Member has an Outstanding Defaulter Loan which has never been serviced';
        freeshares: Decimal;
        loanrec: Record "Loans Guarantee Details";
        ObjWithApp: Record "Membership Exit";
        Self: Boolean;
        SelfGuaranteeAmount: Decimal;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        AmountGuar: Decimal;
        vardiff: Decimal;
        MemberLiability: Decimal;

    local procedure UPDATEG()
    begin
    end;

    // Counts this member's currently-active guarantee commitments (not substituted,
    // and against a loan still carrying a balance). Replaces the deposit-based
    // capacity math as the guardrail against one person over-committing themselves.
    local procedure UpdateGuaranteeCount()
    var
        GuaranteeLine: Record "Loans Guarantee Details";
        ActiveCount: Integer;
    begin
        GuaranteeLine.SetRange("Member No", "Member No");
        GuaranteeLine.SetRange(Substituted, false);
        if GuaranteeLine.FindSet() then
            repeat
                GuaranteeLine.CalcFields("Outstanding Balance");
                if GuaranteeLine."Outstanding Balance" <> 0 then
                    ActiveCount += 1;
            until GuaranteeLine.Next() = 0;

        "No Of Loans Guaranteed" := ActiveCount;
    end;

}

