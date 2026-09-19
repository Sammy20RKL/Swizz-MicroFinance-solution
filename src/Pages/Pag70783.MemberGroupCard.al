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

            part(Members; "Group Member Lines")
            {
                ApplicationArea = All;
                Caption = 'Members';
                SubPageLink = "Group No." = field("No.");
                UpdatePropagation = Both;
            }

            part(Contributions; "Group Contributions")
            {
                ApplicationArea = All;
                Caption = 'Contribution History';
                SubPageLink = "Group No." = field("No.");
                UpdatePropagation = Both;
            }
        }
        area(factboxes)
        {
            part(GuaranteeFundFactBox; "Group Guarantee Fund FactBox")
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
            action(Meetings)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Caption = 'Meetings';
                ToolTip = 'View this group''s meeting history, or add a new meeting - the list opens already filtered to this group, so a new row here is automatically logged against it.';
                Image = Calendar;
                RunObject = page "Group Meeting List";
                RunPageLink = "Group No." = field("No.");
            }
            action(Guaranteeloan)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Caption = 'Guaranteed Loans';
                Image = Loaner;
                RunObject = page "Group Guaranteed Loans";
                RunPageLink = "Guarantor Group No." = field("No.");

            }
            group(Reports)
            {
                Caption = 'Reports';

                action("Performance Summary")
                {
                    ApplicationArea = All;
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

}
