page 70795 "Agent Member Onboarding"
{
    Caption = 'Agent Member Onboarding';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    SourceTable = Customer;
    SourceTableView = where("Agent No." = filter(<> ''));
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Agent No."; Rec."Agent No.")
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'Member No.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Registration Date"; Rec."Registration Date")
                {
                    ApplicationArea = All;
                }
                field("Group No."; Rec."Group No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
