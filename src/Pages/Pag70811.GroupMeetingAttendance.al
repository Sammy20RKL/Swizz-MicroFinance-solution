page 70811 "Group Meeting Attendance"
{
    Caption = 'Attendance';
    PageType = ListPart;
    SourceTable = "Group Meeting Attendance";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = All;
                }
                field("Member Name"; Rec."Member Name")
                {
                    ApplicationArea = All;
                }
                field(Attended; Rec.Attended)
                {
                    ApplicationArea = All;
                }
                field("Apology Reason"; Rec."Apology Reason")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
