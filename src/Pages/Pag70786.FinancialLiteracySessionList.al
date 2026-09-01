page 70786 "Fin. Literacy Session List"
{
    Caption = 'Financial Literacy Sessions';
    PageType = List;
    SourceTable = "Financial Literacy Session";
    CardPageId = "Fin. Literacy Session Card";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field(Topic; Rec.Topic)
                {
                    ApplicationArea = All;
                }
                field("Session Date"; Rec."Session Date")
                {
                    ApplicationArea = All;
                }
                field(Facilitator; Rec.Facilitator)
                {
                    ApplicationArea = All;
                }
                field("Group No."; Rec."Group No.")
                {
                    ApplicationArea = All;
                }
                field("Attendee Count"; Rec."Attendee Count")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
