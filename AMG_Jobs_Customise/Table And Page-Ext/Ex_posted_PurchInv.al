pageextension 50120 PosPurchInv extends "Posted Purchase Invoice"
{
    layout
    {
        addafter("Shortcut Dimension 1 Code")
        {
            field("Vessel Name"; Rec."Vessel Name")
            {
                ApplicationArea = all;
            }
            field(Backcharge; Rec.Backcharge)
            {
                ApplicationArea = All;
            }
            field("Backcharged To"; Rec."Backcharged To")
            {
                ApplicationArea = all;
            }
            field(Purposes; Rec.Purposes)
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        addafter(Print)
        {
            Action("Sales Invoice Summary Report")
            {
                ApplicationArea = All;
                Caption = 'Purchase - Invoice';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction();
                var
                    InvRep: Report "Purchase - Invoice_New";
                    PosInvHedRec: Record "Purch. Inv. Header";
                begin
                    Clear(InvRep);
                    PosInvHedRec.SetRange("No.", Rec."No.");
                    InvRep.SetTableView(PosInvHedRec);
                    InvRep.RunModal();
                end;
            }
        }
    }

    var
        myInt: Integer;
}

tableextension 50165 "Extd. Purch. Invoice" extends "Purch. Inv. Header"
{
    fields
    {
        field(50160; "Vessel Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Value".Name where(Code = field("Shortcut Dimension 1 Code")));
        }
        field(50009; Purposes; Option)
        {
            OptionMembers = ,"Dry Docking 5Y","Dry Docking Int 3Y","O/H Major","O/H T","Opex","Mobilisation",Capex;
            DataClassification = ToBeClassified;
            Caption = 'Purpose';

        }
        field(50155; "Backcharge"; Option)
        {
            OptionMembers = " ",Yes,No;
        }
        Field(50156; "Backcharged To"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Backcharge To';
        }
    }

    var
        myInt: Integer;
}