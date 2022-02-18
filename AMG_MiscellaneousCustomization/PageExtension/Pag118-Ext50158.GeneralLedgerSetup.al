pageextension 50158 pageextension50158 extends "General Ledger Setup"
{

    layout
    {
        addlast(General)
        {
            field(AMG_SynchronizeGLAccount; Rec.AMG_SynchronizeGLAccount)
            {
                Caption = 'Synchronize G/L Account';
                ApplicationArea = All;
                ToolTip = 'Specifies if G/L accounts are automatically synchronize in all companies or not.';
            }
            field("BRS- Reviewed By"; Rec."BRS- Reviewed By")
            {
                Caption = 'BRS- Reviewed By';
                ApplicationArea = All;
                Visible = False;

            }
        }
    }
}
