page 70814 "Group Meetings Subpage"
{
    Caption = 'Meetings';
    PageType = ListPart;
    SourceTable = "Group Meeting";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
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
                    StyleExpr = AttendanceStyleExpr;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("Expected Member Count", "Attendee Count");

        AttendanceStyleExpr := 'Favorable';
        if (Rec."Expected Member Count" > 0) and (Rec."Attendee Count" < Rec."Expected Member Count") then
            AttendanceStyleExpr := 'Unfavorable';
    end;

    var
        AttendanceStyleExpr: Text;
}
