page 70780 "Member Group List"
{
    Caption = 'Member Groups';
    PageType = List;
    SourceTable = "Member Group";
    CardPageId = "Member Group Card";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Group Type"; Rec."Group Type")
                {
                    ApplicationArea = All;
                }
                field("Agent No."; Rec."Agent No.")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
