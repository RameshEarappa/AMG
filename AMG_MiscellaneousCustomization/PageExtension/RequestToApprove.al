pageextension 60150 RequestApp extends "Requests to Approve"
{



    actions
    {
        addafter(Comments)
        {
            Action(OpenRecords)
            {
                Caption = 'Open Records - Multiple';
                ApplicationArea = all;
                Promoted = True;
                PromotedIsBig = TRUE;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    myInt: Integer;
                begin
                    Genjnlline.Reset;
                    Genjnlline.Setrange("Document No.", Rec."Document No.");
                    if Genjnlline.findfirst then;

                    if Genjnlline."Journal Template Name" = 'PAYMENTS' then begin
                        PaymentJournal.SetTableView(Genjnlline);
                        PaymentJournal.RUN;
                    end;

                    if Genjnlline."Journal Template Name" = 'GENERAL' then begin
                        Genjnl.SetTableView(Genjnlline);
                        Genjnl.RUN;
                    end;
                end;

            }
        }


    }

    var
        myInt: Integer;
        Genjnlline: Record "Gen. Journal Line";
        Genjnlline1: Record "Gen. Journal Line";
        PaymentJournal: Page "Payment Journal";
        Genjnl: page "General Journal";
}