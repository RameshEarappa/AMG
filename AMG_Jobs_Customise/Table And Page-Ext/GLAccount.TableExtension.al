tableextension 50101 "GL Account Ext" extends "G/L Account"
{
    fields
    {
        field(50000; "Additional Balance SAR"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Additional Balance SAR';
        }
        field(50001; "G/L Account Category"; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "G/L Account Subcategory"; text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}