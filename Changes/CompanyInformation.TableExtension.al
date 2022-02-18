tableextension 50100 "Company Information Ext" extends "Company Information"
{
    fields
    {
        field(50000; "E-Mail 2"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'E-Mail 2';
        }
    }

    var
        myInt: Integer;
}