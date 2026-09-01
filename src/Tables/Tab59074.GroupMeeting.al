table 59074 "Group Meeting"
{
    Caption = 'Group Meeting';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Group No."; Code[20])
        {
            Caption = 'Group No.';
            TableRelation = "Member Group"."No.";
            NotBlank = true;
        }
        field(3; "Meeting Date"; Date)
        {
            Caption = 'Meeting Date';
        }
        field(4; Location; Text[100])
        {
            Caption = 'Location';
        }
        field(5; Chairperson; Text[100])
        {
            Caption = 'Chairperson';
        }
        field(6; "Recorded By"; Text[100])
        {
            Caption = 'Recorded By';
        }
        field(7; Agenda; Text[250])
        {
            Caption = 'Agenda';
        }
        field(8; Minutes; Blob)
        {
            Caption = 'Minutes';
            DataClassification = CustomerContent;
        }
        field(9; "Attendee Count"; Integer)
        {
            Caption = 'Attendee Count';
            CalcFormula = count("Group Meeting Attendance" where("Meeting Entry No." = field("Entry No."), Attended = const(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Expected Member Count"; Integer)
        {
            Caption = 'Expected Member Count';
            CalcFormula = count("Group Member Line" where("Group No." = field("Group No."), Status = const(Active)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Group No.", "Meeting Date") { }
    }

    trigger OnInsert()
    var
        Group: Record "Member Group";
        Leader: Record "Group Member Line";
    begin
        if "Meeting Date" = 0D then
            "Meeting Date" := WorkDate();
        if Location = '' then
            if Group.Get("Group No.") then
                Location := Group."Meeting Location";

        if Chairperson = '' then begin
            Leader.SetRange("Group No.", "Group No.");
            Leader.SetRange(Role, Leader.Role::Chairperson);
            Leader.SetRange(Status, Leader.Status::Active);
            if Leader.FindFirst() then
                Chairperson := Leader."Member Name";
        end;
    end;

    procedure SetMinutes(NewMinutes: Text)
    var
        OutStream: OutStream;
    begin
        Clear(Minutes);
        Minutes.CreateOutStream(OutStream, TextEncoding::UTF8);
        OutStream.WriteText(NewMinutes);
    end;

    procedure GetMinutes(): Text
    var
        InStream: InStream;
        MinutesText: Text;
    begin
        CalcFields(Minutes);
        if not Minutes.HasValue() then
            exit('');
        Minutes.CreateInStream(InStream, TextEncoding::UTF8);
        InStream.ReadText(MinutesText);
        exit(MinutesText);
    end;
}
