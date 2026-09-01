page 70783 "Member Group Card"
{
    Caption = 'Member Group Card';
    PageType = Card;
    SourceTable = "Member Group";
    UsageCategory = Administration;
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
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Group Type"; Rec."Group Type")
                {
                    ApplicationArea = All;
                }
                field("Agent No."; Rec."Agent No.")
                {
                    ApplicationArea = All;
                }
                field("Agent Name"; Rec."Agent Name")
                {
                    ApplicationArea = All;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ApplicationArea = All;
                    Caption = 'Branch';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
            }
            group(Meetings)
            {
                Caption = 'Meetings';

                field("Formation Date"; Rec."Formation Date")
                {
                    ApplicationArea = All;
                }
                field("Meeting Frequency"; Rec."Meeting Frequency")
                {
                    ApplicationArea = All;
                }
                field("Meeting Day"; Rec."Meeting Day")
                {
                    ApplicationArea = All;
                }
                field("Meeting Location"; Rec."Meeting Location")
                {
                    ApplicationArea = All;
                }
            }
            group("Guarantee Fund")
            {
                Caption = 'Guarantee Fund';

                field("Member Count"; Rec."Member Count")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                }
                field("Total Contributions"; Rec."Total Contributions")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                }
                field("Committed Amount"; Rec."Committed Amount")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                }
                field("Available Guarantee Balance"; AvailableGuaranteeBalance)
                {
                    ApplicationArea = All;
                    Caption = 'Available Guarantee Balance';
                    Editable = false;
                    StyleExpr = AvailableStyleExpr;
                }
                field("Outstanding Group Loans"; Rec."Outstanding Group Loans")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                }
            }
            part(Members; "Group Member Lines")
            {
                ApplicationArea = All;
                Caption = 'Members';
                SubPageLink = "Group No." = field("No.");
                UpdatePropagation = Both;
            }
            // part(Contributions; "Group Contributions")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Contributions';
            //     SubPageLink = "Group No." = field("No.");
            //     UpdatePropagation = Both;
            // }
            part(GuaranteedLoans; "Group Guaranteed Loans")
            {
                ApplicationArea = All;
                Caption = 'Guaranteed Loans';
                SubPageLink = "Guarantor Group No." = field("No.");
            }
            part(GroupMeetings; "Group Meetings Subpage")
            {
                ApplicationArea = All;
                Caption = 'Meetings';
                SubPageLink = "Group No." = field("No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Group Contribution")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Caption = 'Contributions';
                ToolTip = 'View and post contributions for this group.';

                trigger OnAction()
                var
                    Contribution: Record "Group Contribution";
                    GroupContributions: Page "Group Contributions";
                begin
                    Contribution.SetRange("Group No.", Rec."No.");
                    GroupContributions.SetTableView(Contribution);
                    GroupContributions.RunModal();
                    CurrPage.Update(false);
                end;
            }
            action("Record Meeting")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Caption = 'Record Meeting';
                ToolTip = 'Log a new meeting for this group and mark attendance.';

                trigger OnAction()
                var
                    Meeting: Record "Group Meeting";
                    MeetingCard: Page "Group Meeting Card";
                begin
                    Meeting.Init();
                    Meeting."Group No." := Rec."No.";
                    Meeting.Insert(true);
                    MeetingCard.SetRecord(Meeting);
                    MeetingCard.Run();
                    CurrPage.Update(false);
                end;
            }
            group(Reports)
            {
                Caption = 'Reports';

                action("Performance Summary")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Caption = 'Performance Summary';

                    trigger OnAction()
                    var
                        Group: Record "Member Group";
                    begin
                        Group.SetRange("No.", Rec."No.");
                        Report.RunModal(Report::"Group Performance Summary", true, false, Group);
                    end;
                }
                action("Guarantee Exposure")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Caption = 'Guarantee Exposure';

                    trigger OnAction()
                    var
                        Loan: Record "Loans Register";
                    begin
                        Loan.SetRange("Guarantor Group No.", Rec."No.");
                        Report.RunModal(Report::"Group Guarantee Exposure", true, false, Loan);
                    end;
                }
                action("Contribution Register")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Caption = 'Contribution Register';

                    trigger OnAction()
                    var
                        Contribution: Record "Group Contribution";
                    begin
                        Contribution.SetRange("Group No.", Rec."No.");
                        Report.RunModal(Report::"Group Contribution Register", true, false, Contribution);
                    end;
                }
                action("Membership Roster")
                {
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Caption = 'Membership Roster';

                    trigger OnAction()
                    var
                        GroupMemberLine: Record "Group Member Line";
                    begin
                        GroupMemberLine.SetRange("Group No.", Rec."No.");
                        Report.RunModal(Report::"Group Membership Roster", true, false, GroupMemberLine);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Total Contributions");
        Rec.UpdateGuaranteeFundFigures();
        AvailableGuaranteeBalance := Rec."Total Contributions" - Rec."Committed Amount";

        if AvailableGuaranteeBalance < 0 then
            AvailableStyleExpr := 'Unfavorable'
        else
            AvailableStyleExpr := 'Favorable';
    end;

    var
        AvailableGuaranteeBalance: Decimal;
        AvailableStyleExpr: Text;
}
