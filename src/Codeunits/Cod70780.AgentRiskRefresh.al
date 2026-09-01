codeunit 70780 "Agent Risk Refresh"
{
    // "Outstanding Portfolio", "Portfolio at Risk (>30 Days)" and "Default Rate" on
    // the Agents table are only refreshed lazily, when someone opens that specific
    // agent's card or a report that touches it - so across agents nobody has looked
    // at recently, those figures can be stale. This batch job refreshes every agent
    // in one pass so the "Agents at Risk" list (and anyone filtering/sorting on
    // Default Rate) is looking at current numbers. Intended to be run on demand from
    // the Agent list/Role Center, or scheduled via the standard Job Queue.

    trigger OnRun()
    var
        RefreshedCount: Integer;
    begin
        RefreshedCount := RefreshAll();
        Message('%1 agent(s) refreshed.', RefreshedCount);
    end;

    procedure RefreshAll(): Integer
    var
        Agent: Record Agents;
        RefreshedCount: Integer;
    begin
        if Agent.FindSet(true) then
            repeat
                Agent.UpdatePortfolioFigures();
                Agent.Modify(true);
                RefreshedCount += 1;
            until Agent.Next() = 0;

        exit(RefreshedCount);
    end;
}
