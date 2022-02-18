tableextension 50158 tableextension50158 extends "General Ledger Setup"
{

    fields
    {
        field(50151; AMG_SynchronizeGLAccount; Boolean)
        {
            Caption = 'Synchronize G/L Account';
            DataClassification = CustomerContent;
        }
        field(50152; "BRS- Reviewed By"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User";

        }
    }

}