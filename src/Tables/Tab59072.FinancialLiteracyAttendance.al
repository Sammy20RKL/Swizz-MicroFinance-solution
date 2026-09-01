table 59072 "Financial Literacy Attendance"
{
    Caption = 'Financial Literacy Attendance';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Session Entry No."; Integer)
        {
            Caption = 'Session Entry No.';
            TableRelation = "Financial Literacy Session"."Entry No.";
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
        field(5; "Certification Status"; Option)
        {
            Caption = 'Certification Status';
            OptionMembers = "Not Certified",Certified;
        }
    }

    keys
    {
        key(PK; "Session Entry No.", "Member No.")
        {
            Clustered = true;
        }
        key(Key2; "Member No.") { }
    }

    procedure MemberHasCompletedLiteracyTraining(MemberNo: Code[20]): Boolean
    var
        Attendance: Record "Financial Literacy Attendance";
    begin
        Attendance.SetRange("Member No.", MemberNo);
        Attendance.SetRange("Certification Status", Attendance."Certification Status"::Certified);
        exit(not Attendance.IsEmpty());
    end;
}
