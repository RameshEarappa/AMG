tableextension 50125 "ExtSales Cr.Memo Header" extends "Sales Cr.Memo Header"
{
    fields
    {
        Field(50000; "Invoice Period"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;

        }
        field(50001; "Bank Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account";
            Caption = 'Bank Account';
            Editable = false;

        }
        field(50009; "Corresponding Bank"; Code[20])
        { }
    }

    var
        myInt: Integer;
}

pageextension 50133 "Ext Posted Sales Credit Memo" extends "Posted Sales Credit Memo"
{
    layout
    {
        addafter("No. Printed")
        {
            field("Invoice Period"; Rec."Invoice Period")
            {
                ApplicationArea = all;
            }
            field("Banck Account"; Rec."Bank Account")
            {
                ApplicationArea = all;
            }
            field("Corresponding Bank"; Rec."Corresponding Bank")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addafter(Print)
        {
            Action("Proforma Invoice")
            {
                ApplicationArea = All;
                Caption = 'Cr.Memo Invoice';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;

                trigger OnAction();
                var
                    SlcrRep: Report "PosSalCrMemo";
                    SlcrRec: Record "Sales Cr.Memo Header";
                begin
                    Clear(SlcrRep);
                    SlcrRec.SetRange("No.", Rec."No.");
                    SlcrRep.SetTableView(SlcrRec);
                    SlcrRep.RunModal();
                end;
            }
        }
    }
    var
        myInt: Integer;
}
