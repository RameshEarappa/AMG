tableextension 50408 "Ext Bank Acc. Reconciliation" extends "Bank Acc. Reconciliation"
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
            Editable = False;
            TableRelation = User."User Name";

        }
        field(50402; "Prepared By Date"; date)
        {
            DataClassification = ToBeClassified;
            Editable = False;

        }
        field(60401; Reviewed; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = False;

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
        field(60410; "Approver id"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60411; "Reviewer id"; code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60402; Approved; Boolean)
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