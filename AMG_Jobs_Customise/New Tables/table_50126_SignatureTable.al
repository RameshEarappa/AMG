table 50126 SignatureTable
{
    LookupPageId = SignatureCrd;

    fields
    {
        field(1; "User ID"; Code[50])
        {
            //  DataClassification = ToBeClassified;
            TableRelation = "User Setup";
        }
        field(2; image; BLOB)
        {
            Caption = 'Signature';
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
    }

    keys
    {
        key(Key1; "User ID")
        {
            Clustered = true;
        }
    }

}

