page 70777 "Agent Lists"
{
    Caption = 'Agents List';
    PageType = List;
    SourceTable = Agents;
    UsageCategory = Lists;
    ApplicationArea = All;
    CardPageId = "Agent Cards";
    Editable = false;


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Full Name"; Rec."Full Name")
                {
                    ApplicationArea = All;
                    Style = StrongAccent;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                }
                field("Email"; Rec."Email")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Region Code"; Rec."Region Code")
                {
                    ApplicationArea = All;
                    Caption = 'Region';
                    Visible = false;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ApplicationArea = All;
                    Caption = 'Branch';
                }
                field("Date Joined"; Rec."Date Joined")
                {
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                    StyleExpr = StatusStyleExpr;
                }
            }
        }
        area(factboxes)
        {
            part(Control1; "Agent Picture")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("No.");
                Enabled = true;
            }
            part("Agent Statistics FactBox"; "Agent Statistics FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(NewAgent)
            {
                ApplicationArea = All;
                Caption = 'New Agent';
                Image = New;
                RunObject = page "Agent Cards";
                RunPageMode = Create;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields(
            "Customers Onboarded",
            "Loans Originated");

        case Rec.Status of
            Rec.Status::Active:
                StatusStyleExpr := 'Favorable';
            Rec.Status::Suspended:
                StatusStyleExpr := 'Unfavorable';
            else
                StatusStyleExpr := 'Subordinate';
        end;

        PARStyleExpr := 'Unfavorable';
        if Rec."Portfolio at Risk (>30 Days)" = 0 then
            PARStyleExpr := 'Favorable';
    end;

    var
        StatusStyleExpr: Text;
        PARStyleExpr: Text;
        tr: page 70783;
}