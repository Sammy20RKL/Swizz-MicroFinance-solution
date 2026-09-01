page 50428 "Member Statistics FactBox"
{
    Caption = 'Member FactBox';
    Editable = false;
    PageType = CardPart;
    SaveValues = true;
    SourceTable = Customer;

    layout
    {
        area(content)
        {
            field(Image; Rec.Image)
            {
                ApplicationArea = Basic;
                Caption = 'Member No.';
            }
            field("No."; Rec."No.")
            {
                ApplicationArea = Basic;
                Caption = 'Member No.';
            }
            field(Name; Rec.Name)
            {
                ApplicationArea = Basic;
            }
            field("ID No."; Rec."ID No.")
            {
                ApplicationArea = Basic;
            }
            field("Mobile Phone No"; Rec."Phone No.")
            {
                ApplicationArea = Basic;
            }
            group("Member Details FactBox")
            {
                Caption = 'Member Details FactBox';

                field("Agent No."; Rec."Agent No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Agent';
                }
                field("Agent Name"; Rec."Agent Name")
                {
                    ApplicationArea = Basic;
                }
                field("Group No."; Rec."Group No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Group';
                }
                field("Group Name"; Rec."Group Name")
                {
                    ApplicationArea = Basic;
                }
                field("Financial Literacy Certified"; Rec."Financial Literacy Certified")
                {
                    ApplicationArea = Basic;
                    StyleExpr = LiteracyStyleExpr;
                }
                field("No. of Issued Loans"; Rec."No. of Issued Loans")
                {
                    ApplicationArea = Basic;
                    Caption = 'Loans Taken';
                    DrillDown = true;
                }
                field("Outstanding Balance"; Rec."Outstanding Balance")
                {
                    ApplicationArea = Basic;
                    Caption = 'Loan Outstanding Balance';
                }
                field("Outstanding Interest"; Rec."Outstanding Interest")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields(
            "Agent Name",
            "Group Name",
            "Financial Literacy Certified",
            "No. of Issued Loans",
            "Outstanding Balance",
            "Outstanding Interest");

        LiteracyStyleExpr := 'Unfavorable';
        if Rec."Financial Literacy Certified" then
            LiteracyStyleExpr := 'Favorable';
    end;

    var
        LiteracyStyleExpr: Text;
}
