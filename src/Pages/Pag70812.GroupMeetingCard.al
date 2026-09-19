page 70812 "Group Meeting Card"
{
    Caption = 'Group Meeting';
    PageType = Card;
    SourceTable = "Group Meeting";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Group No."; Rec."Group No.")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ShowMandatory = true;
                }
                field("Meeting Date"; Rec."Meeting Date")
                {
                    ApplicationArea = All;
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = All;
                }
                field(Chairperson; Rec.Chairperson)
                {
                    ApplicationArea = All;
                }
                field("Recorded By"; Rec."Recorded By")
                {
                    ApplicationArea = All;
                }
                field(Agenda; Rec.Agenda)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field(MinutesText; MinutesText)
                {
                    ApplicationArea = All;
                    Caption = 'Minutes';
                    MultiLine = true;

                    trigger OnValidate()
                    begin
                        Rec.SetMinutes(MinutesText);
                        Rec.Modify(true);
                    end;
                }
                field("Expected Member Count"; Rec."Expected Member Count")
                {
                    ApplicationArea = All;
                }
                field("Attendee Count"; Rec."Attendee Count")
                {
                    ApplicationArea = All;
                }
            }
            part(Attendance; "Group Meeting Attendance")
            {
                ApplicationArea = All;
                Caption = 'Attendance';
                SubPageLink = "Meeting Entry No." = field("Entry No.");
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Load Members")
            {
                ApplicationArea = All;
                Caption = 'Load Members';
                Image = GetLines;
                ToolTip = 'Add every active member of this group to the attendance list, ready to be ticked off.';

                trigger OnAction()
                var
                    Attendance: Record "Group Meeting Attendance";
                begin
                    Rec.TestField("Group No.");
                    Attendance.PopulateFromGroup(Rec."Entry No.", Rec."Group No.");
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        MinutesText := Rec.GetMinutes();
    end;

    var
        MinutesText: Text;
}
