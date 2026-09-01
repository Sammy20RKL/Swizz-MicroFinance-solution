page 70785 "Fin. Literacy Session Card"
{
    Caption = 'Financial Literacy Session';
    PageType = Card;
    SourceTable = "Financial Literacy Session";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
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
                field("Branch Code"; Rec."Branch Code")
                {
                    ApplicationArea = All;
                    Caption = 'Branch';
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = All;
                }
                field("Attendee Count"; Rec."Attendee Count")
                {
                    ApplicationArea = All;
                }
            }
            part(Attendance; "Financial Literacy Attendance")
            {
                ApplicationArea = All;
                Caption = 'Attendance';
                SubPageLink = "Session Entry No." = field("Entry No.");
                UpdatePropagation = Both;
            }
        }
    }
}
