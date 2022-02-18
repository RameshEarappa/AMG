pageextension 50406 "Ext Cust Ledg Entries Preview" extends "Cust. Ledg. Entries Preview"
{
    layout
    {
        addafter("Document No.")
        {
            field("Voucher No."; Rec."Voucher No.")
            {
                ApplicationArea = All;
            }
            field("Vessel Name"; Rec."Vessel Name")
            {
                ApplicationArea = All;
            }
            field("Project Code"; Rec."Project Code")
            {
                ApplicationArea = all;
            }

        }


    }
    trigger OnAfterGetCurrRecord()
    var
        GLSetup: Record "General Ledger Setup";
        DimSetEntRec: Record "Dimension Set Entry";
    begin
        GLSetup.Get();
        DimSetEntRec.Reset();
        DimSetEntRec.SetRange("Dimension set ID", rEC."Dimension Set ID");
        DimSetEntRec.SetRange("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
        if DimSetEntRec.FindFirst() then begin
            //DimSetEntRec.CalcFields("Dimension Value Code");
            Rec."Project Code" := DimSetEntRec."Dimension Value Code";
            //Modify();
        End;
    eND;

    trigger OnAfterGetRecord()
    var
        GLSetup: Record "General Ledger Setup";
        DimSetEntRec: Record "Dimension Set Entry";
    begin
        GLSetup.Get();
        DimSetEntRec.Reset();
        DimSetEntRec.SetRange("Dimension set ID", rEC."Dimension Set ID");
        DimSetEntRec.SetRange("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
        if DimSetEntRec.FindFirst() then begin
            //DimSetEntRec.CalcFields("Dimension Value Code");
            Rec."Project Code" := DimSetEntRec."Dimension Value Code";
            //  Modify();

        End;
    eND;
}


pageextension 50407 "Ext Det Cust Ledg Entr Preview" extends "Det. Cust. Ledg. Entr. Preview"
{
    layout
    {
        addafter("Document No.")
        {
            field("Voucher No."; Rec."Voucher No.")
            {
                ApplicationArea = All;
            }
        }
    }
}

pageextension 50412 "Ext Cust Ledg Entries" extends "Customer Ledger Entries"
{
    layout
    {
        addafter("Document No.")
        {
            field("Voucher No."; Rec."Voucher No.")
            {
                ApplicationArea = All;
            }
            field("Vessel Name"; Rec."Vessel Name")
            {
                ApplicationArea = All;
            }
            field("Project Code"; Rec."Project Code")
            {
                ApplicationArea = all;
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    var
        GLSetup: Record "General Ledger Setup";
        DimSetEntRec: Record "Dimension Set Entry";
    begin
        GLSetup.Get();
        DimSetEntRec.Reset();
        DimSetEntRec.SetRange("Dimension set ID", rEC."Dimension Set ID");
        DimSetEntRec.SetRange("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
        if DimSetEntRec.FindFirst() then begin
            //DimSetEntRec.CalcFields("Dimension Value Code");
            Rec."Project Code" := DimSetEntRec."Dimension Value Code";

        End;
    eND;

    trigger OnAfterGetRecord()
    var
        GLSetup: Record "General Ledger Setup";
        DimSetEntRec: Record "Dimension Set Entry";
    begin
        GLSetup.Get();
        DimSetEntRec.Reset();
        DimSetEntRec.SetRange("Dimension set ID", rEC."Dimension Set ID");
        DimSetEntRec.SetRange("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
        if DimSetEntRec.FindFirst() then begin
            //DimSetEntRec.CalcFields("Dimension Value Code");
            Rec."Project Code" := DimSetEntRec."Dimension Value Code";

        End;
    eND;
}

pageextension 50413 "Ext Det Cust Ledg Entr" extends "Detailed Cust. Ledg. Entries"
{
    layout
    {
        addafter("Document No.")
        {
            field("Voucher No."; Rec."Voucher No.")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addfirst(processing)
        {

            action("Applied Entri")
            {
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    CLE.Reset();
                    cle.SetRange("Entry No.", Rec."Cust. Ledger Entry No.");
                    if CLE.Find('-') then
                        page.Run(61, CLE);
                end;

            }
        }
    }
    Var

        ExcelBuffer: Record "Excel Buffer";
        CLE: Record "Cust. Ledger Entry";
        DCLE: Record "Detailed Cust. Ledg. Entry";
        CreateCustLedgEntry: Record "Cust. Ledger Entry";
        DtldCustLedgEntry1: Record "Detailed Cust. Ledg. Entry";
        DtldCustLedgEntry2: Record "Detailed Cust. Ledg. Entry";

}