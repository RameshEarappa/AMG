tableextension 50400 "Ext Gen. Journal Line" extends "Gen. Journal Line"
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
        field(50410; "Check Prepared Date"; Date)
        {
        }
        field(50420; "Check Issued Date"; Date)
        {
        }
        field(50430; Narration; Text[250])
        {
        }
        field(50440; "PO No."; Code[20])
        {
            TableRelation = "Purchase Header"."No." Where("Document Type" = filter(Order));
        }
        field(50450; "Void Check"; Boolean)
        { }
        field(50451; Select; Boolean)
        { }
        field(50452; "Request Sent"; Boolean)
        { }
        field(50453; "Add Charges"; Boolean)
        { }
        field(50454; "Amount(ABS)"; Decimal)
        { }
        field(50455; "Shortcut Dimension 3 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(3), Blocked = CONST(false));
            CaptionClass = '1,2,3';
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                //ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
            end;
        }
        field(50456; "Shortcut Dimension 4 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(4), Blocked = CONST(false));
            CaptionClass = '1,2,4';
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                ValidateShortcutDimCode(4, "Shortcut Dimension 4 Code");
            end;
        }
        field(50457; "Shortcut Dimension 5 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(5), Blocked = CONST(false));
            CaptionClass = '1,2,5';
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                ValidateShortcutDimCode(5, "Shortcut Dimension 5 Code");
            end;
        }
        field(50458; "Shortcut Dimension 6 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(6), Blocked = CONST(false));
            CaptionClass = '1,2,6';
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                ValidateShortcutDimCode(6, "Shortcut Dimension 6 Code");
            end;
        }
        field(50459; "Shortcut Dimension 7 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(7), Blocked = CONST(false));
            CaptionClass = '1,2,7';
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                ValidateShortcutDimCode(7, "Shortcut Dimension 7 Code");
            end;
        }
        field(50460; "Shortcut Dimension 8 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(8), Blocked = CONST(false));
            CaptionClass = '1,2,8';
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                ValidateShortcutDimCode(8, "Shortcut Dimension 8 Code");
            end;
        }
        field(50461; "Backcharge"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50462; "Backcharge To"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }
    trigger OnAfterModify()
    var
        myInt: Integer;
    begin
        //02.11.2020
        ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
        ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
        //02.11.2020
        ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
        ValidateShortcutDimCode(4, "Shortcut Dimension 4 Code");
        ValidateShortcutDimCode(5, "Shortcut Dimension 5 Code");
        ValidateShortcutDimCode(6, "Shortcut Dimension 6 Code");
        ValidateShortcutDimCode(7, "Shortcut Dimension 7 Code");
        ValidateShortcutDimCode(8, "Shortcut Dimension 8 Code");
    end;

    trigger OnAfterInsert()
    var
        myInt: Integer;
    begin

        //02.11.2020
        ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
        ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
        //02.11.2020
        ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
        ValidateShortcutDimCode(4, "Shortcut Dimension 4 Code");
        ValidateShortcutDimCode(5, "Shortcut Dimension 5 Code");
        ValidateShortcutDimCode(6, "Shortcut Dimension 6 Code");
        ValidateShortcutDimCode(7, "Shortcut Dimension 7 Code");
        ValidateShortcutDimCode(8, "Shortcut Dimension 8 Code");
    end;

}