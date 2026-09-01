table 59071 "Financial Literacy Session"
{
    Caption = 'Financial Literacy Session';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; Topic; Text[100])
        {
            Caption = 'Topic';
            NotBlank = true;
        }
        field(3; "Session Date"; Date)
        {
            Caption = 'Session Date';
        }
        field(4; Facilitator; Text[100])
        {
            Caption = 'Facilitator';
        }
        field(5; "Group No."; Code[20])
        {
            Caption = 'Group No.';
            TableRelation = "Member Group"."No.";
        }
        field(6; "Branch Code"; Code[20])
        {
            Caption = 'Branch';
            TableRelation = "Dimension Value".Code;
        }
        field(7; Location; Text[100])
        {
            Caption = 'Location';
        }
        field(8; "Attendee Count"; Integer)
        {
            Caption = 'Attendee Count';
            CalcFormula = count("Financial Literacy Attendance" where("Session Entry No." = field("Entry No."), Attended = const(true)));
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
        key(Key2; "Group No.", "Session Date") { }
    }
}
