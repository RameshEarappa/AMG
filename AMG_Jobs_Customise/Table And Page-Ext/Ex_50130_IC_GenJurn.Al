pageextension 50130 Ic_Genjour extends "IC General Journal"
{
    layout
    {

    }

    actions
    {
        addafter("Apply Entries")
        {
            Action("Payment Voucher")
            {
                ApplicationArea = All;
                Caption = 'General Voucher';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction();
                var
                    VouchRep: Report "InterCompVoucher_Report";
                    GJLRec2: Record "Gen. Journal Line";
                    GJLRec: Record "Gen. Journal Line";
                begin
                    Clear(VouchRep);
                    CurrPage.SetSelectionFilter(GJLRec);
                    if GJLRec.FindFirst() then;
                    GJLRec2.SetRange("Document No.", GJLRec."Document No.");
                    IF GJLRec2.FindFirst() then;
                    VouchRep.SetTableView(GJLRec2);
                    VouchRep.RunModal();
                end;
            }
        }

    }

    var
        myInt: Integer;
}