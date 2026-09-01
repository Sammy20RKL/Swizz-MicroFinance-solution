table 59075 "Group Meeting Attendance"
{
    Caption = 'Group Meeting Attendance';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Meeting Entry No."; Integer)
        {
            Caption = 'Meeting Entry No.';
            TableRelation = "Group Meeting"."Entry No.";
        }
        field(2; "Member No."; Code[20])
        {
            Caption = 'Member No.';
            TableRelation = Customer."No.";

            trigger OnValidate()
            var
                Member: Record Customer;
            begin
                if Member.Get("Member No.") then
                    "Member Name" := Member.Name;
            end;
        }
        field(3; "Member Name"; Text[100])
        {
            Caption = 'Member Name';
        }
        field(4; Attended; Boolean)
        {
            Caption = 'Attended';
        }
        field(5; "Apology Reason"; Text[100])
        {
            Caption = 'Apology Reason';
        }
    }

    keys
    {
        key(PK; "Meeting Entry No.", "Member No.")
        {
            Clustered = true;
        }
        key(Key2; "Member No.") { }
    }

    // Loads every active member of the meeting's group as an attendance line,
    // defaulted to not-yet-marked, so the secretary only has to tick who showed
    // up instead of typing every member number by hand each meeting.
    procedure PopulateFromGroup(MeetingEntryNo: Integer; GroupNo: Code[20])
    var
        GroupMemberLine: Record "Group Member Line";
        Attendance: Record "Group Meeting Attendance";
    begin
        GroupMemberLine.SetRange("Group No.", GroupNo);
        GroupMemberLine.SetRange(Status, GroupMemberLine.Status::Active);
        if GroupMemberLine.FindSet() then
            repeat
                if not Attendance.Get(MeetingEntryNo, GroupMemberLine."Member No.") then begin
                    Attendance.Init();
                    Attendance."Meeting Entry No." := MeetingEntryNo;
                    Attendance."Member No." := GroupMemberLine."Member No.";
                    Attendance."Member Name" := GroupMemberLine."Member Name";
                    Attendance.Insert(true);
                end;
            until GroupMemberLine.Next() = 0;
    end;
}
