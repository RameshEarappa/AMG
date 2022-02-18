report 50116 "Purchase - Invoice_New"
{
    DefaultLayout = RDLC;
    RDLCLayout = './PurchaseInvoice.rdlc';
    Caption = 'Purchase - Invoice';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Purch. Inv. Header"; "Purch. Inv. Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Buy-from Vendor No.", "No. Printed";
            RequestFilterHeading = 'Posted Purchase Invoice';
            column(No_PurchInvHeader; "No.") { }
            column(InvDiscAmtCaption; InvDiscAmtCaptionLbl) { }
            column(AllowInvDiscCaption; AllowInvDiscCaptionLbl) { }
            column(Vessalname; Vessalname) { }
            column(Currency_Code; CurrCode) { }
            column(CommentTex; CommentTex) { }
            column(Vendor_Invoice_No_; VenInvNo) { }
            column(Order_No_; OrdNo) { }
            column(AppName; AppName) { }
            column(AppDate; AppDate) { }
            column(Backcharged_To; "Backcharged To") { }
            column(Purposes; Purposes) { }
            dataitem(CopyLoop; Integer)

            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; Integer)
                {
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number = CONST(1));
                    column(PaymentTermsDesc; PaymentTerms.Description) { }
                    column(ShipmentMethodDesc; ShipmentMethod.Description) { }
                    column(DocCaptionCopyText; STRSUBSTNO(DocumentCaption, CopyText)) { }
                    column(VendAddr1; VendAddr[1]) { }
                    column(CompanyAddr1; CompanyAddr[1]) { }
                    column(VendAddr2; VendAddr[2]) { }
                    column(CompanyAddr2; CompanyAddr[2]) { }
                    column(VendAddr3; VendAddr[3]) { }
                    column(CompanyAddr3; CompanyAddr[3]) { }
                    column(VendAddr4; VendAddr[4]) { }
                    column(CompanyAddr4; CompanyAddr[4]) { }
                    column(VendAddr5; VendAddr[5]) { }
                    column(CompanyInfoPhoneNo; CompanyInfo."Phone No.") { }
                    column(VendAddr6; VendAddr[6]) { }
                    column(CompanyInfoHomePage; CompanyInfo."Home Page") { }
                    column(CompanyInfoEMail; CompanyInfo."E-Mail") { }
                    column(CompanyInfoVATRegNo; CompanyInfo."VAT Registration No.") { }
                    column(CompanyInfoGiroNo; CompanyInfo."Giro No.") { }
                    column(CompanyInfoBankName; CompanyInfo."Bank Name") { }
                    column(CompLogo; CompanyInfo.Picture) { }
                    column(CompanyInfoBankAccountNo; CompanyInfo."Bank Account No.") { }
                    column(PayToVendNo_PurchInvHeader; "Purch. Inv. Header"."Pay-to Vendor No.") { }
                    column(DocDate_PurchInvHeader; FORMAT("Purch. Inv. Header"."Document Date")) { }
                    column(VATNoText; VATNoText) { }
                    column(VATRegNo_PurchInvHeader; "Purch. Inv. Header"."VAT Registration No.") { }
                    column(DueDate_PurchInvHeader; FORMAT("Purch. Inv. Header"."Due Date")) { }
                    column(PurchaserText; PurchaserText) { }
                    column(SalesPurchPersonName; SalesPurchPerson.Name) { }
                    column(RefText; ReferenceText) { }
                    column(YourRef_PurchInvHeader; "Purch. Inv. Header"."Your Reference") { }
                    column(OrderNoText; OrderNoText) { }
                    column(OrderNo_PurchInvHeader; "Purch. Inv. Header"."Order No.") { }
                    column(VendAddr7; VendAddr[7]) { }
                    column(VendAddr8; VendAddr[8]) { }
                    column(CompanyAddr5; CompanyAddr[5]) { }
                    //column(Vendor_Invoice_No_; "Purch. Inv. Header"."Vendor Invoice No.") { }
                    column(CompanyAddr6; CompanyAddr[6]) { }
                    column(PostingDate_PurchInvHeader; FORMAT("Purch. Inv. Header"."Posting Date")) { }
                    column(PricesIncVAT_PurchInvHeader; "Purch. Inv. Header"."Prices Including VAT") { }
                    column(OutputNo; OutputNo) { }
                    column(ShowInternalInfo; ShowInternalInfo) { }
                    column(VATBaseDisc_PurchInvHeader; "Purch. Inv. Header"."VAT Base Discount %") { }
                    column(PricesInclVATtxt; PricesInclVATtxt) { }
                    column(BuyFromVendNo_PurchInvHeader; "Purch. Inv. Header"."Buy-from Vendor No.") { }
                    column(PhoneNoCaption; PhoneNoCaptionLbl) { }
                    column(HomePageCaption; HomePageCaptionLbl) { }
                    column(EMailCaption; EMailCaptionLbl) { }
                    column(VATRegNoCaption; VATRegNoCaptionLbl) { }
                    column(GiroNoCaption; GiroNoCaptionLbl) { }
                    column(BankNameCaption; BankNameCaptionLbl) { }
                    column(BankAccNoCaption; BankAccNoCaptionLbl) { }
                    column(DueDateCaption; DueDateCaptionLbl) { }
                    column(InvoiceNoCaption; InvoiceNoCaptionLbl) { }
                    column(PostingDateCaption; PostingDateCaptionLbl) { }
                    column(PageCaption; PageCaptionLbl) { }
                    column(PaymentTermsCaption; PaymentTermsCaptionLbl) { }
                    column(ShipmentMethodCaption; ShipmentMethodCaptionLbl) { }
                    column(DocDateCaption; DocDateCaptionLbl) { }
                    column(PayToVendNo_PurchInvHeaderCaption; "Purch. Inv. Header".FIELDCAPTION("Pay-to Vendor No.")) { }
                    column(PricesIncVAT_PurchInvHeaderCaption; "Purch. Inv. Header".FIELDCAPTION("Prices Including VAT")) { }
                    column(BuyFromVendNo_PurchInvHeaderCaption; "Purch. Inv. Header".FIELDCAPTION("Buy-from Vendor No.")) { }
                    column(VATPercentageCaption; VATPercentageCaptionLbl) { }
                    column(VATBaseCaption; VATBaseCaptionLbl) { }
                    column(VATAmtCaption; VATAmtCaptionLbl) { }
                    column(VATAmtSpecificationCaption; VATAmtSpecificationCaptionLbl) { }
                    column(InvDiscBaseAmtCaption; InvDiscBaseAmtCaptionLbl) { }
                    column(LineAmtCaption; LineAmtCaptionLbl) { }
                    column(VATIdentifierCaption; VATIdentifierCaptionLbl) { }
                    column(TotalCaption; TotalCaptionLbl) { }
                    dataitem(DimensionLoop1; Integer)
                    {
                        DataItemLinkReference = "Purch. Inv. Header";
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = FILTER(1 ..));
                        column(DimText_DimensionLoop1; DimText)
                        {
                        }
                        column(HeaderDimensionsCaption; HeaderDimensionsCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            IF Number = 1 THEN BEGIN
                                IF NOT DimSetEntry1.FINDSET THEN
                                    CurrReport.BREAK;
                            END ELSE
                                IF NOT Continue THEN
                                    CurrReport.BREAK;

                            CLEAR(DimText);
                            Continue := FALSE;
                            REPEAT
                                OldDimText := DimText;
                                IF DimText = '' THEN
                                    DimText := STRSUBSTNO('%1 %2', DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                ELSE
                                    DimText :=
                                      STRSUBSTNO(
                                        '%1, %2 %3', DimText,
                                        DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code");
                                IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                    DimText := OldDimText;
                                    Continue := TRUE;
                                    EXIT;
                                END;
                            UNTIL DimSetEntry1.NEXT = 0;




                        end;

                        trigger OnPreDataItem()
                        begin
                            IF NOT ShowInternalInfo THEN
                                CurrReport.BREAK;
                        end;
                    }
                    dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
                    {
                        DataItemLink = "Document No." = FIELD("No.");
                        DataItemLinkReference = "Purch. Inv. Header";
                        DataItemTableView = SORTING("Document No.", "Line No.");
                        column(LineAmt_PurchInvLine; "Line Amount")
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(Desc_PurchInvLine; Description) { }
                        column(GL_Code; "No.") { }
                        column(No_PurchInvLine; "No.") { }
                        column(Qty_PurchInvLine; Quantity) { }
                        column(UOM_PurchInvLine; "Unit of Measure") { }
                        column(DirectUnitCost_PurchInvLine; "Direct Unit Cost")
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 2;
                        }
                        column(LineDisc_PurchInvLine; "Line Discount %") { }
                        column(AllowInvDisc_PurchInvLine; "Allow Invoice Disc.")
                        {
                            IncludeCaption = false;
                        }
                        column(VATIdentifier_PurchInvLine; "VAT Identifier") { }
                        column(LineNo_PurchInvLine; "Line No.")
                        {
                        }
                        column(AllowVATDisctxt; AllowVATDisctxt)
                        {
                        }
                        column(PurchInLineTypeNo; PurchInLineTypeNo)
                        {
                        }
                        column(VATAmtText; VATAmountText)
                        {
                        }
                        column(NegInvDiscAmt_PurchInvLine; -"Inv. Discount Amount")
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(TotalText; TotalText)
                        {
                        }
                        column(PurchInvLineAmt; Amount)
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(TotalInclVATText; TotalInclVATText)
                        {
                        }
                        column(AmtIncVAT_PurchInvLine; "Amount Including VAT")
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(AmtIncVATAmt_PurchInvLine; "Amount Including VAT" - Amount)
                        {
                            AutoFormatExpression = GetCurrencyCode;
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmtText; VATAmountLine.VATAmountText)
                        {
                        }
                        column(TotalExclVATText; TotalExclVATText)
                        {
                        }
                        column(NegLineAmtInvDiscAmtAmtIncVAT_PurchInvLine; -("Line Amount" - "Inv. Discount Amount" - "Amount Including VAT"))
                        {
                            AutoFormatExpression = "Purch. Inv. Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalSubTotal; TotalSubTotal)
                        {
                            AutoFormatExpression = "Purch. Inv. Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalInvDiscAmt; TotalInvoiceDiscountAmount)
                        {
                            AutoFormatExpression = "Purch. Inv. Header"."Currency Code";
                            AutoFormatType = 1;
                        }

                        column(TotalAmt; TotalAmount)
                        {
                            AutoFormatExpression = "Purch. Inv. Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmtInclVAT; TotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Purch. Inv. Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(AmtWord; AmtWord) { }
                        column(TotalAmtVAT; TotalAmountVAT)
                        {
                            AutoFormatExpression = "Purch. Inv. Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalPaymentDiscOnVAT; TotalPaymentDiscountOnVAT)
                        {
                            AutoFormatType = 1;
                        }
                        column(DirectUnitCostCaption; DirectUnitCostCaptionLbl)
                        {
                        }
                        column(DiscountPctCaption; DiscountPctCaptionLbl)
                        {
                        }
                        column(AmountCaption; AmountCaptionLbl)
                        {
                        }
                        column(SubtotalCaption; SubtotalCaptionLbl)
                        {
                        }
                        column(PymtDiscOnVATCaption; PymtDiscOnVATCaptionLbl)
                        {
                        }
                        column(Desc_PurchInvLineCaption; FIELDCAPTION(Description))
                        {
                        }
                        column(No_PurchInvLineCaption; FIELDCAPTION("No."))
                        {
                        }
                        column(Qty_PurchInvLineCaption; FIELDCAPTION(Quantity))
                        {
                        }
                        column(UOM_PurchInvLineCaption; FIELDCAPTION("Unit of Measure"))
                        {
                        }
                        column(VATIdentifier_PurchInvLineCaption; FIELDCAPTION("VAT Identifier"))
                        {
                        }
                        dataitem(DimensionLoop2; Integer)
                        {
                            DataItemTableView = SORTING(Number)
                                                WHERE(Number = FILTER(1 ..));
                            column(DimText_DimensionLoop2; DimText)
                            {
                            }
                            column(LineDimensionsCaption; LineDimensionsCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                IF Number = 1 THEN BEGIN
                                    IF NOT DimSetEntry2.FINDSET THEN
                                        CurrReport.BREAK;
                                END ELSE
                                    IF NOT Continue THEN
                                        CurrReport.BREAK;

                                CLEAR(DimText);
                                Continue := FALSE;
                                REPEAT
                                    OldDimText := DimText;
                                    IF DimText = '' THEN
                                        DimText := STRSUBSTNO('%1 %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    ELSE
                                        DimText :=
                                          STRSUBSTNO(
                                            '%1, %2 %3', DimText,
                                            DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
                                    IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                        DimText := OldDimText;
                                        Continue := TRUE;
                                        EXIT;
                                    END;
                                UNTIL DimSetEntry2.NEXT = 0;
                            end;

                            trigger OnPreDataItem()
                            begin
                                IF NOT ShowInternalInfo THEN
                                    CurrReport.BREAK;

                                DimSetEntry2.SETRANGE("Dimension Set ID", "Purch. Inv. Line"."Dimension Set ID");
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            IF (Type = Type::"G/L Account") AND (NOT ShowInternalInfo) THEN
                                "No." := '';

                            VATAmountLine.INIT;
                            VATAmountLine."VAT Identifier" := "VAT Identifier";
                            VATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
                            VATAmountLine."Tax Group Code" := "Tax Group Code";
                            VATAmountLine."Use Tax" := "Use Tax";
                            VATAmountLine."VAT %" := "VAT %";
                            VATAmountLine."VAT Base" := Amount;
                            VATAmountLine."Amount Including VAT" := "Amount Including VAT";
                            VATAmountLine."Line Amount" := "Line Amount";
                            IF "Allow Invoice Disc." THEN
                                VATAmountLine."Inv. Disc. Base Amount" := "Line Amount";
                            VATAmountLine."Invoice Discount Amount" := "Inv. Discount Amount";
                            VATAmountLine.InsertLine;

                            AllowVATDisctxt := FORMAT("Allow Invoice Disc.");
                            PurchInLineTypeNo := Type;

                            TotalSubTotal += "Line Amount";
                            TotalInvoiceDiscountAmount -= "Inv. Discount Amount";
                            TotalAmount += Amount;
                            TotalAmountVAT += "Amount Including VAT" - Amount;
                            TotalAmountInclVAT += "Amount Including VAT";
                            TotalPaymentDiscountOnVAT += -("Line Amount" - "Inv. Discount Amount" - "Amount Including VAT");

                            Clear(TotAmt);
                            LineRec.Reset();
                            LineRec.SetRange("Document No.", "Document No.");
                            if LineRec.FindSet() then begin
                                repeat
                                    TotAmt += LineRec."Amount Including VAT";
                                until LineRec.Next() = 0;
                            end;

                            CheckRep.FormatNoText(NoText, ABS(TotAmt), CurrCode);
                            //AmtWord2 := CurrCode + ' ' + NoText[1];
                            //if AmtWord2 <> '' then
                            //   AmtWord := AmtWord2;
                            AmtWord := NoText[1];

                        end;

                        trigger OnPreDataItem()
                        var
                            PurchInvLine: Record "Purch. Inv. Line";
                            VATIdentifier: Code[20];
                        begin
                            VATAmountLine.DELETEALL;
                            MoreLines := FIND('+');
                            WHILE MoreLines AND (Description = '') AND ("No." = '') AND (Quantity = 0) AND (Amount = 0) DO
                                MoreLines := NEXT(-1) <> 0;
                            IF NOT MoreLines THEN
                                CurrReport.BREAK;
                            SETRANGE("Line No.", 0, "Line No.");

                            PurchInvLine.SETRANGE("Document No.", "Purch. Inv. Header"."No.");
                            PurchInvLine.SETFILTER(Type, '<>%1', 0);
                            VATAmountText := '';
                            IF PurchInvLine.FIND('-') THEN BEGIN
                                VATAmountText := STRSUBSTNO(Text011, PurchInvLine."VAT %");
                                VATIdentifier := PurchInvLine."VAT Identifier";
                                REPEAT
                                    IF (PurchInvLine."VAT Identifier" <> VATIdentifier) AND (PurchInvLine.Quantity <> 0) THEN
                                        VATAmountText := Text012;
                                UNTIL PurchInvLine.NEXT = 0;
                            END;
                        end;
                    }
                    dataitem(VATCounter; Integer)
                    {
                        DataItemTableView = SORTING(Number);
                        column(VATAmtLineVATBase; VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Purch. Inv. Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmt; VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Purch. Inv. Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineLineAmt; VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Purch. Inv. Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscBaseAmt; VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Purch. Inv. Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscAmt; VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Purch. Inv. Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVAT_VATCounter; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATAmtLineVATIdentifier_VATCounter; VATAmountLine."VAT Identifier")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                        end;

                        trigger OnPreDataItem()
                        begin
                            SETRANGE(Number, 1, VATAmountLine.COUNT);
                        end;
                    }
                    dataitem(VATCounterLCY; Integer)
                    {
                        DataItemTableView = SORTING(Number);
                        column(VALExchRate; VALExchRate)
                        {
                        }
                        column(VALSpecLCYHeader; VALSpecLCYHeader)
                        {
                        }
                        column(VALVATAmtLCY; VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATBaseLCY; VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVAT_VATCounterLCY; VATAmountLine."VAT %")
                        {
                            //DecimalPlaces = 0 : 5;
                        }
                        column(VATAmtLineVATIdentifier_VATCounterLCY; VATAmountLine."VAT Identifier")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);
                            VALVATBaseLCY :=
                              VATAmountLine.GetBaseLCY(
                                "Purch. Inv. Header"."Posting Date", "Purch. Inv. Header"."Currency Code",
                                "Purch. Inv. Header"."Currency Factor");
                            VALVATAmountLCY :=
                              VATAmountLine.GetAmountLCY(
                                "Purch. Inv. Header"."Posting Date", "Purch. Inv. Header"."Currency Code",
                                "Purch. Inv. Header"."Currency Factor");
                        end;

                        trigger OnPreDataItem()
                        begin
                            IF (NOT GLSetup."Print VAT specification in LCY") OR
                               ("Purch. Inv. Header"."Currency Code" = '')
                            THEN
                                CurrReport.BREAK;

                            SETRANGE(Number, 1, VATAmountLine.COUNT);
                            CLEAR(VALVATBaseLCY);
                            CLEAR(VALVATAmountLCY);

                            IF GLSetup."LCY Code" = '' THEN
                                VALSpecLCYHeader := Text007 + Text008
                            ELSE
                                VALSpecLCYHeader := Text007 + FORMAT(GLSetup."LCY Code");

                            CurrExchRate.FindCurrency("Purch. Inv. Header"."Posting Date", "Purch. Inv. Header"."Currency Code", 1);
                            CalculatedExchRate := ROUND(1 / "Purch. Inv. Header"."Currency Factor" * CurrExchRate."Exchange Rate Amount", 0.000001);
                            VALExchRate := STRSUBSTNO(Text009, CalculatedExchRate, CurrExchRate."Exchange Rate Amount");
                        end;
                    }
                    dataitem(Total; Integer)
                    {
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = CONST(1));
                    }
                    dataitem(Total2; Integer)
                    {
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = CONST(1));

                        trigger OnPreDataItem()
                        begin
                            IF "Purch. Inv. Header"."Buy-from Vendor No." = "Purch. Inv. Header"."Pay-to Vendor No." THEN
                                CurrReport.BREAK;
                        end;
                    }
                    dataitem(Total3; Integer)
                    {
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = CONST(1));
                        column(ShipToAddr1; ShipToAddr[1])
                        {
                        }
                        column(ShipToAddr2; ShipToAddr[2])
                        {
                        }
                        column(ShipToAddr3; ShipToAddr[3])
                        {
                        }
                        column(ShipToAddr4; ShipToAddr[4])
                        {
                        }
                        column(ShipToAddr5; ShipToAddr[5])
                        {
                        }
                        column(ShipToAddr6; ShipToAddr[6])
                        {
                        }
                        column(ShipToAddr7; ShipToAddr[7])
                        {
                        }
                        column(ShipToAddr8; ShipToAddr[8])
                        {
                        }
                        column(ShipToAddressCaption; ShipToAddressCaptionLbl)
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            IF ShipToAddr[1] = '' THEN
                                CurrReport.BREAK;
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    IF Number > 1 THEN BEGIN
                        OutputNo := OutputNo + 1;
                        CopyText := FormatDocument.GetCOPYText;
                    END;
                    //CurrReport.PAGENO := 1;

                    TotalSubTotal := 0;
                    TotalInvoiceDiscountAmount := 0;
                    TotalAmount := 0;
                    TotalAmountVAT := 0;
                    TotalAmountInclVAT := 0;
                    TotalPaymentDiscountOnVAT := 0;
                end;

                trigger OnPostDataItem()
                begin
                    IF NOT IsReportInPreviewMode THEN
                        CODEUNIT.RUN(CODEUNIT::"Purch. Inv.-Printed", "Purch. Inv. Header");
                end;

                trigger OnPreDataItem()
                begin
                    OutputNo := 1;
                    NoOfLoops := ABS(NoOfCopies) + 1;
                    CopyText := '';
                    SETRANGE(Number, 1, NoOfLoops);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                // CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

                FormatAddressFields("Purch. Inv. Header");
                FormatDocumentFields("Purch. Inv. Header");
                PricesInclVATtxt := FORMAT("Prices Including VAT");

                DimSetEntry1.SETRANGE("Dimension Set ID", "Dimension Set ID");

                //
                DimRec.Reset();
                DimRec.SetRange(Code, "Shortcut Dimension 1 Code");
                IF DimRec.FindFirst() then
                    Vessalname := DimRec.Name;

                if "Currency Code" = '' then begin
                    GLSetup.Get();
                    //GLSetup.CalcFields("LCY Code");
                    CurrCode := GLSetup."LCY Code";
                end Else
                    CurrCode := "Currency Code";

                if "Purch. Inv. Header"."Order No." <> '' then
                    OrdNo := "Purch. Inv. Header"."Order No."
                else
                    OrdNo := "Purch. Inv. Header"."Pre-Assigned No.";

                VenInvNo := "Purch. Inv. Header"."Vendor Invoice No.";
                //

                AppEntRec.Reset();
                AppEntRec.SetRange("Document No.", "Purch. Inv. Header"."No.");
                if AppEntRec.FindLast() then begin
                    AppName := AppEntRec."Approver ID";
                    AppDate := FORMAT(AppEntRec."Last Date-Time Modified", 8, '<Day,2>/<Month,2>/<year,2>');
                End;
                CommRec.Reset();
                CommRec.SetRange("No.", "No.");
                If CommRec.FindSet() then begin
                    repeat
                        CommentTex += CommRec.Comment + '. ';
                    until CommRec.Next() = 0;
                end;

            end;

            trigger OnPostDataItem()
            begin
                OnAfterPostDataItem("Purch. Inv. Header");
            end;

        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NoOfCopies; NoOfCopies)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'No. of Copies';
                        ToolTip = 'Specifies how many copies of the document to print.';
                    }
                    field(ShowInternalInfo; ShowInternalInfo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Internal Information';
                        ToolTip = 'Specifies if you want the printed report to show information that is only for internal use.';
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies that interactions with the contact are logged.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            LogInteractionEnable := TRUE;
        end;

        trigger OnOpenPage()
        begin
            InitLogInteraction;
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        GLSetup.GET;
        CompanyInfo.GET;
        CompanyInfo.CalcFields(Picture);
        CheckRep.InitTextVariable;
        OnAfterInitReport;
    end;

    trigger OnPostReport()
    begin
        IF LogInteraction AND NOT IsReportInPreviewMode THEN
            IF "Purch. Inv. Header".FINDSET THEN
                REPEAT
                    SegManagement.LogDocument(14, "Purch. Inv. Header"."No.", 0, 0, DATABASE::Vendor, "Purch. Inv. Header"."Buy-from Vendor No.",
                      "Purch. Inv. Header"."Purchaser Code", '', "Purch. Inv. Header"."Posting Description", '');
                UNTIL "Purch. Inv. Header".NEXT = 0;
    end;

    trigger OnPreReport()
    begin
        IF NOT CurrReport.USEREQUESTPAGE THEN
            InitLogInteraction;
    end;

    var
        Text004: Label 'Purchase - Invoice %1', Comment = '%1 = Document No.';
        GLSetup: Record "General Ledger Setup";
        CompanyInfo: Record "Company Information";
        AppEntRec: Record "Posted Approval Entry";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        VATAmountLine: Record "VAT Amount Line" temporary;
        AmtWord: Text;
        AmtWord2: Text;
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        RespCenter: Record "Responsibility Center";
        Language: Record Language;
        CurrExchRate: Record "Currency Exchange Rate";
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        SegManagement: Codeunit "SegManagement";
        VendAddr: array[8] of Text[100];
        ShipToAddr: array[8] of Text[100];
        CompanyAddr: array[8] of Text[100];
        CheckRep: Codeunit "Amount In Word LT";
        PurchaserText: Text[30];
        VATNoText: Text[80];
        ReferenceText: Text[80];
        AppName: Text;
        AppDate: Text;
        OrderNoText: Text[80];
        TotalText: Text[50];
        NoText: array[1] of Text;
        TotalInclVATText: Text[50];
        TotalExclVATText: Text[50];
        DimRec: Record "Dimension Value";
        Vessalname: Text;
        OrdNo: text;
        VenInvNo: Text;
        CurrCode: Code[10];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        LogInteraction: Boolean;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        CommentTex: text;
        VALExchRate: Text[50];
        Text007: Label 'VAT Amount Specification in ';
        Text008: Label 'Local Currency';
        Text009: Label 'Exchange rate: %1/%2';
        CalculatedExchRate: Decimal;
        Text010: Label 'Purchase - Prepayment Invoice %1', Comment = '%1 = Document No.';
        OutputNo: Integer;
        PricesInclVATtxt: Text[30];
        AllowVATDisctxt: Text[30];
        VATAmountText: Text[30];
        Text011: Label '%1% VAT';
        Text012: Label 'VAT Amount';
        CommRec: Record "Purch. Comment Line";
        PurchInLineTypeNo: Integer;
        [InDataSet]

        LogInteractionEnable: Boolean;
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalAmountVAT: Decimal;
        TotalInvoiceDiscountAmount: Decimal;
        TotalPaymentDiscountOnVAT: Decimal;
        PhoneNoCaptionLbl: Label 'Phone No.';
        HomePageCaptionLbl: Label 'Home Page';
        EMailCaptionLbl: Label 'Email';
        VATRegNoCaptionLbl: Label 'VAT Registration No.';
        GiroNoCaptionLbl: Label 'Giro No.';
        BankNameCaptionLbl: Label 'Bank';
        BankAccNoCaptionLbl: Label 'Account No.';
        DueDateCaptionLbl: Label 'Due Date';
        InvoiceNoCaptionLbl: Label 'Purchase Invoice No.';
        PostingDateCaptionLbl: Label 'Posting Date';
        PageCaptionLbl: Label 'Page';
        TotalAmoutIncVat: Decimal;
        PaymentTermsCaptionLbl: Label 'Payment Terms';
        ShipmentMethodCaptionLbl: Label 'Shipment Method';
        DocDateCaptionLbl: Label 'Document Date';
        HeaderDimensionsCaptionLbl: Label 'Header Dimensions';
        DirectUnitCostCaptionLbl: Label 'Direct Unit Cost';
        DiscountPctCaptionLbl: Label 'Discount %';
        AmountCaptionLbl: Label 'Amount';
        SubtotalCaptionLbl: Label 'Subtotal';
        PymtDiscOnVATCaptionLbl: Label 'Payment Discount on VAT';
        LineDimensionsCaptionLbl: Label 'Line Dimensions';
        VATPercentageCaptionLbl: Label 'VAT %';
        VATBaseCaptionLbl: Label 'VAT Base';
        VATAmtCaptionLbl: Label 'VAT Amount';
        VATAmtSpecificationCaptionLbl: Label 'VAT Amount Specification';
        InvDiscBaseAmtCaptionLbl: Label 'Inv. Disc. Base Amount';
        LineAmtCaptionLbl: Label 'Line Amount';
        VATIdentifierCaptionLbl: Label 'VAT Identifier';
        TotalCaptionLbl: Label 'Total';
        ShipToAddressCaptionLbl: Label 'Ship-to Address';
        InvDiscAmtCaptionLbl: Label 'Invoice Discount Amount';
        AllowInvDiscCaptionLbl: Label 'Allow Invoice Discount';
        LineRec: Record "Purch. Inv. Line";
        TotAmt: Decimal;

    local procedure DocumentCaption(): Text[250]
    begin
        IF "Purch. Inv. Header"."Prepayment Invoice" THEN
            EXIT(Text010);
        EXIT(Text004);
    end;

    local procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractTmplCode(14) <> '';
    end;

    procedure InitializeRequest(NewNoOfCopies: Integer; NewShowInternalInfo: Boolean; NewLogInteraction: Boolean)
    begin
        NoOfCopies := NewNoOfCopies;
        ShowInternalInfo := NewShowInternalInfo;
        LogInteraction := NewLogInteraction;
    end;

    local procedure IsReportInPreviewMode(): Boolean
    var
        MailManagement: Codeunit "Mail Management";
    begin
        EXIT(CurrReport.PREVIEW OR MailManagement.IsHandlingGetEmailBody);
    end;

    local procedure FormatAddressFields(var PurchInvHeader: Record "Purch. Inv. Header")
    begin
        FormatAddr.GetCompanyAddr(PurchInvHeader."Responsibility Center", RespCenter, CompanyInfo, CompanyAddr);
        FormatAddr.PurchInvPayTo(VendAddr, PurchInvHeader);
        FormatAddr.PurchInvShipTo(ShipToAddr, PurchInvHeader);
    end;

    local procedure FormatDocumentFields(PurchInvHeader: Record "Purch. Inv. Header")
    begin
        FormatDocument.SetTotalLabels(PurchInvHeader."Currency Code", TotalText, TotalInclVATText, TotalExclVATText);
        FormatDocument.SetPurchaser(SalesPurchPerson, PurchInvHeader."Purchaser Code", PurchaserText);
        FormatDocument.SetPaymentTerms(PaymentTerms, PurchInvHeader."Payment Terms Code", PurchInvHeader."Language Code");
        FormatDocument.SetShipmentMethod(ShipmentMethod, PurchInvHeader."Shipment Method Code", PurchInvHeader."Language Code");

        OrderNoText := FormatDocument.SetText(PurchInvHeader."Order No." <> '', PurchInvHeader.FIELDCAPTION("Order No."));
        ReferenceText := FormatDocument.SetText(PurchInvHeader."Your Reference" <> '', PurchInvHeader.FIELDCAPTION("Your Reference"));
        VATNoText := FormatDocument.SetText(PurchInvHeader."VAT Registration No." <> '', PurchInvHeader.FIELDCAPTION("VAT Registration No."));
    end;

    //[IntegrationEvent(TRUE, TRUE)]
    local procedure OnAfterInitReport()
    begin
    end;

    //[IntegrationEvent(TRUE, TRUE)]
    local procedure OnAfterPostDataItem(var PurchInvHeader: Record "Purch. Inv. Header")
    begin
    end;
}

