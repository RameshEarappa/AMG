table 50152 AMG_PurchRequisitionLine
{
    DataClassification = CustomerContent;
    Caption = 'Purch. Requisition Line';

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(5; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,,Fixed Asset';
            OptionMembers = " ","G/L Account",Item,,"Fixed Asset";
            DataClassification = CustomerContent;
            // Start 22.01.2020
            trigger
            OnValidate()
            var
                AMG_PurchRequisitionHeaderG: Record AMG_PurchRequisitionHeader;
            begin
                AMG_PurchRequisitionHeaderG.Reset();
                AMG_PurchRequisitionHeaderG.SetRange("No.", "Document No.");
                if AMG_PurchRequisitionHeaderG.FindFirst() then
                    if AMG_PurchRequisitionHeaderG.Backcharge = AMG_PurchRequisitionHeaderG.Backcharge::Yes then
                        if Type <> Type::"G/L Account" then
                            Error('Back Charge only Applicable for GL Account.');
            end;
            // Stop 22.01.2020
        }
        field(6; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = IF (Type = CONST(" ")) "Standard Text"
            ELSE
            IF (Type = CONST("G/L Account")) "G/L Account" WHERE("Direct Posting" = CONST(true), "Account Type" = CONST(Posting), Blocked = CONST(false))
            ELSE
            IF (Type = CONST("G/L Account")) "G/L Account"
            ELSE
            IF (Type = CONST(Item)) Item WHERE(Blocked = CONST(false), "Purchasing Blocked" = CONST(false))
            ELSE
            IF (Type = CONST(Item)) Item WHERE(Blocked = CONST(false))
            ELSE
            IF (Type = CONST("Fixed Asset")) "Fixed Asset";
            ValidateTableRelation = false;
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ItemRec: Record Item;
                GLAccount: Record "G/L Account";
                FixedAsset: Record "Fixed Asset";
                HeaderRec: Record AMG_PurchRequisitionHeader;
            begin
                GetPurchReqHeader(HeaderRec);
                Validate("Dimension Set ID", HeaderRec."Dimension Set ID");

                case Type of
                    Type::Item:
                        if ItemRec.Get("No.") then begin
                            Description := ItemRec.Description;
                            "Unit of Measure Code" := ItemRec."Purch. Unit of Measure";
                        end;
                    Type::"G/L Account":
                        if GLAccount.Get("No.") then begin
                            Description := GLAccount.Name;
                        end;
                    Type::"Fixed Asset":
                        if FixedAsset.Get("No.") then begin
                            Description := FixedAsset.Description;
                        end;
                end;
            end;
        }
        field(7; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            DataClassification = CustomerContent;
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(11; Description; Text[100])
        {
            Caption = 'Description';
            TableRelation = IF (Type = CONST("G/L Account")) "G/L Account".Name WHERE("Direct Posting" = CONST(true), "Account Type" = CONST(Posting), Blocked = CONST(false))
            ELSE
            IF (Type = CONST("G/L Account")) "G/L Account".Name
            ELSE
            IF (Type = CONST(Item)) Item.Description WHERE(Blocked = CONST(false), "Purchasing Blocked" = CONST(false))
            ELSE
            IF (Type = CONST(Item)) Item.Description WHERE(Blocked = CONST(false));
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
        }
        field(15; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        //<LT_30Dec19>
        field(16; ROB; Decimal) { }
        field(17; Remarks; Text[250]) { }
        //</LT_30Dec19>
        field(40; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;

        }
        field(41; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(42; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                          Blocked = CONST(false));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
            end;
        }
        field(43; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                          Blocked = CONST(false));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(4, "Shortcut Dimension 4 Code");
            end;
        }
        field(44; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                          Blocked = CONST(false));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(5, "Shortcut Dimension 5 Code");
            end;
        }
        field(45; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                          Blocked = CONST(false));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(6, "Shortcut Dimension 6 Code");
            end;
        }
        field(46; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                          Blocked = CONST(false));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(7, "Shortcut Dimension 7 Code");
            end;
        }
        field(47; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                          Blocked = CONST(false));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(8, "Shortcut Dimension 8 Code");
            end;
        }
        field(50000; POCreated; Boolean)
        {
            Caption = 'Order Created';
            FieldClass = FlowField;
            CalcFormula = exist("Purchase Line" where("Document Type" = filter(Order), AMG_InitSourceNo = field("Document No."), AMG_InitSourceLineNo = field("Line No.")));
            Editable = false;
            trigger OnValidate()
            var
                lineRec: Record AMG_PurchRequisitionLine;
                Linerec2: Record AMG_PurchRequisitionLine;
                HeaderRec: Record AMG_PurchRequisitionHeader;
                BooL1: Boolean;
                Bool2: Boolean;
            begin
                lineRec.Reset();
                lineRec.SetRange("Document No.", rec."Document No.");
                lineRec.SetRange(POCreated, true);
                If lineRec.FindFirst() then
                    BooL1 := true
                Else
                    BooL1 := false;

                lineRec2.Reset();
                lineRec2.SetRange("Document No.", rec."Document No.");
                lineRec2.SetRange(POCreated, false);
                If lineRec2.FindFirst() then
                    BooL2 := true
                Else
                    BooL2 := false;

                HeaderRec.GET(rEC."Document No.");
                iF (BooL1) AND (not Bool2) then
                    HeaderRec."Order Status" := HeaderRec."Order Status"::"Completely Converted";
                if (nOT BooL1) AND (Bool2) then
                    HeaderRec."Order Status" := HeaderRec."Order Status"::"Not Yet Converted";
                if (BooL1) AND (Bool2) then
                    HeaderRec."Order Status" := HeaderRec."Order Status"::"Partially Converted";
                HeaderRec.Modify();

            end;
        }
        field(50001; PQCreated; Boolean)
        {
            Caption = 'Quote Created';
            FieldClass = FlowField;
            CalcFormula = exist("Purchase Line Archive" where("Document Type" = filter(Quote), AMG_InitSourceNo = field("Document No."), AMG_InitSourceLineNo = field("Line No.")));
            Editable = false;

        }
        field(51; OrderCreated; Boolean)
        {
            Caption = 'Order Created';
            FieldClass = FlowField;
            CalcFormula = exist("Purchase Line" where("Document Type" = filter(Order), AMG_InitSourceNo = field("Document No."), AMG_InitSourceLineNo = field("Line No.")));
            Editable = false;
            trigger OnValidate()
            var
                lineRec: Record AMG_PurchRequisitionLine;
                Linerec2: Record AMG_PurchRequisitionLine;
                HeaderRec: Record AMG_PurchRequisitionHeader;
                BooL1: Boolean;
                Bool2: Boolean;
            begin
                lineRec.Reset();
                lineRec.SetRange("Document No.", rec."Document No.");
                lineRec.SetRange(OrderCreated, true);
                If lineRec.FindFirst() then
                    BooL1 := true
                Else
                    BooL1 := false;

                lineRec2.Reset();
                lineRec2.SetRange("Document No.", rec."Document No.");
                lineRec2.SetRange(OrderCreated, false);
                If lineRec2.FindFirst() then
                    BooL2 := true
                Else
                    BooL2 := false;

                HeaderRec.GET(rEC."Document No.");
                iF (BooL1) AND (not Bool2) then
                    HeaderRec."Order Status" := HeaderRec."Order Status"::"Completely Converted";
                if (nOT BooL1) AND (Bool2) then
                    HeaderRec."Order Status" := HeaderRec."Order Status"::"Not Yet Converted";
                if (BooL1) AND (Bool2) then
                    HeaderRec."Order Status" := HeaderRec."Order Status"::"Partially Converted";
                HeaderRec.Modify();

            end;
        }
        field(52; QuoteCreated; Boolean)
        {
            Caption = 'Quote Created';
            FieldClass = FlowField;
            CalcFormula = exist("Purchase Line" where("Document Type" = filter(Quote), AMG_InitSourceNo = field("Document No."), AMG_InitSourceLineNo = field("Line No.")));
            Editable = false;

        }
        field(53; "Certificate Required"; Option)
        {
            OptionMembers = Yes,No;
        }
        field(54; "Special Instructions"; Text[250])
        {

        }
        field(55; Select; Boolean)
        {
            trigger OnValidate()
            begin

            eND;
        }
        field(68; Inventory; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("No."), "Location Code" = FIELD("Location Code")));
            Caption = 'Inventory';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
            DataClassification = CustomerContent;
            trigger OnLookup()
            begin
                ShowDimensions;
            end;

            trigger OnValidate()
            begin
                UpdateGlobalDimFromDimSetID("Dimension Set ID", Rec);
            end;
        }
        field(5407; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = IF (Type = CONST(Item), "Document No." = FILTER(<> '')) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."))
            ELSE
            "Unit of Measure";
            DataClassification = CustomerContent;
        }
        field(5500; "Remarks 2"; Text[100])
        {

        }

    }
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    var
        DimMgt: Codeunit DimensionManagement;

    trigger OnInsert()
    begin
        UpdateOrderStatus(Rec."Document No.");
    end;

    trigger OnModify()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId);
        IF (UserSetup.Create) and not (UserSetup."PR Release") then
            Error('You do not have permision to Modify the PR');
        UpdateOrderStatus(Rec."Document No.");
    end;

    trigger OnDelete()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId);
        IF (UserSetup.Create) and not (UserSetup."PR Release") then
            Error('You do not have permision to Delete the PR');
    end;

    trigger OnRename()
    begin

    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin

        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");

    end;

    procedure ShowDimensions() IsChanged: Boolean
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', "Document No.", "Line No."));
        // VerifyItemLineDim;
        UpdateGlobalDimFromDimSetID("Dimension Set ID", Rec);
        IsChanged := OldDimSetID <> "Dimension Set ID";

    end;

    procedure UpdateGlobalDimFromDimSetID(DimSetID: Integer; var ParRec: Record AMG_PurchRequisitionLine)
    var
        ShortcutDimCode: array[8] of Code[20];
        GetShortcutDimensionValues: Codeunit "Get Shortcut Dimension Values";
    begin
        GetShortcutDimensionValues.GetShortcutDimensions(DimSetID, ShortcutDimCode);
        ParRec."Shortcut Dimension 1 Code" := ShortcutDimCode[1];
        ParRec."Shortcut Dimension 2 Code" := ShortcutDimCode[2];
        ParRec."Shortcut Dimension 3 Code" := ShortcutDimCode[3];
        ParRec."Shortcut Dimension 4 Code" := ShortcutDimCode[4];
        ParRec."Shortcut Dimension 5 Code" := ShortcutDimCode[5];
        ParRec."Shortcut Dimension 6 Code" := ShortcutDimCode[6];
        ParRec."Shortcut Dimension 7 Code" := ShortcutDimCode[7];
        ParRec."Shortcut Dimension 8 Code" := ShortcutDimCode[8];
    end;

    local procedure GetPurchReqHeader(var ParPurchReqHeader: Record AMG_PurchRequisitionHeader)
    begin
        //ParPurchReqHeader.Get(Rec."Document No.");
    end;

    procedure UpdateOrderStatus(l_DocNo: Code[20])
    var
        LineRec: Record AMG_PurchRequisitionLine;
        HeadRec: Record AMG_PurchRequisitionHeader;
        Created: Boolean;
        Not_Created: Boolean;

    begin
        Created := false;
        Not_Created := False;
        LineRec.Reset();
        LineRec.SetRange("Document No.", l_DocNo);
        LineRec.SetRange(OrderCreated, true);
        If LineRec.FindSet() then
            Created := true;

        LineRec.Reset();
        LineRec.SetRange("Document No.", l_DocNo);
        LineRec.SetRange(OrderCreated, false);
        If LineRec.FindSet() then
            Not_Created := true;

        HeadRec.Reset();
        HeadRec.SetRange("No.", l_DocNo);
        If HeadRec.FindFirst() then begin
            IF (Not_Created) and (Created) then
                HeadRec."Order Status" := HeadRec."Order Status"::"Partially Converted";
            IF (Not Not_Created) and (Created) then
                HeadRec."Order Status" := HeadRec."Order Status"::"Completely Converted";
            If (Not_Created) and (Not Created) then
                HeadRec."Order Status" := HeadRec."Order Status"::"Not Yet Converted";
            HeadRec.Modify();
        End;
    end;
}