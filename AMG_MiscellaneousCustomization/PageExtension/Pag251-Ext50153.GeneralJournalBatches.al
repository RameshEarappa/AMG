pageextension 50153 pageextension50153 extends "General Journal Batches"
{
    layout
    {
        addlast(Control1)
        {
            field(AMG_GenBusPostingGroup; Rec.AMG_GenBusPostingGroup)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the vendor''s or customer''s trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.';
            }
        }
        addafter("No. Series")
        {
            field("Voucher No."; Rec."Voucher No.")
            {
                ApplicationArea = All;
            }
        }
    }
}