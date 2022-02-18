pageextension 50161 pageextension50161 extends "Job Journal"
{
    layout
    {
        addafter("No.")
        {
            field("Gen. Bus. Posting Group36629"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        modify(CalcRemainingUsage)
        {
            Visible = false;
        }
        addafter(CalcRemainingUsage)
        {
            action(AMG_CalcRemainingUsage)
            {
                ApplicationArea = Jobs;
                Caption = 'Calc. Remaining Usage';
                Ellipsis = true;
                Image = CalculateRemainingUsage;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Calculate the remaining usage for the job. The batch job calculates, for each job task, the difference between scheduled usage of items, and resources and actual usage posted in job ledger entries. The remaining usage is then displayed in the job journal from where you can post it.';

                trigger OnAction()
                var
                    JobCalcRemainingUsage: Report "AMG_JobCalcRemainingUsage";
                begin
                    Rec.TestField("Journal Template Name");
                    Rec.TestField("Journal Batch Name");
                    Clear(JobCalcRemainingUsage);
                    JobCalcRemainingUsage.SetBatch(Rec."Journal Template Name", Rec."Journal Batch Name");
                    JobCalcRemainingUsage.SetDocNo(Rec."Document No.");
                    JobCalcRemainingUsage.RunModal;
                end;
            }
        }
    }
}