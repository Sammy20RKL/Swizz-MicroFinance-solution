page 70804 "Approved Agents List"
{
    Caption = 'Approved Agents';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Agents;
    SourceTableView = where("Approval Status" = const(Approved));
    CardPageId = "Agent Cards";
    InsertAllowed = false;
    DeleteAllowed = false;

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
                field("Full Name"; Rec."Full Name")
                {
                    ApplicationArea = All;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ApplicationArea = All;
                    Caption = 'Branch';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
