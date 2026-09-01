page 70802 "Agent Reassignment Log"
{
    Caption = 'Agent Reassignment Log';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = History;
    SourceTable = "Agent Reassignment Log";
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

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
                field("Reassignment Date"; Rec."Reassignment Date")
                {
                    ApplicationArea = All;
                }
                field("From Agent No."; Rec."From Agent No.")
                {
                    ApplicationArea = All;
                }
                field("To Agent No."; Rec."To Agent No.")
                {
                    ApplicationArea = All;
                }
                field(Reason; Rec.Reason)
                {
                    ApplicationArea = All;
                }
                field("Members Moved"; Rec."Members Moved")
                {
                    ApplicationArea = All;
                }
                field("Groups Moved"; Rec."Groups Moved")
                {
                    ApplicationArea = All;
                }
                field("Loans Moved"; Rec."Loans Moved")
                {
                    ApplicationArea = All;
                }
                field("Reassigned By"; Rec."Reassigned By")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
