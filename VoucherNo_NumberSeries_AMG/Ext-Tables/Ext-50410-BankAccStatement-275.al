tableextension 50410 "Ext Bank Account Statement" extends "Bank Account Statement"
{
    fields
    {
        field(50400; "Voucher No."; Code[20])
        {
            DataClassification = ToBeClassified;
            trigger
            OnValidate()
            begin

            end;
        }
        field(50401; "Prepared By"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = User."User Name";

        }
        field(50402; "Prepared By Date"; date)
        {
            DataClassification = ToBeClassified;

        }
        field(50403; "Reviewed By Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = False;


        }
        field(50404; "Approved By Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60410; "Approver id"; code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60411; "Reviewer id"; code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }



    }
    trigger OnAfterInsert()
    var
        myInt: Integer;
    begin
        VALIDATE("Prepared By", UserId);
        VALIDATE("Prepared By Date", Today);
    end;
}