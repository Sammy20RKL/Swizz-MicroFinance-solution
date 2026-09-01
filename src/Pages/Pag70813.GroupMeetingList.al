page 70813 "Group Meeting List"
{
    Caption = 'Group Meetings';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Group Meeting";
    CardPageId = "Group Meeting Card";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Group No."; Rec."Group No.")
                {
                    ApplicationArea = All;
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
                field("Expected Member Count"; Rec."Expected Member Count")
                {
                    ApplicationArea = All;
                }
                field("Attendee Count"; Rec."Attendee Count")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
