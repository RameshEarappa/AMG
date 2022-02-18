pageextension 50154 pageextension50154 extends "Jobs Setup"
{
    layout
    {
        addlast(General)
        {
            field(AMG_NotAllowExceedBudget; Rec.AMG_NotAllowExceedBudget)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the posting is allowed while it is exceeding the budget.';
            }
        }
    }
}