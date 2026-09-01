page 70781 "Group Member Lines"
{
    Caption = 'Members';
    PageType = ListPart;
    SourceTable = "Group Member Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Member No."; Rec."Member No.")
                {
                    ApplicationArea = All;
                }
                field("Member Name"; Rec."Member Name")
                {
                    ApplicationArea = All;
                }
                field(Role; Rec.Role)
                {
                    ApplicationArea = All;
                }
                field("Date Joined"; Rec."Date Joined")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Date Exited"; Rec."Date Exited")
                {
                    ApplicationArea = All;
                }
                field("Member Contribution Balance"; Rec."Member Contribution Balance")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if Rec."Date Joined" = 0D then
            Rec."Date Joined" := WorkDate();
    end;
}
