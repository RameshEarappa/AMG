pageextension 60111 PurchLineArchiveExt extends "Purchase Quote Archive Subform"
{
    layout
    {
        addafter(Description)
        {
            field(AMG_InitSourceNo; Rec.AMG_InitSourceNo)
            {
                ApplicationArea = all;

            }
            Field(AMG_InitSourceLineNo; Rec.AMG_InitSourceLineNo)
            {
                ApplicationArea = all;

            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}