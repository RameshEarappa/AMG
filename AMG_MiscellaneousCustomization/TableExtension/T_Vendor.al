tableextension 60115 VendorExt extends Vendor
{
    fields
    {
        field(50000; Mobile_No; Text[20])
        {
            Caption = 'Mobile No.';
            ExtendedDatatype = PhoneNo;
            DataClassification = ToBeClassified;
        }
        field(50001; "E-mail 2"; Text[100])
        {
            Caption = 'E-Mail 2';
            ExtendedDatatype = EMail;
            DataClassification = ToBeClassified;
        }
        Field(50002; "Sub. Category"; Text[100])
        {
            Caption = 'Sub. Category';
            DataClassification = ToBeClassified;
        }
        field(50003; "ICV/ IKTVA"; option)
        {
            Caption = 'ICV/IKTVA';
            DataClassification = ToBeClassified;
            OptionMembers = "YES","NO";

        }
        field(50004; "Score"; Decimal)
        {
            Caption = 'Score';
            DataClassification = ToBeClassified;
        }
        Field(50005; "ICV/ IKTVA Expiry Date"; Date)
        {
            Caption = 'ICV/ IKTVA Expiry Date';
            DataClassification = ToBeClassified;
        }
        field(50006; "Commercial License No."; Code[20])
        {
            Caption = 'Commercial License No.';
            DataClassification = ToBeClassified;
        }
        Field(50007; "Commercial License Expiry Date"; Date)
        {
            Caption = 'Commercial License Expiry Date';
            DataClassification = ToBeClassified;
        }
        Field(50008; "Product/ Service Type"; Code[100])
        {
            Caption = 'Product/ Service Type';
            DataClassification = ToBeClassified;
            TableRelation = "Product Type"."Product Type Code";
        }
        //28.10.2020
        field(50009; "Our Account No"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Our Account No.';
        }
        //28.10.2020
    }

    var
        myInt: Integer;
        ExpiryDateEdit: Boolean;
}