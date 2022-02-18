tableextension 60100 CustExt extends Customer
{
    fields
    {
        field(50000; "Shortcut Dimension 7 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(2), Blocked = CONST(false));
            Caption = 'Segments';
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 7 Code");
            end;
        }
        field(50001; "Shortcut Dimension 7 Code_Dim"; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = CONST(2), Blocked = CONST(false));
            Caption = ' Category Segments';
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                //ValidateShortcutDimCode(2, "Shortcut Dimension 7 Code_Dim");
            end;
        }
    }

    var
        myInt: Integer;
}