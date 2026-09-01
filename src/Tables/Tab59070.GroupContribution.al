table 59070 "Group Contribution"
{
    Caption = 'Group Contribution';
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
        field(3; "Member No."; Code[20])
        {
            Caption = 'Member No.';
            TableRelation = "Group Member Line"."Member No." where("Group No." = field("Group No."));
            NotBlank = true;

            trigger OnValidate()
            var
                Member: Record Customer;
            begin
                if Member.Get("Member No.") then
                    "Member Name" := Member.Name;
            end;
        }
        field(4; "Member Name"; Text[100])
        {
            Caption = 'Member Name';
        }
        field(5; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(6; "Contribution Type"; Option)
        {
            Caption = 'Contribution Type';
            OptionMembers = "Regular Contribution","Micro-Savings/Table-Banking";
        }
        field(7; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(8; "Posted By"; Code[50])
        {
            Caption = 'Posted By';
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Group No.", "Member No.") { }
    }

    trigger OnInsert()
    begin
        if "Posted By" = '' then
            "Posted By" := CopyStr(UserId(), 1, MaxStrLen("Posted By"));
        if "Posting Date" = 0D then
            "Posting Date" := WorkDate();
    end;
}
