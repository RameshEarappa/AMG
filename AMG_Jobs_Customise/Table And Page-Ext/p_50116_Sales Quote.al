pageextension 50116 Ex_Sales_Quot extends "Sales Quote"
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field(To_Customer_Name; Rec.To_Customer_Name)
            {
                ApplicationArea = all;
                Caption = 'To Customer';
            }
        }
        addlast(General)
        {
            field("SCOPE OF WORK"; Rec."SCOPE OF WORK")
            {
                ApplicationArea = all;
            }
        }
        addafter("Work Description")
        {
            field(Validity; Rec.Validity) { ApplicationArea = all; }
            field(Location; Rec.Location) { ApplicationArea = all; }
            field("Client Location"; Rec."Client Location") { ApplicationArea = all; }
            field(Exclusion; Rec.Exclusion) { ApplicationArea = all; }
            field(Completion; Rec.Completion) { ApplicationArea = all; }
            field("QUOTATION STATUS"; Rec."QUOTATION STATUS") { ApplicationArea = all; }
            field(REMARKS; Rec.REMARKS) { ApplicationArea = all; }
            field("Invoice Text"; Rec."Invoice Text") { ApplicationArea = all; }
        }
    }

    actions
    {
        addafter(SendApprovalRequest)
        {
            Action("Report")
            {
                ApplicationArea = All;
                Caption = 'Report';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction();
                var
                    SalesQutRep: Report "Sales Quote";
                    SalesHeadRec: Record "Sales Header";
                begin
                    Clear(SalesQutRep);
                    SalesHeadRec.SetRange("No.", Rec."No.");
                    SalesQutRep.SetTableView(SalesHeadRec);
                    SalesQutRep.RunModal();
                end;
            }
        }

    }
    trigger OnOpenPage()
    Var
        GLSetup: Record "General Ledger Setup";
        DimSetEntRec: Record "Dimension Set Entry";
    begin

        GLSetup.Get();
        DimSetEntRec.Reset();
        DimSetEntRec.SetRange("Dimension set ID", rEC."Dimension Set ID");
        DimSetEntRec.SetRange("Dimension Code", GLSetup."Global Dimension 1 Code");
        if DimSetEntRec.FindFirst() then begin
            //DimSetEntRec.CalcFields("Dimension Value Code");
            Rec."Vessel Name" := DimSetEntRec."Dimension Value Name"
        end;
    End;

}