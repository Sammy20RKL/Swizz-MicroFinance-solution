table 59069 "Group Member Line"
{
    Caption = 'Group Member';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Group No."; Code[20])
        {
            Caption = 'Group No.';
            TableRelation = "Member Group"."No.";
            NotBlank = true;
        }
        field(2; "Member No."; Code[20])
        {
            Caption = 'Member No.';
            TableRelation = Customer."No.";
            NotBlank = true;

            trigger OnValidate()
            var
                Member: Record Customer;
            begin
                if Member.Get("Member No.") then begin
                    "Member Name" := Member.Name;
                    Member."Group No." := "Group No.";
                    Member.Modify();
                end;
            end;
        }
        field(3; "Member Name"; Text[100])
        {
            Caption = 'Member Name';
        }
        field(4; Role; Option)
        {
            Caption = 'Role';
            OptionMembers = "Ordinary Member",Chairperson,Treasurer,Secretary;

            trigger OnValidate()
            var
                OtherLine: Record "Group Member Line";
            begin
                if Role = Role::"Ordinary Member" then
                    exit;

                OtherLine.SetRange("Group No.", "Group No.");
                OtherLine.SetRange(Role, Role);
                OtherLine.SetRange(Status, OtherLine.Status::Active);
                OtherLine.SetFilter("Member No.", '<>%1', "Member No.");
                if not OtherLine.IsEmpty() then
                    Error('%1 already holds the %2 role in this group. Change their role first.', OtherLine."Member Name", Role);
            end;
        }
        field(5; "Date Joined"; Date)
        {
            Caption = 'Date Joined';
        }
        field(6; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = Active,Inactive,Exited;

            trigger OnValidate()
            var
                Loan: Record "Loans Register";
            begin
                if "Status" = xRec."Status" then
                    exit;

                if "Status" = Status::Exited then begin
                    Loan.SetRange("Client Code", "Member No.");
                    Loan.SetRange("Guarantor Group No.", "Group No.");
                    if Loan.FindSet() then
                        repeat
                            Loan.CalcFields("Outstanding Balance");
                            if Loan."Outstanding Balance" <> 0 then
                                Error('%1 still has an outstanding loan (%2) guaranteed by this group. Settle or reassign the guarantee before exiting this member.', "Member Name", Loan."Loan  No.");
                        until Loan.Next() = 0;

                    "Date Exited" := Today;
                end else
                    "Date Exited" := 0D;
            end;
        }
        field(8; "Date Exited"; Date)
        {
            Caption = 'Date Exited';
            Editable = false;
        }
        field(7; "Member Contribution Balance"; Decimal)
        {
            Caption = 'Member Contribution Balance';
            CalcFormula = sum("Group Contribution".Amount where("Group No." = field("Group No."), "Member No." = field("Member No.")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(PK; "Group No.", "Member No.")
        {
            Clustered = true;
        }
        key(Key2; "Member No.") { }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Member No.", "Member Name", Role) { }
    }
}
