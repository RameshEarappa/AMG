pageextension 50162 "Ext User Setup" extends "User Setup"
{
    layout
    {
        addafter(Email)
        {
            field(Create; Rec.Create) { ApplicationArea = all; }
            field("PR Release"; Rec."PR Release") { ApplicationArea = all; }
            field("Enable PR"; Rec."Enable PR") { ApplicationArea = all; }
            field("Access Vendor Master"; Rec."Access Vendor Master") { ApplicationArea = all; }
            field("Approve Vendor"; Rec."Approve Vendor") { ApplicationArea = all; }
            field("Access Item Master"; Rec."Access Item Master") { ApplicationArea = all; }
            //28.10.2020
            field("Access Customer Master"; Rec."Access Customer Master") { ApplicationArea = all; }
            //28.10.2020
            //02.11.2020
            field("Access PO Master"; Rec."Access PO Master") { ApplicationArea = all; }
            field("BRS Reviewer"; Rec."BRS Reviewer  ") { ApplicationArea = all; Caption = 'BRS Reviewer'; }
            field("BRS Approver"; Rec."BRS Approver") { ApplicationArea = all; }
            field("Access Account Schedules"; Rec."Access Account Schedules") { ApplicationArea = all; }
            field(Designation; Rec.Designation) { ApplicationArea = all; }
            field(Title; Rec.Title) { ApplicationArea = all; }
            field(UndoBRSApprove; Rec.UndoBRSApprove) { ApplicationArea = all; }
            field(UndoBRSReview; Rec.UndoBRSReview) { ApplicationArea = all; }
            field(EnablePO; Rec.EnablePO) { ApplicationArea = all; }
            field(EnablePODescription; Rec.EnablePODescription) { ApplicationArea = all; }
            field(EnablePRDescription; Rec.EnablePRDescription) { ApplicationArea = all; }
            field(EnablePQDescription; Rec.EnablePQDescription) { ApplicationArea = all; }
            //02.11.2020
        }
    }

    actions
    {
        addlast(Processing)
        {
            /*action(Signeture)
            {
                ApplicationArea = all;
                Image = Signature;
                Promoted = true;
                PromotedOnly = true;
                trigger OnAction()
                var
                    SigRec: Record Signsture_Blob;
                    SigPage: Page User_Signeature;
                    Rec2: Record "User Setup";

                begin
                    CurrPage.SetSelectionFilter(Rec2);
                    If Rec2.FindFirst() then begin

                        SigRec.Reset();
                        SigRec.SetRange("User ID", Rec2."User ID");
                        SigPage.SetTableView(SigRec);
                        SigPage.RunModal();

                    end;

                End;
            }*/
            /* action(Signature )
             {
                 ApplicationArea = all;
                 Image = Signature;
                 Promoted = true;
                 PromotedOnly = true;
                 trigger OnAction()
                 var
                     SigRec: Record SignatureTable;
                     SigPage: Page SignatureList;
                     Rec2: Record "User Setup";

                 begin
                     CurrPage.SetSelectionFilter(Rec2);
                     If Rec2.FindFirst() then begin

                         SigRec.Reset();
                         SigRec.SetRange("User ID", Rec2."User ID");
                         SigPage.SetTableView(SigRec);
                         SigPage.RunModal();

                     end;
                 End;
             }*/
        }
    }

    var
        myInt: Integer;
        Comp: Page "Company Information";
}
