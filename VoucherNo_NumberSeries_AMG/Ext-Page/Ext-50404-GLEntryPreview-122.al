
pageextension 50404 "Ext G/L Entries Preview" extends "G/L Entries Preview"
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
        addafter(Description)
        {
            field("G/L Account Name76709"; Rec."G/L Account Name")
            {
                ApplicationArea = All;
            }
            field("System-Created Entry"; Rec."System-Created Entry")
            {
                ApplicationArea = All;
            }
        }
        modify(Description)
        {
            Visible = false;
        }

    }

}

pageextension 50411 "Ext G/L Entries" extends "General Ledger Entries"
{

    layout
    {
        addafter("External Document No.")
        {
            field("System-Created Entry"; Rec."System-Created Entry")
            {
                ApplicationArea = All;
            }
        }
        modify(Description)
        {
            Visible = false;
        }
        addafter("G/L Account No.")
        {
            field("G/L Account Name56808"; Rec."G/L Account Name")
            {
                ApplicationArea = All;
            }
        }
        addafter("Gen. Prod. Posting Group")
        {
            field("Additional-Currency Amount41042"; Rec."Additional-Currency Amount")
            {
                ApplicationArea = All;
            }
            field("Currency Code"; Rec."Currency Code")
            {
                ApplicationArea = All;
            }
            field("Currency Factor"; Rec."Currency Factor")
            {
                ApplicationArea = All;
                DecimalPlaces = 0 : 7;
            }
        }
        modify("Gen. Posting Type")
        {
            Width = 10;
            Visible = false;
        }
        modify("Gen. Bus. Posting Group")
        {
            Visible = false;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = false;
        }
        addafter("Document No.")
        {
            field("Voucher No."; Rec."Voucher No.")
            {
                ApplicationArea = All;
            }
            /*
            Field("Source No."; "Source No.")
            {
                ApplicationArea = all;
            }
            */
            Field("Source Code "; Rec."Source Code")
            {
                ApplicationArea = all;
            }
            field(Narration; Rec.Narration)
            {
                ApplicationArea = all;
            }
        }
        modify("Source Code")
        {
            Visible = false;
        }
        addafter("Additional-Currency Amount")
        {
            field("Additional Balance SAR"; Rec."Additional Balance SAR")
            {
                ApplicationArea = All;
                Visible = False;

            }
            field("Amount in SAR"; Rec."Amount in SAR")
            {
                ApplicationArea = All;
            }
            field("Currency Factor(SAR)"; Rec."Currency Factor(SAR)")
            {
                ApplicationArea = All;
            }
            //02.11.2020

            field("Vessel Name"; Rec."Vessel Name")
            {
                ApplicationArea = All;
            }
            field(Backcharge; Rec.Backcharge)
            {
                ApplicationArea = All;
            }
            field("Backcharge To"; Rec."Backcharge To")
            {
                ApplicationArea = All;
            }

            //02.11.2020
        }
    }

    actions
    {
        addafter("&Navigate")
        {
            Action("Payment Voucher")
            {
                ApplicationArea = All;
                Caption = 'Payment Voucher';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction();
                var
                    VouchRep: Report "Voucher_Report 1";
                    GLRec2: Record "G/L Entry";
                    GLRec: Record "G/L Entry";
                begin
                    /*Clear(VouchRep);
                    CurrPage.SetSelectionFilter(GLRec);
                    if GLRec.FindFirst() then;
                    */
                    GLRec2.Reset;
                    GLRec2.SetRange("Document No.", Rec."Document No.");
                    IF GLRec2.FindFirst() then;
                    VouchRep.SetTableView(GLRec2);
                    VouchRep.RunModal();
                end;
            }
            Action("Receipt Voucher")
            {
                ApplicationArea = All;
                Caption = 'Receipt Voucher';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction();
                var
                    // VouchRep: Report "Posted Reciept Voucher"
                    //VouchRep: Report "_Cash_Journal Voucher";50410
                    VouchRep: Report "Posted Cash Voucher_Repor";

                    GLRec2: Record "G/L Entry";
                    GLRec: Record "G/L Entry";
                begin
                    /*Clear(VouchRep);
                    CurrPage.SetSelectionFilter(GLRec);
                    if GLRec.FindFirst() then;
                    */
                    GLRec2.Reset;
                    GLRec2.SetRange("Document No.", Rec."Document No.");
                    IF GLRec2.FindFirst() then;
                    VouchRep.SetTableView(GLRec2);
                    VouchRep.RunModal();
                end;
            }
            Action("Journal Voucher")
            {
                ApplicationArea = All;
                Caption = 'Journal Voucher';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction();
                var
                    VouchRep: Report "Journal Voucher";
                    GLRec2: Record "G/L Entry";
                    GLRec: Record "G/L Entry";
                begin
                    /*Clear(VouchRep);
            
                    CurrPage.SetSelectionFilter(GLRec);
                    if GLRec.FindFirst() then;
                    */
                    GLRec2.Reset;
                    GLRec2.SetRange("Document No.", Rec."Document No.");
                    IF GLRec2.FindFirst() then;
                    VouchRep.SetTableView(GLRec2);
                    VouchRep.RunModal();
                end;
            }
        }
        //batch job
        addafter("Ent&ry")
        {
            action("Update Ledger Entries")
            {
                ApplicationArea = All;
                Image = UpdateDescription;

                trigger OnAction()
                begin
                    Report.Run(60000, true, false);
                end;
            }
            action("Update Currency Code")
            {
                ApplicationArea = All;
                Image = UpdateDescription;
                trigger OnAction()
                begin
                    Report.Run(60002, false, false);
                end;
            }
        }
    }
    trigger OnOpenPage()
    var
        GLEntryL: Record "G/L Entry";
        CurrencyExcRateL: Record "Currency Exchange Rate";
        Dimval: Record "dimension value";
    begin

        Dimval.Reset;
        DimVal.SetRange("Dimension Code", 'VESSELS');
        Dimval.SetRange(Code, Rec."Global Dimension 1 Code");
        if dimval.findfirst then
            Rec.Validate("Vessel Name", DimVal.Name);

    end;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
        GLEntryL: Record "G/L Entry";
        CurrencyExcRateL: Record "Currency Exchange Rate";
        Dimval: record "Dimension Value";
    begin
        CurrencyExcRateL.Reset;
        CurrencyExcRateL.SetCurrentKey("Currency Code", "Starting Date");
        CurrencyExcRateL.SetRange("Currency Code", 'AED');
        CurrencyExcRateL.SetRange("Relational Currency Code", 'SAR');
        CurrencyExcRateL.SetFILTER("Starting Date", '<=%1', Rec."Posting Date");
        if CurrencyExcRateL.FindLast() then begin

            Rec.VALIDATE("Amount in SAR", (Rec.Amount / CurrencyExcRateL."Relational Exch. Rate Amount"));
            Rec.VALIDATE("Currency Factor(SAR)", (CurrencyExcRateL."Relational Exch. Rate Amount"));
        end;

        Rec.ShowShortcutDimCode(Shortcutdimcode);

        Dimval.Reset;
        DimVal.SetRange("Dimension Code", 'VESSELS');
        Dimval.SetRange(Code, Rec."Global Dimension 1 Code");
        if dimval.findfirst then
            Rec.Validate("Vessel Name", DimVal.Name);
    end;

    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
        GLEntryL: Record "G/L Entry";
        CurrencyExcRateL: Record "Currency Exchange Rate";
    begin
        CurrencyExcRateL.Reset;
        CurrencyExcRateL.SetCurrentKey("Currency Code", "Starting Date");
        CurrencyExcRateL.SetRange("Currency Code", 'AED');
        CurrencyExcRateL.SetRange("Relational Currency Code", 'SAR');
        CurrencyExcRateL.SetFILTER("Starting Date", '<=%1', Rec."Posting Date");
        if CurrencyExcRateL.FindLast() then begin
            Rec.VALIDATE("Amount in SAR", (Rec.Amount / CurrencyExcRateL."Relational Exch. Rate Amount"));
            Rec.VALIDATE("Currency Factor(SAR)", (CurrencyExcRateL."Relational Exch. Rate Amount"));
        end;
        Rec.ShowShortcutDimCode(Shortcutdimcode);

    end;

    var
        ConverstionAmtG: Decimal;
        Shortcutdimcode: Array[8] of code[20];


}