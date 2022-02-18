pageextension 50409 Ex_Cash_Receipt_Journal extends "Cash Receipt Journal"
{
    layout
    {
        addafter("Document No.")
        {
            field(Narration; Rec.Narration)
            { ApplicationArea = all; }
            field("Check Issued Date"; Rec."Check Issued Date") { ApplicationArea = all; }
            field("Check Prepared Date"; Rec."Check Prepared Date") { ApplicationArea = all; }
        }
    }

    actions
    {
        addafter("Apply Entries")
        {
            Action("Payment Voucher")
            {
                ApplicationArea = All;
                Caption = 'Cash Receipt Voucher';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction();
                var
                    VouchRep: Report "Cash Voucher_Repor";
                    //VouchRep: Report "_Cash_Journal Voucher";
                    GJLRec2: Record "Gen. Journal Line";
                    GJLRec: Record "Gen. Journal Line";
                begin
                    Clear(VouchRep);
                    CurrPage.SetSelectionFilter(GJLRec);
                    if GJLRec.FindFirst() then;
                    GJLRec.TestField("Document No.");
                    GJLRec2.SetRange("Document No.", GJLRec."Document No.");
                    IF GJLRec2.FindFirst() then;
                    VouchRep.SetTableView(GJLRec2);
                    VouchRep.RunModal();
                end;
            }
        }
    }

    var
        CompanyInfoG: Record "Company Information";
        SetVisibleG: Boolean;
}