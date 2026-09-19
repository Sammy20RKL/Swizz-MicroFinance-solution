page 70813 "Group Meeting List"
{
    Caption = 'Group Meetings';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;
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
                    Editable = false;
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

    // Opened filtered to one group (via the "Meetings" action on Member Group Card,
    // RunPageLink = "Group No." = field("No.")) - that filters the LIST view, but a new
    // record does not inherit it automatically the way an embedded part's SubPageLink
    // would. Reading the filter back here and copying it onto the new row is what
    // actually makes "New" insert the group without asking the user to pick it again.
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        GroupNoFilter: Text;
    begin
        GroupNoFilter := Rec.GetFilter("Group No.");
        if GroupNoFilter <> '' then
            Rec."Group No." := CopyStr(GroupNoFilter, 1, MaxStrLen(Rec."Group No."));
    end;
}
