page 70776 "Agent Cards"
{
    Caption = 'Agent Card';
    PageType = Card;
    SourceTable = Agents;
    UsageCategory = Administration;// 70783
    ApplicationArea = All;

    layout
    {
        area(content)
        {


            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Full Name"; Rec."Full Name")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Style = StrongAccent;
                }
                field("National ID"; Rec."National ID")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                }
                field("Email"; Rec."Email")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Region Code"; Rec."Region Code")
                {
                    ApplicationArea = All;
                    Caption = 'Region';
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ApplicationArea = All;
                    Caption = 'Branch';
                }
                field("Date Joined"; Rec."Date Joined")
                {
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    StyleExpr = StatusStyleExpr;
                }

            }

            part(TargetsSubpage; "Agent Target Subpage")
            {
                ApplicationArea = All;
                Caption = 'Targets (Monthly)';
                SubPageLink = "Agent No." = field("No.");
                UpdatePropagation = Both;
            }
        }

        area(factboxes)
        {
            part(Control1; "Agent Picture")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("No.");
                Enabled = true;
            }
            part("Agent Statistics FactBox"; "Agent Statistics FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Send Approval Request")
            {
                ApplicationArea = All;
                Caption = 'Send Approval Request';
                Image = SendApprovalRequest;
                Enabled = (not OpenApprovalEntriesExist) and EnabledApprovalWorkflowsExist;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to send this Agent for Approval?', false) then begin
                        SrestepApprovalsCodeUnit.SendAgentRequestForApproval(Rec."No.", Rec);
                        Message('Approval Request Sent!');
                        CurrPage.Update(false);
                    end;
                end;
            }
            action("Cancel Approval Request")
            {
                ApplicationArea = All;
                Caption = 'Cancel Approval Request';
                Image = Cancel;
                Enabled = CanCancelApprovalForRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('Cancel Approval for this Agent?', false) then begin
                        SrestepApprovalsCodeUnit.CancelAgentRequestForApproval(Rec."No.", Rec);
                        Message('Approval Request Canceled!');
                        CurrPage.Update(false);
                    end;
                end;
            }
            action("Exit Agent & Reassign Portfolio")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Caption = 'Exit Agent & Reassign Portfolio';
                Enabled = Rec.Status <> Rec.Status::Exited;
                ToolTip = 'Move the selected parts of this agent''s portfolio (members, groups, loans) to another agent. Marks this agent Exited only if everything is reassigned.';

                trigger OnAction()
                var
                    ReassignmentDialog: Page "Agent Reassignment Dialog";
                    NewAgentNo: Code[20];
                    ExitReason: Text[100];
                    MoveMembers: Boolean;
                    MoveGroups: Boolean;
                    MoveLoans: Boolean;
                begin
                    ReassignmentDialog.SetSourceAgentNo(Rec."No.");
                    if ReassignmentDialog.RunModal() <> Action::OK then
                        exit;

                    NewAgentNo := ReassignmentDialog.GetNewAgentNo();
                    ExitReason := ReassignmentDialog.GetReason();
                    MoveMembers := ReassignmentDialog.GetReassignMembers();
                    MoveGroups := ReassignmentDialog.GetReassignGroups();
                    MoveLoans := ReassignmentDialog.GetReassignLoans();

                    if NewAgentNo = '' then
                        Error('You must select an agent to reassign the portfolio to.');

                    if not Confirm('This will move the selected parts of %1''s portfolio to %2. Continue?', false, Rec."No.", NewAgentNo) then
                        exit;

                    Rec.ReassignPortfolioTo(NewAgentNo, ExitReason, MoveMembers, MoveGroups, MoveLoans);

                    if MoveMembers and MoveGroups and MoveLoans then begin
                        Rec.Validate(Status, Rec.Status::Exited);
                        Rec."Status Change Reason" := ExitReason;
                        Rec.Modify(true);
                        Message('Portfolio reassigned to %1. %2 is now marked Exited.', NewAgentNo, Rec."No.");
                    end else
                        Message('Selected portfolio items reassigned to %1.', NewAgentNo);

                    CurrPage.Update(false);
                end;
            }
            group(Reports)
            {
                Caption = 'Reports';

                action("Performance Summary")
                {
                    ApplicationArea = All;
                    Caption = 'Performance Summary';
                    Image = Percentage;

                    trigger OnAction()
                    var
                        Agent: Record Agents;
                    begin
                        Agent.SetRange("No.", Rec."No.");
                        Report.RunModal(Report::"Agent Performance Summary", true, false, Agent);
                    end;
                }
                action("Target Achievement")
                {
                    ApplicationArea = All;
                    Image = Track;
                    Caption = 'Target Achievement';

                    trigger OnAction()
                    var
                        AgentTarget: Record "Agent Target";
                    begin
                        AgentTarget.SetRange("Agent No.", Rec."No.");
                        Report.RunModal(Report::"Agent Target Achievement", true, false, AgentTarget);
                    end;
                }
                action("Portfolio at Risk")
                {
                    ApplicationArea = All;
                    Caption = 'Portfolio at Risk';
                    Image = ItemAvailability;

                    trigger OnAction()
                    var
                        Loan: Record "Loans Register";
                    begin
                        Loan.SetRange("Agent No.", Rec."No.");
                        Report.RunModal(Report::"Agent Portfolio at Risk", true, false, Loan);
                    end;
                }
                action("Disbursement Register")
                {
                    ApplicationArea = All;
                    Image = DistributionGroup;
                    Caption = 'Disbursement Register';

                    trigger OnAction()
                    var
                        Loan: Record "Loans Register";
                    begin
                        Loan.SetRange("Agent No.", Rec."No.");
                        Report.RunModal(Report::"Agent Disbursement Register", true, false, Loan);
                    end;
                }
                action("Collections Register")
                {
                    ApplicationArea = All;
                    Caption = 'Collections Register';
                    Image = PostedReceipt;

                    trigger OnAction()
                    var
                        CustLedgerEntry: Record "Cust. Ledger Entry";
                    begin
                        CustLedgerEntry.SetRange("Agent No.", Rec."No.");
                        Report.RunModal(Report::"Agent Collections Register", true, false, CustLedgerEntry);
                    end;
                }
                action("Member Onboarding")
                {
                    ApplicationArea = All;
                    Caption = 'Member Onboarding';
                    Image = Customer;

                    trigger OnAction()
                    var
                        Member: Record Customer;
                    begin
                        Member.SetRange("Agent No.", Rec."No.");
                        Report.RunModal(Report::"Agent Member Onboarding", true, false, Member);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        case Rec.Status of
            Rec.Status::Active:
                StatusStyleExpr := 'Favorable';
            Rec.Status::Suspended:
                StatusStyleExpr := 'Unfavorable';
            else
                StatusStyleExpr := 'Subordinate';
        end;

        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        EnabledApprovalWorkflowsExist := true;
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);

        Rec.UpdatePortfolioFigures();
        if Rec."Default Rate" > 10 then begin
            RiskNotification.Message(StrSubstNo('This agent''s default rate is %1 percent, above the 10 percent risk threshold.', Rec."Default Rate"));
            RiskNotification.Scope(NotificationScope::LocalScope);
            RiskNotification.Send();
        end;
    end;

    var
        StatusStyleExpr: Text;
        SrestepApprovalsCodeUnit: Codeunit "SurestepApprovalsCodeUnit";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        RiskNotification: Notification;
        OpenApprovalEntriesExist: Boolean;
        EnabledApprovalWorkflowsExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
}
