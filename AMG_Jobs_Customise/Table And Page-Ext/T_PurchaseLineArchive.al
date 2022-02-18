tableextension 60109 PurchArchiveExt extends "Purchase Line Archive"
{
    fields
    {
        field(50151; AMG_InitSourceNo; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            Caption = 'Init Source No.';

        }
        Field(50152; AMG_InitSourceLineNo; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = False;
            Caption = 'Init Source Line No.';
        }
    }

    var
        myInt: Integer;
}