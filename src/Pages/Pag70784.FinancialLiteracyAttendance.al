page 70784 "Financial Literacy Attendance"
{
    Caption = 'Attendance';
    PageType = ListPart;
    SourceTable = "Financial Literacy Attendance";
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
                field("Certification Status"; Rec."Certification Status")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
