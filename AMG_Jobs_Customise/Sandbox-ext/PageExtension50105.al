pageextension 50205 PageExtension50105 extends "Column Layout"
{
    layout
    {
        addafter(Show)
        {
            /* field("Dimension 2 Totaling61475"; "Dimension 2 Totaling")
             {
                 ApplicationArea = All;
             }
             field("Dimension 1 Totaling24029"; "Dimension 1 Totaling")
             {
                 ApplicationArea = All;
             }*/
        }
        moveafter(Show; "Dimension 1 Totaling")
        moveafter("Dimension 1 Totaling"; "Dimension 2 Totaling")
    }
    actions
    {
    }
}
