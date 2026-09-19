pageextension 50619 "UserSetUpExt" extends "User Setup"
{
    layout
    {
        addafter("Allow Posting To")
        {

            field("Financial User"; Rec."Financial User")
            {
                ApplicationArea = Basic;

            }
            field("Payroll User"; Rec."Payroll User")
            {
                ApplicationArea = Basic;
            }
            field("View Cashier Report"; Rec."View Cashier Report")
            {
                ApplicationArea = Basic;
            }
            field("Reversal Right"; Rec."Reversal Right")
            {
                ApplicationArea = Basic;
            }
            field("User Can Process Dividends"; Rec."User Can Process Dividends")
            {
                ApplicationArea = Basic;
            }
            field("Exempt OTP On LogIn"; Rec."Exempt OTP On LogIn")
            {
                ApplicationArea = Basic;
            }
            field("Post Leave Days Allocations"; Rec."Post Leave Days Allocations")
            {
                ApplicationArea = Basic;
            }
            field(Branch; Rec.Branch)
            {
                ApplicationArea = Basic;
            }
            field(Activity; Rec.Activity)
            {
                ApplicationArea = Basic;
            }
            field("Employee No."; Rec."Employee No.") { ApplicationArea = Basic; }
            field("Exempt Posting Date Update"; Rec."Exempt Posting Date Update")
            {
                ApplicationArea = Basic;
            }
            field("Exempt Logs"; Rec."Exempt Logs")
            {
                ApplicationArea = Basic;
            }
            field("Can POST Loans"; Rec."Can POST Loans")
            {
                ApplicationArea = Basic;
                Visible = true;

            }
            // field("Role Centre"; Rec."Role Centre")
            // {
            // }
            field("Issue Trunch"; Rec."Issue Trunch") { }

        }
        modify("Allow Deferral Posting From")
        {
            ApplicationArea = Basic;
            Visible = false;
        }
        modify("Allow Deferral Posting To")
        {
            ApplicationArea = Basic;
            Visible = false;
        }
        modify("Salespers./Purch. Code")
        {
            ApplicationArea = Basic;
            Visible = false;
        }
        modify("Sales Resp. Ctr. Filter")
        {
            ApplicationArea = Basic;
            Visible = false;
        }
        modify("Purchase Resp. Ctr. Filter")
        {
            Visible = false;
        }
        modify("Service Resp. Ctr. Filter")
        {
            Visible = false;
        }
        modify("Time Sheet Admin.")
        {
            Visible = false;
        }

    }

    actions
    {

    }
    trigger OnOpenPage()
    begin
        AuditLog.FnReadingsMadeAudit(UserId, 'Accessed and read the user setup listing page');
    end;

    trigger OnClosePage()
    begin
        AuditLog.FnReadingsMadeAudit(UserId, 'Closed user setup listing page');
    end;

    trigger OnModifyRecord(): Boolean
    begin
        begin
            AuditLog.FnModificationMadeAudit(UserId, 'Changed user setup for ' + UserId + CopyStr('from settings=' + Format(xRec), 1, 2048));
            AuditLog.FnModificationMadeAudit(UserId, 'Changed user setup for ' + "UserID" + CopyStr('to settings=' + Format(Rec), 1, 2048));
        end;
    end;

    var
        AuditLog: Codeunit "Audit Log Codeunit";

    var
        myInt: Integer;
}
