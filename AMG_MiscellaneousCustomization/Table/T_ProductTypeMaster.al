table 60116 "Product Type"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Product Type Code"; Code[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Product Type Code';

        }
    }

    keys
    {
        key(PK; "Product Type Code")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;


}