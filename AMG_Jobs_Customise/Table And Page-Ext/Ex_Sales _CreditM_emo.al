pageextension 50135 "ex_Sales Credit Memo" extends "Sales Credit Memo"
{
    layout
    {
        // Add changes to page layout here
        addafter("Bill-to Contact")
        {
            field("Ship-to Code"; Rec."Ship-to Code")
            {
                ApplicationArea = all;
                Editable = true;
            }
        }
        addafter("External Document No.")
        {
            field("Invoice Period"; Rec."Invoice Period")
            {
                ApplicationArea = All;
            }
            field("Banck Account"; Rec."Banck Account")
            {
                ApplicationArea = All;
            }
            field("Corresponding Bank"; Rec."Corresponding Bank")
            {
                ApplicationArea = All;
            }
        }

    }
    actions
    {
        addafter(Reopen)
        {
            Action("Draft Report")
            {
                ApplicationArea = All;
                Caption = 'Draft Cr.Memo Invoice';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;

                trigger OnAction();
                var
                    SlcrRep: Report "Draft_Cr_memo Invoice";
                    SlRec: Record "Sales Header";
                begin
                    Clear(SlcrRep);
                    SlRec.SetRange("No.", Rec."No.");
                    SlcrRep.SetTableView(SlRec);
                    SlcrRep.RunModal();
                end;
            }
        }
    }
    var
        myInt: Integer;
}