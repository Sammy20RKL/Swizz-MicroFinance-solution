table 59073 "Agent Reassignment Log"
{
    Caption = 'Agent Reassignment Log';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "From Agent No."; Code[20])
        {
            Caption = 'From Agent No.';
            TableRelation = Agents."No.";
        }
        field(3; "To Agent No."; Code[20])
        {
            Caption = 'To Agent No.';
            TableRelation = Agents."No.";
        }
        field(4; "Reassignment Date"; Date)
        {
            Caption = 'Reassignment Date';
        }
        field(5; "Reassigned By"; Code[50])
        {
            Caption = 'Reassigned By';
            Editable = false;
        }
        field(6; Reason; Text[100])
        {
            Caption = 'Reason';
        }
        field(7; "Members Moved"; Integer)
        {
            Caption = 'Members Moved';
        }
        field(8; "Groups Moved"; Integer)
        {
            Caption = 'Groups Moved';
        }
        field(9; "Loans Moved"; Integer)
        {
            Caption = 'Loans Moved';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "From Agent No.") { }
        key(Key3; "To Agent No.") { }
    }

    trigger OnInsert()
    begin
        if "Reassignment Date" = 0D then
            "Reassignment Date" := Today;
        if "Reassigned By" = '' then
            "Reassigned By" := CopyStr(UserId(), 1, MaxStrLen("Reassigned By"));
    end;
}
