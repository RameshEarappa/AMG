pageextension 50109 "GL Account List Ext" extends "Chart of Accounts"
{
    layout
    {
        addafter(Balance)
        {
            field("Additional Balance SAR"; ConverstionAmtG)
            {
                ApplicationArea = All;
            }
            field("G/L Account Category"; Rec."G/L Account Category")
            {
                ApplicationArea = All;
            }
            field("G/L Account Subcategory"; Rec."G/L Account Subcategory")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    trigger OnAfterGetRecord()
    var
        CurrencyExcRateL: Record "Currency Exchange Rate";
    begin
        Clear(ConverstionAmtG);
        Rec.CalcFields(Balance);
        if (Rec."No." = '1002000') OR (Rec."No." = '1002100') then begin
            CurrencyExcRateL.SetRange("Currency Code", 'SAR');
            if CurrencyExcRateL.FindFirst() then
                ConverstionAmtG := Rec.Balance * CurrencyExcRateL."Relational Exch. Rate Amount";
        end;
    end;

    var
        ConverstionAmtG: Decimal;
}