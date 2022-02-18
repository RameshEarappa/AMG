tableextension 50402 "Ext GL Entry" extends "G/L Entry"
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
        field(50430; Narration; Text[250])
        {
        }
        field(50440; "Currency Code"; code[20]) { }
        field(50450; "Currency Factor"; Decimal) { }
        field(50460; "Amount From GJnl"; Decimal) { }
        field(50420; "Check Issued Date"; Date)
        {
        }
        field(50421; "Additional Balance SAR"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Additional Balance SAR';
        }
        field(50422; "Amount in SAR"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount in SAR';
        }
        field(50423; "Currency Factor(SAR)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Currency Factor(SAR)';
        }
        //02.11.2020
        field(50461; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(1));
            CaptionClass = '1,2,1';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                myInt: Integer;
                DimVal: Record "Dimension Value";
            begin
                Dimval.Reset;
                DimVal.SetRange("Dimension Code", 'VESSELS');
                Dimval.SetRange(Code, "Global Dimension 1 Code");
                if dimval.findfirst then
                    Validate("Vessel Name", DimVal.Name);
            end;
        }
        field(50462; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(2));
            CaptionClass = '1,2,2';
            DataClassification = ToBeClassified;
        }

        //02.11.2020

        field(50431; "Vessel Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        //02.11.2020

        field(50432; "Backcharge"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50433; "Backcharge To"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    procedure ShowShortcutDimCode(VAR ShortcutDimCode: ARRAY[8] OF Code[20])
    var
        myInt: Integer;
        DimMgt: codeunit DimensionManagement;
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;


}
