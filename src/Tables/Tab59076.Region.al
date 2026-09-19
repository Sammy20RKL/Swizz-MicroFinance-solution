#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
table 59076 "Region"
{
    Caption = 'Region';
    DataClassification = CustomerContent;
    DrillDownPageId = "Region List";
    LookupPageId = "Region List";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; "Name"; Text[50])
        {
            Caption = 'Name';
        }
    }

    keys
    {
        key(PK; "Code") { Clustered = true; }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", "Name") { }
    }
}
