tableextension 50111 "Ex_Table Purchase Header" extends "Purchase Header"
{
    fields
    {
        modify("No.")
        {

            trigger OnAfterValidate()
            begin
                "Record Created By" := UserId;
            End;

        }
        modify("Buy-from Vendor No.")
        {

            trigger OnAfterValidate()
            Var
                Vendor: Record vendor;
            begin
                vendor.reset;
                if vendor.GET("Buy-from Vendor No.") then;

                Vendor.CheckBlockedVendOnDocs(Vendor, false);
            End;

        }

        field(50000; "Received by"; Text[30]) { }
        field(50001; "Redyness Date"; Date) { }
        field(50002; "Validity Date"; Date) { }
        //</LT_02Jan20>
        field(50003; "Packing Instruction"; Text[100]) { }
        field(50004; "Port of Call/Delivery Address"; Text[100]) { }
        field(50005; "Warranty, if any"; Boolean) { }
        field(50006; "Certificate(s), if required"; Boolean) { }
        field(50007; "Coordinator No."; Code[20])
        {
            Caption = 'Coordinator No';
            DataClassification = CustomerContent;
            TableRelation = Coordinator;
            trigger OnValidate()
            var
                Coordinator: Record Coordinator;
            begin
                IF Coordinator.Get("Coordinator No.") THEN
                    "Coordinator Name" := Coordinator."Coordinator Name"
                ELSE
                    "Coordinator Name" := '';
            end;
        }
        field(50008; "Coordinator Name"; Text[50])
        {
            Caption = 'Coordinator Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50009; Purpose; Option)
        {
            OptionMembers = ,"Dry Docking 5Y","Dry Docking Int 3Y","O/H Major","O/H T","Opex","Mobilisation",Capex,;
            trigger OnValidate()
            var
                PurchaseLineRec: Record "Purchase Line";
                Item: Record Item;
            Begin
                PurchaseLineRec.RESET;
                PurchaseLineRec.SETRANGE("Document No.", Rec."No.");
                PurchaseLineRec.SETRANGE("Document Type", Rec."Document Type");
                PurchaseLineRec.SETRANGE(Type, PurchaseLineRec.Type::Item);
                IF PurchaseLineRec.FINDSET THEN
                    REPEAT
                        if Status <> Status::Released then
                            PurchaseLineRec."System-Created Entry" := true;
                        IF Purpose = Purpose::"Dry Docking 5Y" THEN BEGIN
                            PurchaseLineRec.VALIDATE("Gen. Prod. Posting Group", 'DRY DOCKING 5Y');
                            PurchaseLineRec.MODIFY;
                        END ELSE
                            IF Purpose = Purpose::"Dry Docking Int 3Y" THEN BEGIN
                                PurchaseLineRec.VALIDATE("Gen. Prod. Posting Group", 'DRY DOCKING INT 3Y');
                                PurchaseLineRec.MODIFY;
                            END ELSE
                                IF Purpose = Purpose::Capex THEN BEGIN
                                    PurchaseLineRec.VALIDATE("Gen. Prod. Posting Group", 'CAPEX');
                                    PurchaseLineRec.MODIFY;
                                END ELSE
                                    IF Purpose = Purpose::Mobilisation THEN BEGIN
                                        PurchaseLineRec.VALIDATE("Gen. Prod. Posting Group", 'MOBILISATION');
                                        PurchaseLineRec.MODIFY;
                                    END ELSE
                                        IF Purpose = Purpose::"O/H Major" THEN BEGIN
                                            PurchaseLineRec.VALIDATE("Gen. Prod. Posting Group", 'O/H MAJOR');
                                            PurchaseLineRec.MODIFY;
                                        END ELSE
                                            IF Purpose = Purpose::"O/H T" THEN BEGIN
                                                PurchaseLineRec.VALIDATE("Gen. Prod. Posting Group", 'O/H T');
                                                PurchaseLineRec.MODIFY;
                                            END ELSE
                                                IF Purpose = Purpose::Opex THEN BEGIN
                                                    Item.RESET;
                                                    IF Item.GET(PurchaseLineRec."No.") THEN BEGIN
                                                        PurchaseLineRec.VALIDATE("Gen. Prod. Posting Group", Item."Gen. Prod. Posting Group");
                                                        PurchaseLineRec.MODIFY;
                                                    END;
                                                END;

                    UNTIL PurchaseLineRec.NEXT = 0;

            End;
        }
        //</Lt_02Jan20>
        // Purchase Requisition. //
        field(50151; AMG_InitSourceNo; Code[20])
        {
            Caption = 'Purchase Requisition No.';
            DataClassification = CustomerContent;
            Editable = false;
        }

        // Option to Short Close and cancelation of Purchase order. 
        //In case of Vendor refuse to deliver the goods partially or completely.
        field(50152; AMG_ShortClosed; Boolean)
        {
            Caption = 'Short Closed';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50153; AMG_Cancelled; Boolean)
        {
            Caption = 'Cancelled';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50154; AMG_ShortClosedOrCancelled; Boolean)
        {
            Caption = 'Short Closed Or Cancelled Order';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50155; "Backcharge"; Option)
        {
            OptionMembers = " ",Yes,No;
            // Start 22.01.2020
            trigger
            OnValidate()
            var
                AMG_PurchLineG: Record "Purchase Line";

            begin
                if ("Document Type" = "Document Type"::Quote) OR ("Document Type" = "Document Type"::Order) then begin
                    if Backcharge = Backcharge::Yes then begin
                        AMG_PurchLineG.Reset();
                        AMG_PurchLineG.SetRange("Document No.", "No.");
                        AMG_PurchLineG.SetFilter(Type, '%1|%2|%3', AMG_PurchLineG.Type::"Fixed Asset", AMG_PurchLineG.Type::"Charge (Item)", AMG_PurchLineG.Type::Item);
                        if AMG_PurchLineG.FindFirst() then
                            Error('Back Charge only Applicable for GL Account.');
                    end;
                end;
            end;
            // Stop 22.01.2020
        }
        field(50156; "Backcharge To"; Text[100])
        {
        }
        field(50157; "Other Charge"; Decimal)
        {

        }
        field(50158; "Mubark-VAT"; Decimal)
        {

        }
        field(50159; "Mubark-Other Charge"; Decimal)
        {

        }
        field(50160; "Vessel Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Value".Name where(Code = field("Shortcut Dimension 1 Code")));
        }
        field(50161; "Mubarak Supplier"; Code[20])
        {
            TableRelation = Vendor;
            trigger OnValidate()
            var
                Vendor: Record Vendor;
            begin


                IF Vendor.Get("Mubarak Supplier") THEN
                    "Mubark Supplier Name" := Vendor.Name
                ELSE
                    "Mubark Supplier Name" := '';

                Vendor.CheckBlockedVendOnDocs(Vendor, false);

            end;
        }
        field(50162; "Mubark Supplier Name"; Text[100])
        {
            Editable = false;
        }
        field(50163; "Record Created By"; Code[100])
        {
            Editable = false;
        }
        field(50164; "Approved By"; Text[100])
        {
            Editable = false;
        }
        field(50012; "Reason"; option)
        {
            OptionMembers = ,"Without VAT","Change supplier","Change of price","No discount","Wrong quantity","Others";
        }
        field(50013; "Reasons"; Text[250])
        {

        }
        field(50014; "Amount(AED)"; Decimal)
        {

        }
        //Ramesh
        field(50165; "Shortcut Dimension 3 Code"; Code[20])
        {
            Caption = 'Job Number';
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          Blocked = CONST(false));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
            end;
        }
        field(50020; UserName; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;

        }
        Field(50021; Agency; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50022; "Other Reference"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        //Ramesh
        field(50166; "Project Code"; Code[20])
        {
            Editable = false;
        }
        modify(Status)
        {
            trigger OnAfterValidate()
            var
            begin
                AppEntRec.Reset();
                AppEntRec.SetRange("Document No.", "No.");
                If AppEntRec.FindLast() then
                    "Approved By" := AppEntRec."Approver ID";
            end;
        }
    }
    trigger OnInsert()
    begin

        //if xRec."No." = '' then
        "Record Created By" := UserId;

        AppEntRec.Reset();
        AppEntRec.SetRange("Document No.", "No.");
        If AppEntRec.FindLast() then
            "Approved By" := AppEntRec."Approver ID";

    End;

    trigger OnModify()
    Var

    begin
        AppEntRec.Reset();
        AppEntRec.SetRange("Document No.", "No.");
        If AppEntRec.FindLast() then
            "Approved By" := AppEntRec."Approver ID";
    End;

    Var
        AppEntRec: Record "Approval Entry";

    procedure UpdateLineShortClose(Var ParRec: Record "Purchase Header"; ParShortClose: Boolean; ParCancel: Boolean)
    var
        PurchaseLine: Record "Purchase Line";
        PLineOld: Record "Purchase Line";
    begin

        ParRec.AMG_ShortClosed := ParShortClose;
        ParRec.AMG_Cancelled := ParCancel;
        ParRec.AMG_ShortClosedOrCancelled := ParShortClose OR ParCancel;
        ParRec.MODIFY(false);

        PLineOld.RESET;
        PLineOld.SETRANGE("Document No.", "No.");
        PLineOld.SETRANGE("Document Type", "Document Type");
        //PurchaseLine.SETRANGE(AMG_AppliedForClose, TRUE);
        IF PLineOld.FindSet() THEN Begin
            Repeat
                PurchaseLine.Get(PLineOld."Document Type", PLineOld."Document No.", PLineOld."Line No.");
                PurchaseLine.AMG_OriginalQty := PurchaseLine.Quantity;
                IF PurchaseLine."Quantity Received" > 0 THEN begin
                    PurchaseLine.VALIDATE(AMG_ShortClosedQty, PurchaseLine.Quantity - PurchaseLine."Quantity Received");
                    IF PurchaseLine.Type = PurchaseLine.Type::Item Then
                        PurchaseLine.VALIDATE(Quantity, PurchaseLine."Quantity Received");
                    PurchaseLine."AMG_ShortClosed" := TRUE;
                end Else begin
                    PurchaseLine.VALIDATE(AMG_CancelledQty, PurchaseLine.Quantity);
                    IF PurchaseLine.Type = PurchaseLine.Type::Item Then
                        PurchaseLine.VALIDATE(Quantity, 0);
                    PurchaseLine.AMG_Cancelled := TRUE;
                end;
                IF PurchaseLine.Type = PurchaseLine.Type::Item Then
                    PurchaseLine.VALIDATE("Outstanding Qty. (Base)", 0);
                PurchaseLine.MODIFY;
            until PLineOld.Next() = 0;
        End;
    end;

    procedure UndoShortClosePurchase(var ParRec: Record "Purchase Header")
    var
        PurchaseLine: Record "Purchase Line";
        PLine: Record "Purchase Line";
    begin
        PLine.RESET;
        PLine.SETRANGE("Document Type", "Document Type");
        PLine.SETRANGE("Document No.", "No.");
        IF PLine.FINDSET THEN BEGIN
            REPEAT
                PurchaseLine.Get(PLine."Document Type", PLine."Document No.", PLine."Line No.");
                PurchaseLine.VALIDATE(Quantity, PurchaseLine.AMG_OriginalQty);
                PurchaseLine.VALIDATE(AMG_OriginalQty, 0);
                PurchaseLine.VALIDATE(AMG_CancelledQty, 0);
                PurchaseLine.VALIDATE(AMG_ShortClosedQty, 0);
                PurchaseLine.AMG_Cancelled := false;
                PurchaseLine.AMG_ShortClosed := false;
                PurchaseLine.MODIFY;
            UNTIL PLine.NEXT = 0;
        END;
        ParRec.AMG_ShortClosed := false;
        ParRec.AMG_Cancelled := false;
        ParRec.AMG_ShortClosedOrCancelled := False;
        ParRec.Modify();
    end;

    procedure CheckforPendingInvoice()
    var
        TempInt: Integer;
        Text5000: Label 'Invoice must be posted before short close.';
        PurchaseLine: Record "Purchase Line";
    begin
        TempInt := 0;
        PurchaseLine.RESET;
        PurchaseLine.SETCURRENTKEY("Document No.", "Document Type");
        PurchaseLine.SETRANGE("Document No.", "No.");
        PurchaseLine.SETRANGE("Document Type", "Document Type");
        PurchaseLine.SETRANGE(AMG_AppliedForClose, TRUE);
        IF PurchaseLine.FINDSET THEN
            REPEAT
                IF (PurchaseLine."Qty. Received (Base)" <> PurchaseLine."Qty. Invoiced (Base)") THEN
                    TempInt += 1;
            UNTIL PurchaseLine.NEXT = 0;
        IF TempInt <> 0 THEN
            ERROR(Text5000)
    end;


    procedure PerformManualReopen(Var PurchHeader: Record "Purchase Header")
    var
        Text00001: Label 'The approval process must be canceled or completed to reopen this document.';
    begin
        IF PurchHeader.Status = PurchHeader.Status::"Pending Approval" THEN
            ERROR(Text00001);

        UpdateWhseRqst(PurchHeader, False);
    end;

    procedure UpdateWhseRqst(var PurchHeader: Record "Purchase Header"; ParReleased: Boolean)
    var
        WhseRqst: Record "Warehouse Request";
        WhsePurchRelease: Codeunit "Whse.-Purch. Release";
    begin
        WhsePurchRelease.Reopen(PurchHeader);
        WhseRqst.RESET;
        WhseRqst.SETCURRENTKEY("Source Type", "Source Subtype", "Source No.");
        WhseRqst.SETRANGE(Type, WhseRqst.Type::Inbound);
        WhseRqst.SETRANGE("Source Type", DATABASE::"Purchase Line");
        WhseRqst.SETRANGE("Source Subtype", "Document Type");
        WhseRqst.SETRANGE("Source No.", "No.");
        WhseRqst.SETRANGE("Document Status", PurchHeader.Status::Released);
        IF WhseRqst.FIND('-') THEN
            REPEAT
                IF ParReleased Then
                    WhseRqst."Document Status" := PurchHeader.Status::Released
                else
                    WhseRqst."Document Status" := PurchHeader.Status::Open;
                WhseRqst.MODIFY;
            UNTIL WhseRqst.NEXT = 0;

        //PurchHeader.Status := PurchHeader.Status::Open;
        //PurchHeader.MODIFY(TRUE);
    end;
}
pageextension 50111 "Ex_PagePurchaseOrder" extends "Purchase Order"
{


    layout
    {
        addafter(Status)
        {
            field(Agency; Rec.Agency)
            {
                ApplicationArea = all;
            }
            field(Reasons; Rec.Reasons)
            {
                Caption = 'Reason';
                ApplicationArea = all;
            }
            field("Other Reference"; Rec."Other Reference")
            {
                //Caption = 'Reason';
                ApplicationArea = all;
            }
        }
        modify("No.")
        {
            Editable = (Rec.Status = Rec.Status::Open);
        }
        modify("Buy-from Vendor No.")
        {
            Editable = (Rec.Status = Rec.Status::Open);
        }

        modify("Buy-from Vendor Name")
        {
            Editable = (Rec.Status = Rec.Status::Open);
        }
        modify("Buy-from Address 2")
        {
            Editable = (Rec.Status = Rec.Status::Open);
        }
        modify("VAT Bus. Posting Group")
        {
            Editable = (Rec.Status = Rec.Status::Open);
        }
        modify("Payment Terms Code")
        {
            Editable = (Rec.Status = Rec.Status::Open);
        }
        modify("Currency Code")
        {
            Editable = (Rec.Status = Rec.Status::Open);
        }
        modify("Buy-from Address")
        {
            Editable = (Rec.Status = Rec.Status::Open);
        }
        modify("Buy-from City")
        {
            Editable = (Rec.Status = Rec.Status::Open);
        }
        modify("Buy-from Post Code")
        {
            Editable = (Rec.Status = Rec.Status::Open);
        }

        modify("Buy-from Country/Region Code")
        {
            Editable = (Rec.Status = Rec.Status::Open);
        }
        modify("Buy-from Contact")
        {
            Editable = (Rec.Status = Rec.Status::Open);
        }
        modify("Buy-from Contact No.")
        {
            Editable = (Rec.Status = Rec.Status::Open);
        }
        modify("Document Date")
        {
            Editable = (Rec.Status = Rec.Status::Open);
        }
        modify("Due Date")
        {
            Editable = (Rec.Status = Rec.Status::Open);
        }

        modify("Location Code")
        {
            Editable = (Rec.Status = Rec.Status::Open);
        }
        modify("Vendor Invoice No.")
        {
            Editable = (Rec.Status = Rec.Status::Open);
        }
        modify("Vendor Order No.")
        {
            Editable = (Rec.Status = Rec.Status::Open);
        }
        modify("Vendor Shipment No.")
        {
            Editable = True;
        }
        modify("Posting Date")
        {
            Editable = True;
        }
        modify("Order Date")
        {
            Editable = (Rec.Status = Rec.Status::Open);
        }

        modify("Order Address Code")
        {
            Editable = (Rec.Status = Rec.Status::Open);
        }
        modify("Shortcut Dimension 2 Code")
        {
            Editable = (Rec.Status = Rec.Status::Open);
        }
        modify("Expected Receipt Date")
        {
            Editable = (Rec.Status = Rec.Status::Open);
        }
        modify("Prices Including VAT")
        {
            Editable = (Rec.Status = Rec.Status::Open);
        }
        modify("Payment Method Code")
        {
            Editable = (Rec.Status = Rec.Status::Open);
        }
        modify("Payment Discount %")
        {
            Editable = (Rec.Status = Rec.Status::Open);
        }

        addafter("Buy-from Vendor Name")
        {
            field(Purpose; Rec.Purpose)
            {
                ApplicationArea = all;
                Editable = (Rec.Status = Rec.Status::Open) Or (Rec.Status = Rec.Status::"Pending Approval");
            }

        }
        addafter(Status)
        {
            field("Received by"; Rec."Received by")
            {
                ApplicationArea = All;
                Editable = true;
            }
            field("Receiving No. Series"; Rec."Receiving No. Series")
            {
                ApplicationArea = all;
                Editable = (Rec.Status = Rec.Status::Open);
            }
        }

        addafter("Shortcut Dimension 1 Code")
        {
            field("Vessel Name"; Rec."Vessel Name")
            {
                ApplicationArea = all;
                Editable = (Rec.Status = Rec.Status::Open);
            }
        }
        addafter("Shortcut Dimension 1 Code")
        {
            /*field("Shortcut Dimension 3 Code"; "Shortcut Dimension 3 Code")
             {
                 ApplicationArea = All;
             }*/

            field("Project Code"; Rec."Project Code")
            {
                ApplicationArea = all;
                Editable = (Rec.Status = Rec.Status::Open);
            }
        }
        modify("Shortcut Dimension 1 Code")
        {
            Editable = (Rec.Status = Rec.Status::Open);
            trigger OnAfterValidate()
            begin
                CurrPage.Update();
            end;
        }

        addafter("Order Date")
        {
            field("Redyness Date"; Rec."Redyness Date")
            {
                ApplicationArea = All;
                Editable = (Rec.Status = Rec.Status::Open);
            }
            field("Validity Date"; Rec."Validity Date")
            {
                ApplicationArea = All;
                Editable = (Rec.Status = Rec.Status::Open);
            }
            field("Packing Instruction"; Rec."Packing Instruction")
            {
                ApplicationArea = All;
                Editable = (Rec.Status = Rec.Status::Open);
            }
            field("Port of Call/Delivery Address"; Rec."Port of Call/Delivery Address")
            {
                ApplicationArea = All;
                Editable = (Rec.Status = Rec.Status::Open);
            }
            field("Warranty, if any"; Rec."Warranty, if any")
            {
                ApplicationArea = All;
                Editable = (Rec.Status = Rec.Status::Open);
            }
            field("Certificate(s), if required"; Rec."Certificate(s), if required")
            {
                ApplicationArea = All;
                Editable = (Rec.Status = Rec.Status::Open);
            }
            field("Mubarak Supplier"; Rec."Mubarak Supplier")
            {
                ApplicationArea = all;
                Editable = (Rec.Status = Rec.Status::Open);
            }
            field("Mubark Supplier Name"; Rec."Mubark Supplier Name")
            {
                ApplicationArea = ALL;
                Editable = (Rec.Status = Rec.Status::Open);
            }
            field("Coordinator No."; Rec."Coordinator No.")
            {
                ApplicationArea = all;
                Editable = (Rec.Status = Rec.Status::Open);
            }
            field("Coordinator Name"; Rec."Coordinator Name")
            {
                ApplicationArea = all;
                Editable = false;
            }

        }
        addlast(General)
        {
            field(AMG_ShortClosed; Rec.AMG_ShortClosed)
            {
                Visible = ShortCloseVisible;
                ApplicationArea = All;
                ToolTip = 'Specifies the order is short closed.';
            }
            field(AMG_Cancelled; Rec.AMG_Cancelled)
            {
                Visible = ShortCloseVisible;
                ApplicationArea = All;
                ToolTip = 'Specifies the order is cancelled.';
            }
            field(AMG_InitSourceNo; Rec.AMG_InitSourceNo)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the purchase requisition number.';
                Editable = (Rec.Status = Rec.Status::Open);
            }
            field(Backcharge; Rec.Backcharge)
            {
                ApplicationArea = all;
                Editable = (Rec.Status = Rec.Status::Open);
            }
            field("Backcharge To"; Rec."Backcharge To")
            {
                ApplicationArea = all;
                Editable = ((Rec.Backcharge = Rec.Backcharge::YES) and (Rec.Status = Rec.Status::Open));
            }
            field("Record Created By"; Rec."Record Created By")
            {
                ApplicationArea = all;
                Editable = (Rec.Status = Rec.Status::Open);
            }
            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = All;
                Editable = true;
            }
            group("Other Charges")
            {

                field("Other Charge"; Rec."Other Charge")
                {
                    ApplicationArea = all;
                    Editable = (Rec.Status = Rec.Status::Open);
                }
                field("Mubark-VAT"; Rec."Mubark-VAT")
                {
                    ApplicationArea = All;
                    Editable = (Rec.Status = Rec.Status::Open);
                }
                field("Mubark-Other Charge"; Rec."Mubark-Other Charge")
                {
                    ApplicationArea = All;
                    Editable = (Rec.Status = Rec.Status::Open);
                }

            }

        }

        moveafter("Area"; "Responsibility Center")
        modify("Assigned User ID") { Visible = false; }
        moveafter("Vendor Invoice No."; "Currency Code")
        moveafter("Vendor Invoice No."; "VAT Bus. Posting Group")
        moveafter("Vendor Invoice No."; "Payment Terms Code")
        moveafter("Vendor Invoice No."; "Shortcut Dimension 1 Code")
        moveafter("Vendor Invoice No."; "Shortcut Dimension 2 Code")
        moveafter("Vendor Invoice No."; "Location Code")
    }

    actions
    {
        modify(SendApprovalRequest)
        {

            trigger OnAfterAction()
            begin
                ApprEntry.Reset;
                ApprEntry.SetRange("Document No.", Rec."No.");
                ApprEntry.SetRange(Status, ApprEntry.Status::Approved);
                if ApprEntry.findfirst then begin
                    Rec.TESTFIELD(Reasons);
                end else begin
                    if Rec.Reasons <> '' then
                        Error('Reason field should be blank');
                end;

            end;
        }

        modify("Post and &Print")
        {
            trigger OnAfterAction()
            begin
                Rec.TestField("Coordinator No.");
            end;
        }

        modify(Approve)
        {
            trigger OnAfterAction()
            begin
                /*IF "Shortcut Dimension 2 Code" = 'MLS' THEN
                     TESTFIELD(Purpose);*/
            End;
        }
        modify(Post)
        {
            trigger Onafteraction()
            begin
                Rec.TESTFIELD("Coordinator No.");
            end;
        }
        addafter("&Print")
        {
            Action("New Purchase Order")
            {
                ApplicationArea = All;
                Caption = 'Purchase Order Local';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction();
                var
                    PoRep: Report "PO Report";
                    PoRec: Record "Purchase Header";
                begin
                    Clear(PoRep);
                    PoRec.SetRange("No.", Rec."No.");
                    PoRep.SetTableView(PoRec);
                    PoRep.RunModal();
                end;
            }
            Action("Purchase Order SRM")
            {
                ApplicationArea = All;
                Caption = 'Purchase Order Local SRM';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction();
                var
                    PoSRMRep: Report "PO Report SRM";
                    PoRec: Record "Purchase Header";
                begin
                    Clear(PoSRMRep);
                    PoRec.SetRange("No.", Rec."No.");
                    PoSRMRep.SetTableView(PoRec);
                    PoSRMRep.RunModal();
                end;
            }
            Action("New Purchase Order 2")
            {
                ApplicationArea = All;
                Caption = 'Purchase Order Import';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction();
                var
                    Po2Rep: Report "PO Report Export";
                    PoRec: Record "Purchase Header";
                begin
                    Clear(Po2Rep);
                    PoRec.SetRange("No.", Rec."No.");
                    Po2Rep.SetTableView(PoRec);
                    Po2Rep.RunModal();
                end;
            }

            // Start Avinash
            Action("Purchase Order- Mubark")
            {
                ApplicationArea = All;
                Caption = 'Purchase Order Mubark';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction();
                var
                    Po2Rep: Report "PO Report Mubark";
                    PoRec: Record "Purchase Header";
                begin
                    Clear(Po2Rep);
                    PoRec.SetRange("No.", Rec."No.");
                    Po2Rep.SetTableView(PoRec);
                    Po2Rep.RunModal();
                end;
            }
            Action("Purchase Order- From Mubark To Supplier")
            {
                ApplicationArea = All;
                Caption = 'Purchase Order From Mubark To Supplier';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction();
                var
                    Po2Rep: Report "PO From Mubark to Supplier";
                    PoRec: Record "Purchase Header";
                begin
                    Clear(Po2Rep);
                    PoRec.SetRange("No.", Rec."No.");
                    Po2Rep.SetTableView(PoRec);
                    Po2Rep.RunModal();
                end;
            }
            Action("Po_HR")
            {
                ApplicationArea = All;
                Caption = 'PO HR Admin';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction();
                var
                    PoRep: Report "PO_HR&Admin";
                    PoRec: Record "Purchase Header";
                begin
                    Clear(PoRep);
                    PoRec.SetRange("No.", Rec."No.");
                    PoRep.SetTableView(PoRec);
                    PoRep.RunModal();
                end;
            }
            Action("PO_Crewing")
            {
                ApplicationArea = All;
                Caption = 'PO Crewing / Agency';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction();
                var
                    PoRep: Report PO_Crewing;
                    PoRec: Record "Purchase Header";
                begin
                    Clear(PoRep);
                    PoRec.SetRange("No.", Rec."No.");
                    PoRep.SetTableView(PoRec);
                    PoRep.RunModal();
                end;
            }

        }
        // Stop Avinash
        addlast("F&unctions")
        {
            action("Short Close")
            {
                Visible = Not ShortCloseVisible;
                ApplicationArea = All;
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = '';
                trigger OnAction()
                var
                    PurchaseHeader: Record "Purchase Header";
                    PurchaseLine: Record "Purchase Line";
                    ReleasePurchDOc: Codeunit "Release Purchase Document";
                    TotalLine: Integer;
                    StatusReleased: Boolean;
                    WantToShortcloseConfirm: Label 'Do you really want to short close the purchase order?';
                    TextshortCloseMsg: Label 'Order is successfully short closed.';
                    TextcancelCloseMsg: Label 'Order is successfully canceled.';
                    NothingToShortCloseError: Label 'There is nothing to short close.';
                    QuantityReceived: Decimal;
                    TotalQuantity: Decimal;
                begin
                    IF NOT CONFIRM(WantToShortcloseConfirm, FALSE) THEN
                        EXIT;

                    Rec.CheckforPendingInvoice;

                    IF Rec.Status = Rec.Status::Released THEN BEGIN
                        Rec.PerformManualReopen(Rec);
                        StatusReleased := TRUE;
                    END;

                    Clear(QuantityReceived);
                    TotalQuantity := 0;
                    TotalLine := 0;
                    PurchaseLine.RESET;
                    PurchaseLine.SETRANGE("Document Type", Rec."Document Type");
                    PurchaseLine.SETRANGE("Document No.", Rec."No.");
                    IF PurchaseLine.FINDSET THEN BEGIN
                        TotalLine := PurchaseLine.COUNT;
                        IF TotalLine = 0 then
                            Error(NothingToShortCloseError);
                        REPEAT
                            TotalQuantity += PurchaseLine.Quantity;
                            QuantityReceived += PurchaseLine."Quantity Received";
                        UNTIL PurchaseLine.NEXT = 0;
                    END;

                    IF TotalQuantity = 0 Then
                        Error(NothingToShortCloseError);

                    IF QuantityReceived > 0 Then begin
                        Rec.UpdateLineShortClose(Rec, True, false);
                        IF StatusReleased THEN Begin
                            ReleasePurchDOc.PerformManualRelease(Rec);
                            Rec.UpdateWhseRqst(Rec, true);
                        End;
                    end else begin
                        Rec.UpdateLineShortClose(Rec, false, True);
                    end;

                    IF QuantityReceived > 0 Then begin
                        MESSAGE(TextshortCloseMsg);
                    end else begin
                        MESSAGE(TextcancelCloseMsg);
                    end;
                    CurrPage.Close();
                end;
            }
            action("Undo Short Close")
            {
                Visible = ShortCloseVisible;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Undo Short Close';
                Image = Undo;

                trigger OnAction()
                var
                    ReleasePurchDOc: Codeunit "Release Purchase Document";
                    WantToUndoShortcloseConfirm: Label 'Do you really want to undo short close the purchase order?';
                    TextUndoshortCloseMsg: Label 'Order is successfully undo.';
                    RecUsersetup: Record "User Setup";
                begin
                    IF NOT CONFIRM(WantToUndoShortcloseConfirm, FALSE) THEN
                        EXIT;

                    if Recusersetup.GET(UserId) then;

                    if RecUsersetup.EnablePO then
                        Rec.UndoShortClosePurchase(Rec)
                    else
                        Error('Current user does not have rights to undo the shortclosed PO');

                    MESSAGE(TextUndoshortCloseMsg);
                end;
            }
            /* action(MOBILISATION)
             {
                 Image = UpdateDescription;
                 Promoted = true;
                 //PromotedOnly = true;
                 PromotedCategory = Process;
                 Caption = 'Mobilisation';
                 ApplicationArea = all;
                 trigger OnAction()
                 var
                     PurchaseLine: Record "Purchase Line";
                 begin
                     PurchaseLine.RESET;
                     PurchaseLine.SETRANGE("Document No.", Rec."No.");
                     PurchaseLine.SETRANGE("Document Type", Rec."Document Type");
                     PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
                     IF PurchaseLine.FINDSET THEN
                         REPEAT
                             PurchaseLine."Gen. Prod. Posting Group" := 'MOBILISATION';
                             PurchaseLine.MODIFY;
                         UNTIL PurchaseLine.NEXT = 0;
                     MESSAGE('Updated');
                 End;
             }
             action("DRY DOCKING")
             {
                 Image = UpdateDescription;
                 Promoted = true;
                 //PromotedOnly = true;
                 PromotedCategory = Process;
                 Caption = 'Dry Docking';
                 ApplicationArea = all;
                 trigger OnAction()
                 var
                     PurchaseLine: Record "Purchase Line";
                 begin
                     PurchaseLine.RESET;
                     PurchaseLine.SETRANGE("Document No.", Rec."No.");
                     PurchaseLine.SETRANGE("Document Type", Rec."Document Type");
                     PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
                     IF PurchaseLine.FINDSET THEN
                         REPEAT
                             PurchaseLine."Gen. Prod. Posting Group" := 'DRY DOCKING';
                             PurchaseLine.MODIFY;
                         UNTIL PurchaseLine.NEXT = 0;
                     MESSAGE('Updated');
                 End;
             }*/
            action("Lot No.")
            {
                Image = UpdateDescription;
                Promoted = true;
                //PromotedOnly =;
                PromotedCategory = Process;
                Caption = 'Update Lot No.';
                ApplicationArea = all;
                trigger OnAction();
                var
                    PurchaseLine: Record "Purchase Line";
                    ReservationEntry: Record "Reservation Entry";
                    ReservationEntry1: Record "Reservation Entry";
                    Endofloop: Boolean;
                    Qty: Decimal;
                Begin
                    PurchaseLine.RESET;
                    PurchaseLine.SETRANGE("Document No.", Rec."No.");
                    PurchaseLine.SETRANGE("Document Type", Rec."Document Type");
                    PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
                    IF PurchaseLine.FINDSET THEN
                        REPEAT
                            PurchaseLine.TESTFIELD("Shortcut Dimension 1 Code");

                            ReservationEntry.RESET;
                            ReservationEntry.SETRANGE("Item No.", PurchaseLine."No.");
                            ReservationEntry.SETRANGE("Source ID", PurchaseLine."Document No.");
                            ReservationEntry.SETRANGE("Source Ref. No.", PurchaseLine."Line No.");
                            IF ReservationEntry.FINDSET THEN
                                REPEAT
                                    ReservationEntry."Qty. to Handle (Base)" := 0;
                                    ReservationEntry."Qty. to Invoice (Base)" := 0;
                                    ReservationEntry.MODIFY;
                                UNTIL ReservationEntry.NEXT = 0;

                            CLEAR(Qty);
                            ReservationEntry.RESET;
                            ReservationEntry.SETRANGE("Item No.", PurchaseLine."No.");
                            ReservationEntry.SETRANGE("Source ID", PurchaseLine."Document No.");
                            ReservationEntry.SETRANGE("Source Ref. No.", PurchaseLine."Line No.");
                            IF ReservationEntry.FINDSET THEN
                                REPEAT

                                    ReservationEntry1.RESET;
                                    ReservationEntry1.SETRANGE("Item No.", PurchaseLine."No.");
                                    ReservationEntry1.SETRANGE("Source ID", PurchaseLine."Document No.");
                                    ReservationEntry1.SETRANGE("Source Ref. No.", PurchaseLine."Line No.");
                                    ReservationEntry1.CALCSUMS("Qty. to Handle (Base)");
                                    IF ReservationEntry1."Qty. to Handle (Base)" = PurchaseLine."Qty. to Receive" THEN
                                        //MESSAGE('Lot No. Updated');
                                        //EXIT;
                                        Endofloop := TRUE
                                    ELSE
                                        Endofloop := ReservationEntry.NEXT = 0;
                                    IF ReservationEntry.Quantity < PurchaseLine."Qty. to Receive" THEN BEGIN
                                        ReservationEntry.VALIDATE("Qty. to Handle (Base)", ReservationEntry."Quantity (Base)");
                                        ReservationEntry.VALIDATE("Qty. to Invoice (Base)", ReservationEntry."Quantity (Base)");
                                        ReservationEntry.MODIFY;
                                        Qty := Qty + ReservationEntry."Quantity (Base)";
                                    END ELSE BEGIN
                                        ReservationEntry.VALIDATE("Qty. to Handle (Base)", PurchaseLine."Qty. to Receive" - Qty);
                                        ReservationEntry.VALIDATE("Qty. to Invoice (Base)", PurchaseLine."Qty. to Receive" - Qty);
                                        ReservationEntry.MODIFY;
                                    END;
                                UNTIL Endofloop;

                            ReservationEntry1.RESET;
                            ReservationEntry1.SETRANGE("Item No.", PurchaseLine."No.");
                            ReservationEntry1.SETRANGE("Source ID", PurchaseLine."Document No.");
                            ReservationEntry1.SETRANGE("Source Ref. No.", PurchaseLine."Line No.");
                            IF NOT ReservationEntry1.FINDFIRST THEN BEGIN

                                ReservationEntry.RESET;
                                IF ReservationEntry.FINDLAST THEN
                                    ReservationEntry."Entry No." := ReservationEntry."Entry No." + 1
                                ELSE
                                    ReservationEntry."Entry No." := 1;

                                ReservationEntry."Item No." := PurchaseLine."No.";
                                ReservationEntry."Location Code" := PurchaseLine."Location Code";
                                ReservationEntry.VALIDATE("Quantity (Base)", PurchaseLine.Quantity);
                                ReservationEntry."Reservation Status" := ReservationEntry."Reservation Status"::Surplus;
                                ReservationEntry."Creation Date" := PurchaseLine."Order Date";
                                ReservationEntry."Source Type" := 39;
                                ReservationEntry."Source Subtype" := 1;
                                ReservationEntry."Source Prod. Order Line" := 0;
                                ReservationEntry."Source ID" := PurchaseLine."Document No.";
                                ReservationEntry."Source Batch Name" := '';
                                ReservationEntry."Source Ref. No." := PurchaseLine."Line No.";
                                ReservationEntry."Appl.-from Item Entry" := 0;
                                ReservationEntry."Shipment Date" := 0D;
                                ReservationEntry."Expected Receipt Date" := PurchaseLine."Order Date";
                                ReservationEntry."Created By" := USERID;
                                ReservationEntry.Positive := TRUE;
                                //ReservationEntry.VALIDATE("Qty. per Unit of Measure",1);
                                ReservationEntry."Lot No." := PurchaseLine."Shortcut Dimension 1 Code";
                                ReservationEntry.VALIDATE("Qty. to Handle (Base)", PurchaseLine."Qty. to Receive");
                                ReservationEntry."Item Tracking" := ReservationEntry."Item Tracking"::"Lot No.";
                                ReservationEntry.INSERT;

                            END;
                        UNTIL PurchaseLine.NEXT = 0;
                    MESSAGE('Lot No. is updated');
                end;
            }
        }
        //02.11.2020
        modify(Reopen)
        {
            Enabled = SetEditableG;
        }
        //02.11.2020

    }


    trigger OnAfterGetRecord()
    var
        GLSetup: Record "General Ledger Setup";
        DimSetEntRec: Record "Dimension Set Entry";
    begin

        ShortCloseVisible := Rec.AMG_ShortClosedorCancelled;
        GLSetup.Get();
        DimSetEntRec.Reset();
        DimSetEntRec.SetRange("Dimension set ID", rEC."Dimension Set ID");
        DimSetEntRec.SetRange("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
        if DimSetEntRec.FindFirst() then begin
            //DimSetEntRec.CalcFields("Dimension Value Code");
            Rec."Project Code" := DimSetEntRec."Dimension Value Code"
        End;

        //02.11.2020
        Clear(UserSetUpG);
        if UserSetUpG.GET(USERID) then
            SetEditableG := UserSetUpG."Access PO Master";

        //02.11.2020
        if (Rec.AMG_ShortClosed) OR (Rec.AMG_Cancelled) then
            CurrPage.Editable := False
        else
            CurrPage.Editable := True;

        Curr.reset;
        if Curr.GET(Rec."Currency Code") then;
        Rec.CalcFields("Amount Including VAT");
        //message('%1', "Amount Including VAT");

        CurrExchrate.reset;
        CurrExchrate.SetRange("Currency Code", Rec."Currency Code");
        CurrExchrate.SetRange("Relational Currency Code", ' ');
        if CurrExchrate.findlast then
            Rec.VALIDATE("Amount(AED)", Rec."Amount Including VAT" * CurrExchrate."Relational Exch. Rate Amount")
        else
            Rec.VALIDATE("Amount(AED)", Rec."Amount Including VAT");

    end;


    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
    begin
        //PurchhdrCU.Run();
        if (Rec.AMG_ShortClosed) OR (Rec.AMG_Cancelled) then
            CurrPage.Editable := False
        else
            CurrPage.Editable := True;


        Curr.reset;
        if Curr.GET(Rec."Currency Code") then;

        Rec.CalcFields("Amount Including VAT");

        CurrExchrate.reset;
        CurrExchrate.SetRange("Currency Code", Rec."Currency Code");
        CurrExchrate.SetRange("Relational Currency Code", ' ');
        if CurrExchrate.findlast then
            Rec.VALIDATE("Amount(AED)", Rec."Amount Including VAT" * CurrExchrate."Relational Exch. Rate Amount")
        else
            Rec.VALIDATE("Amount(AED)", Rec."Amount Including VAT");
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Validate(UserName, UserId);
    end;

    trigger OnOpenPage()
    Var
        GLSetup: Record "General Ledger Setup";
        DimSetEntRec: Record "Dimension Set Entry";
    begin

        ShortCloseVisible := Rec.AMG_ShortClosedorCancelled;
        ShortCloseVisible := Rec.AMG_ShortClosedorCancelled;
        GLSetup.Get();
        DimSetEntRec.Reset();
        DimSetEntRec.SetRange("Dimension set ID", rEC."Dimension Set ID");
        DimSetEntRec.SetRange("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
        if DimSetEntRec.FindFirst() then begin
            //DimSetEntRec.CalcFields("Dimension Value Code");
            Rec."Project Code" := DimSetEntRec."Dimension Value Code"
        end;

        //02.11.2020
        Clear(UserSetUpG);
        if UserSetUpG.GET(USERID) then
            SetEditableG := UserSetUpG."Access PO Master";
        //02.11.2020
        if (Rec.AMG_ShortClosed) OR (Rec.AMG_Cancelled) then
            CurrPage.Editable := False
        else
            CurrPage.Editable := True;

        RecpurchLine.reset;
        Recpurchline.setfilter("Document No.", '%1|%2|%3|%4|%5|%6', 'PO-20-07180', 'PO-20-07851', 'PO-20-08156', 'PO-21-00347', 'PO-21-00687', 'PO-21-00964');
        if RecPurchLine.findfirst then begin
            repeat
                //Recpurchline.validate("Quantity Received", 1);
                Recpurchline.validate("Qty. Rcd. Not Invoiced", 0);
                RecPurchLine.Modify(True);
            until recpurchline.next = 0;
        end;

    end;



    Var
        // [InDataSet]
        ShortCloseVisible: Boolean;
        FieldEditable: Boolean;
        //Coordinator: Record Coordinator;
        UserSetUpG: Record "User Setup";
        SetEditableG: Boolean;
        ApprEntry: Record "Approval Entry";
        CurrExchrate: Record "Currency Exchange Rate";
        Curr: record Currency;
        RecPurchLine: Record "Purchase Line";

}
