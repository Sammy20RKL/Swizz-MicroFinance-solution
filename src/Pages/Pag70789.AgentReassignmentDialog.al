page 70789 "Agent Reassignment Dialog"
{
    Caption = 'Exit Agent & Reassign Portfolio';
    PageType = StandardDialog;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field("New Agent No."; NewAgentNo)
            {
                ApplicationArea = All;
                Caption = 'Reassign To Agent';
                TableRelation = Agents."No.";
                ShowMandatory = true;
                ToolTip = 'The agent who will take over the selected parts of this agent''s portfolio.';

                trigger OnValidate()
                begin
                    if (SourceAgentNo <> '') and (NewAgentNo = SourceAgentNo) then
                        Error('You cannot reassign an agent''s portfolio to themselves. Choose a different agent.');
                end;
            }
            field(Reason; Reason)
            {
                ApplicationArea = All;
                Caption = 'Reason';
                ToolTip = 'Why this agent is exiting or being reassigned, e.g. Resigned, Territory Consolidation.';
            }
            field(ReassignMembers; ReassignMembers)
            {
                ApplicationArea = All;
                Caption = 'Reassign Members';
                ToolTip = 'Move this agent''s onboarded members to the new agent.';
            }
            field(ReassignGroups; ReassignGroups)
            {
                ApplicationArea = All;
                Caption = 'Reassign Groups';
                ToolTip = 'Move this agent''s member groups to the new agent.';
            }
            field(ReassignLoans; ReassignLoans)
            {
                ApplicationArea = All;
                Caption = 'Reassign Loans';
                ToolTip = 'Move this agent''s loans to the new agent.';
            }
        }
    }

    trigger OnOpenPage()
    begin
        ReassignMembers := false;
        ReassignGroups := false;
        ReassignLoans := false;
    end;

    procedure SetSourceAgentNo(AgentNo: Code[20])
    begin
        SourceAgentNo := AgentNo;
    end;

    procedure GetNewAgentNo(): Code[20]
    begin
        exit(NewAgentNo);
    end;

    procedure GetReason(): Text[100]
    begin
        exit(Reason);
    end;

    procedure GetReassignMembers(): Boolean
    begin
        exit(ReassignMembers);
    end;

    procedure GetReassignGroups(): Boolean
    begin
        exit(ReassignGroups);
    end;

    procedure GetReassignLoans(): Boolean
    begin
        exit(ReassignLoans);
    end;

    var
        SourceAgentNo: Code[20];
        NewAgentNo: Code[20];
        Reason: Text[100];
        ReassignMembers: Boolean;
        ReassignGroups: Boolean;
        ReassignLoans: Boolean;
}
