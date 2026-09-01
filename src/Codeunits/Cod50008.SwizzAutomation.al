#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 50008 SwizzAutomation
{

    trigger OnRun()
    begin
    end;

    var
        objTransactions: Record 51441;
        GenJournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
        GenSetup: Record 51398;
        Stos: Record 51449;
        DocNo: Code[10];
        PDate: Date;
        SFactory: Codeunit "Swizzsoft FactoryMobile";
        Cust: Record 51364;
        Loans: Record 51371;


    procedure FnRunStandingOrders()
    begin
        Stos.Reset;
        if Stos.Find('-') then begin
            Report.Run(51516461, false, false, Stos);
        end;
    end;



    procedure FnChequeClearing()
    var
        Account: Record Vendor;
    begin
        GenJournalLine.Reset;
        GenJournalLine.SetRange("Journal Template Name", 'PURCHASES');
        GenJournalLine.SetRange("Journal Batch Name", 'CHQCL');
        GenJournalLine.DeleteAll;

        objTransactions.Reset;
        objTransactions.SetRange(objTransactions."Transaction Type", 'CHQDEPCURR');
        objTransactions.SetRange(objTransactions.Posted, true);
        objTransactions.SetRange(objTransactions."Cheque Processed", false);
        objTransactions.SetFilter(objTransactions."Expected Maturity Date", '..' + Format(Today));
        if objTransactions.Find('-') then begin
            repeat
                if Account.Get(objTransactions."Account No") then begin
                    if Account."Cheque Discounted" <> 0 then begin
                        LineNo := LineNo + 10000;
                        GenSetup.Get();
                        GenJournalLine.Init;
                        GenJournalLine."Journal Template Name" := 'PURCHASES';
                        GenJournalLine."Journal Batch Name" := 'CHQCL';
                        GenJournalLine."Document No." := objTransactions.No;
                        GenJournalLine."External Document No." := objTransactions."Cheque No";
                        GenJournalLine."Line No." := LineNo;
                        GenJournalLine."Account Type" := GenJournalLine."account type"::Vendor;
                        GenJournalLine."Account No." := objTransactions."Account No";
                        GenJournalLine.Validate(GenJournalLine."Account No.");
                        GenJournalLine."Posting Date" := Today;
                        GenJournalLine.Description := 'Cheque Discounting Charge';
                        GenJournalLine.Validate(GenJournalLine."Currency Code");
                        GenJournalLine.Amount := Account."Comission On Cheque Discount";
                        GenJournalLine.Validate(GenJournalLine.Amount);
                        GenJournalLine."Bal. Account Type" := GenJournalLine."bal. account type"::"G/L Account";
                        GenJournalLine."Bal. Account No." := GenSetup."Cheque Discounting Fee Account";
                        GenJournalLine.Validate(GenJournalLine."Bal. Account No.");
                        GenJournalLine."Shortcut Dimension 1 Code" := 'FOSA';
                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 1 Code");
                        GenJournalLine."Shortcut Dimension 2 Code" := objTransactions."Transacting Branch";
                        GenJournalLine.Validate(GenJournalLine."Shortcut Dimension 2 Code");
                        if GenJournalLine.Amount <> 0 then
                            GenJournalLine.Insert;

                        Account."Cheque Discounted" := 0;
                        Account."Comission On Cheque Discount" := 0;
                        Account.Modify;
                    end;
                end;
                objTransactions."Cheque Processed" := true;
                objTransactions."Date Cleared" := Today;
                objTransactions.Modify;
            until objTransactions.Next = 0;
        end;

        GenJournalLine.Reset;
        GenJournalLine.SetRange("Journal Template Name", 'PURCHASES');
        GenJournalLine.SetRange("Journal Batch Name", 'CHQCL');
        if GenJournalLine.Find('-') then begin
            Codeunit.Run(Codeunit::"Gen. Jnl.-Post Sacco", GenJournalLine);
        end;
    end;


    procedure FnPostEntries()
    begin
    end;

    procedure FnPostEntry()
    begin
        GenJournalLine.Reset;
        GenJournalLine.SetRange("Journal Template Name", 'PURCHASES');
        GenJournalLine.SetRange("Journal Batch Name", 'INTCALC-F');
        if GenJournalLine.Find('-') then begin
            Codeunit.Run(Codeunit::"Gen. Jnl.-Post Batch", GenJournalLine);
        end;
    end;


    // procedure FnAdhoc()
    // begin
    //     Cust.Reset;
    //     Cust.SetRange(Cust."Global Dimension 1 Code", 'BOSA');
    //     if Cust.Find('-') then begin
    //         repeat
    //             Report.Run(51516419, false, false, Cust); //DORMANCY

    //             Loans.Reset;
    //             Loans.SetRange(Loans."BOSA No", Cust."No.");
    //             Loans.SetRange(Loans.Posted, true);
    //             if Loans.Find('-') then begin
    //                 repeat
    //                     Report.Run(51516234, false, false, Loans); //LOAN AGEING
    //                     Report.Run(51516456, false, false, Loans); //RELEASE COLLATERAL
    //                 until Loans.Next = 0;
    //             end;

    //             objVendor.Reset;
    //             objVendor.SetRange(objVendor."BOSA Account No", Cust.""Account No");
    //             if objVendor.Find('-') then begin
    //                 Report.Run(51516460, false, false, objVendor);
    //             end;
    //         until Cust.Next = 0;
    //     end;
    // end;

}

