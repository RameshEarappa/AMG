page 50152 AMG_PurchRequisitionCard
{
    PageType = Document;
    Caption = 'Purchase Requisition';
    PopulateAllFields = true;
    RefreshOnActivate = true;
    SourceTableView = sorting("No.");
    DeleteAllowed = false;
    SourceTable = AMG_PurchRequisitionHeader;
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = Rec.Status = Rec.Status::Open;
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the involved purchase requisition record, according to the specified number series.';
                }
                field("Requisition Date"; Rec."Requisition Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when purchase requisition is created.';
                    ShowMandatory = true;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    ShowMandatory = true;
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Vessel Name"; Rec."Vessel Name")
                {
                    ApplicationArea = all;
                }

                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    ShowMandatory = true;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for Shortcut Dimension 3, which is codes that you set up in the General Ledger Setup window.';
                    ShowMandatory = true;
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for Shortcut Dimension 4, which is codes that you set up in the General Ledger Setup window.';
                    ShowMandatory = true;
                }
                field("Shortcut Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for Shortcut Dimension 5, which is codes that you set up in the General Ledger Setup window.';
                    ShowMandatory = true;
                    Visible = False;
                }
                field("Shortcut Dimension 6 Code"; Rec."Shortcut Dimension 6 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for Shortcut Dimension 6, which is codes that you set up in the General Ledger Setup window.';
                    ShowMandatory = true;
                    Visible = true;
                }
                field("Shortcut Dimension 7 Code"; Rec."Shortcut Dimension 7 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for Shortcut Dimension 7, which is codes that you set up in the General Ledger Setup window.';
                    ShowMandatory = true;
                    Visible = false;
                }
                field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for Shortcut Dimension 8, which is codes that you set up in the General Ledger Setup window.';
                    ShowMandatory = true;
                    Visible = false;
                }
                field("Coordinator No."; Rec."Coordinator No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the Unique Coordinator Code';
                }
                field("Coordinator Name"; Rec."Coordinator Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the coordinator.';
                    // ShowMandatory = true;
                }
                field("Requested By"; Rec."Requested By")
                {
                    ApplicationArea = all;
                }
                field("Requested Date"; Rec."Requested Date")
                {
                    ApplicationArea = all;

                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                    Editable = false;
                }

                field(Backcharge; Rec.Backcharge)
                {
                    ApplicationArea = all;
                }
                field("Backcharge To"; Rec."Backcharge To")
                {
                    ApplicationArea = all;
                    Editable = Rec.Backcharge = Rec.Backcharge::YES;
                }
                field(Cancelled; Rec.Cancelled)
                {
                    ApplicationArea = all;
                }

                field("Created Date"; Rec."Created Date")
                {

                    ApplicationArea = all;
                }
                field("Order Status"; Rec."Order Status")
                {
                    ApplicationArea = all;
                    Editable = false;

                }
                field("MR No."; Rec."MR No.")
                {
                    ApplicationArea = all;
                }
            }
            part("Requisition Line"; 50153)
            {
                SubPageLink = "Document No." = FIELD("No.");
                SubPageView = SORTING("Document No.");
                UpdatePropagation = Both;
                ApplicationArea = All;
                Editable = Rec.Status = Rec.Status::Open;
            }
        }

    }


    actions
    {
        area(Processing)
        {
            action(Dimensions)
            {
                AccessByPermission = TableData Dimension = R;
                ApplicationArea = All;
                Caption = 'Dimensions';
                Image = Dimensions;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to purchase documents to distribute costs and analyze transaction history.';

                trigger OnAction()
                begin
                    Rec.ShowDocDim;
                end;
            }
            action(CreatePurchaseQuote)
            {
                ApplicationArea = All;
                Caption = 'Create Purch. Quote';
                Image = CreateDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Create purchase quote based on the given information in purchase requisition.';

                trigger OnAction()
                var
                    SelectedPurchReqLine: Record AMG_PurchRequisitionLine;
                    MiscMgmt: Codeunit AMG_MiscManagement;
                    PurchType: Option Quote,"Order";
                    UserSetup: Record "User Setup";
                begin
                    Rec.TestField(Status, Rec.Status::Released);
                    Rec.TestField(Cancelled, false);
                    IF Rec.Backcharge = Rec.Backcharge::" " THEN
                        Error('Please select Backcharge');
                    UserSetup.Get(UserId);
                    IF NOT UserSetup.Create THEN
                        Error('You Do not have permission to create Quote.');
                    PurchType := PurchType::Quote;
                    CurrPage."Requisition Line".PAGE.SETSELECTIONFILTER(SelectedPurchReqLine);
                    Rec.CheckMandatoryFields(Rec, SelectedPurchReqLine);
                    // SelectedPurchReqLine.CheckOrderExist(SelectedPurchReqLine);
                    MiscMgmt.CreatePurchDocument(Rec, SelectedPurchReqLine, PurchType);
                end;
            }
            action(CreatePurchaseOrder)
            {
                ApplicationArea = Dimensions;
                Caption = 'Create Purch. Order';
                Image = CreateDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Create purchase order based on the given information in purchase requisition.';

                trigger OnAction()
                var
                    SelectedPurchReqLine: Record AMG_PurchRequisitionLine;
                    MiscMgmt: Codeunit AMG_MiscManagement;
                    PurchType: Option Quote,"Order";
                    UserSetup: Record "User Setup";
                    RecPurchHeader: Record "Purchase Header";
                begin
                    Rec.TestField(Status, Rec.Status::Released);
                    Rec.TestField(Cancelled, false);
                    IF Rec.Backcharge = Rec.Backcharge::" " THEN
                        Error('Please select Backcharge');

                    UserSetup.Get(UserId);
                    IF NOT UserSetup.Create THEN
                        Error('You Do not have permission to create Order.');
                    PurchType := PurchType::Order;
                    CurrPage."Requisition Line".PAGE.SETSELECTIONFILTER(SelectedPurchReqLine);
                    Rec.CheckMandatoryFields(Rec, SelectedPurchReqLine);
                    //<LT>
                    RecPurchHeader.reset;
                    RecPurchHeader.SetRange(AMG_InitSourceNo, Rec."No.");
                    if RecPurchHeader.findfirst then
                        Error('PO Already created for this PR %1', Rec."No.");
                    //</LT>

                    //SelectedPurchReqLine.CheckOrderExist(SelectedPurchReqLine);
                    MiscMgmt.CreatePurchDocument(Rec, SelectedPurchReqLine, PurchType);
                end;
            }
            action(PurcahseQuotes)
            {
                Caption = 'Purchase Quotes';
                ApplicationArea = All;
                Image = Quote;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Specifies the purchase quotes, which are linked with the requisitoin document.';
                trigger OnAction()
                var
                    PurcahseHeaderRec: Record "Purchase Header";
                begin
                    PurcahseHeaderRec.Reset();
                    PurcahseHeaderRec.SetRange("Document Type", PurcahseHeaderRec."Document Type"::Quote);
                    PurcahseHeaderRec.SetRange(AMG_InitSourceNo, Rec."No.");
                    if PurcahseHeaderRec.FindSet() then
                        Page.RunModal(Page::"Purchase Quotes", PurcahseHeaderRec);
                end;
            }
            action(PurcahseOrders)
            {
                Caption = 'Purchase Orders';
                ApplicationArea = All;
                Image = Order;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Specifies the purchase Orders, which are linked with the requisitoin document.';
                trigger OnAction()
                var
                    PurcahseHeaderRec: Record "Purchase Header";
                begin
                    PurcahseHeaderRec.Reset();
                    PurcahseHeaderRec.SetRange("Document Type", PurcahseHeaderRec."Document Type"::"Order");
                    PurcahseHeaderRec.SetRange(AMG_InitSourceNo, Rec."No.");
                    if PurcahseHeaderRec.FindSet() then
                        Page.RunModal(Page::"Purchase Order List", PurcahseHeaderRec);
                end;
            }
            action(Reopen)
            {
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                trigger OnAction()
                var
                    UserSetup: Record "User Setup";
                    PReqLine: Record AMG_PurchRequisitionLine;
                begin
                    PReqLine.Reset();
                    PReqLine.SetRange("Document No.", Rec."No.");
                    PReqLine.SetRange(OrderCreated, true);
                    IF PReqLine.FindFirst() THEN
                        Error('You Cannot Reopen PR as Quote/Order is Created');

                    PReqLine.Reset();
                    PReqLine.SetRange("Document No.", Rec."No.");
                    PReqLine.SetRange(QuoteCreated, true);
                    IF PReqLine.FindFirst() THEN
                        Error('You Cannot Reopen PR as Quote/Order is Created');

                    Rec.TestField(Status, Rec.Status::Released);
                    UserSetup.Get(UserId);
                    IF NOT UserSetup."PR Release" THEN
                        Error('You Do not have permission to ReOpen PR');
                    Rec.Status := Rec.Status::Open;
                    Rec.Modify();
                    CurrPage.Update();
                end;
            }
            action(Released)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                trigger OnAction()
                var
                    UserSetup: Record "User Setup";
                begin
                    Rec.TestField(Status, Rec.Status::Open);
                    UserSetup.Get(UserId);
                    IF NOT UserSetup."PR Release" THEN
                        Error('You Do not have permission to Release PR');
                    Rec.Status := Rec.Status::Released;
                    Rec.Modify();
                    CurrPage.Update();
                end;
            }
            action("Cancel PR")
            {
                Caption = 'Cancel PR';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                trigger OnAction()
                var
                    SelectedPurchReqLine: Record AMG_PurchRequisitionLine;
                    RecPurchHeader: record "Purchase Header";
                begin
                    Rec.TestField(Status, Rec.Status::Released);

                    RecPurchHeader.Reset;
                    RecPurchHeader.SetRange("Document Type", RecPurchHeader."Document Type"::Order);
                    RecPurchHeader.Setrange(AMG_InitSourceNo, Rec."No.");
                    if RecPurchHeader.findfirst then begin
                        Error('Purchase Order is created, You cannot cancel the PR');
                    end;

                    RecPurchHeader.Reset;
                    RecPurchHeader.SetRange("Document Type", RecPurchHeader."Document Type"::Quote);
                    RecPurchHeader.Setrange(AMG_InitSourceNo, Rec."No.");
                    if RecPurchHeader.findfirst then begin
                        Error('Purchase Quote is created, Please delete the quote and cancel the PR');
                    end;

                    Rec.Cancelled := true;
                    Rec.Modify();

                    CurrPage.Update();

                end;
            }
            action(Select_Line)
            {
                ApplicationArea = all;
                Caption = 'Slect All Lines';
                Promoted = true;
                PromotedOnly = true;
                Image = SelectLineToApply;
                trigger OnAction()
                var
                    LineRec: Record AMG_PurchRequisitionLine;
                begin
                    LineRec.Reset();
                    LineRec.SetRange("Document No.", Rec."No.");
                    IF LineRec.FindSet() then begin
                        repeat
                            LineRec.validate(Select, true);
                            LineRec.Modify();
                        until LineRec.Next() = 0;
                        CurrPage.Update();
                    end;

                End;
            }
            action(Unselect_Line)
            {
                ApplicationArea = all;
                Caption = 'Unselect All Lines';
                Promoted = true;
                PromotedOnly = true;
                Image = SelectLineToApply;
                trigger OnAction()
                var
                    LineRec: Record AMG_PurchRequisitionLine;
                begin
                    LineRec.Reset();
                    LineRec.SetRange("Document No.", Rec."No.");
                    IF LineRec.FindSet() then begin
                        repeat
                            LineRec.Validate(Select, false);
                            LineRec.Modify();
                        until LineRec.Next() = 0;
                        CurrPage.Update();
                    end;

                End;
            }
            action("Enable PR")
            {
                Caption = 'Enable PR';
                Image = Apply;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;

                trigger OnAction()
                var
                    RecUsersetup: Record "User Setup";
                begin
                    if RecUsersetup.GET(UserId) then;

                    if RecUsersetup."Enable PR" then begin
                        Rec.Cancelled := false;
                        Rec.Modify();
                    end else
                        Error('Current user does not have rights to Enable PR');


                    CurrPage.Update();

                end;
            }
            action("Report MLS")
            {
                ApplicationArea = All;
                Caption = 'PR-MLS';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction()
                var
                    PurcreqRec: Record AMG_PurchRequisitionHeader;
                    PrRep: Report PR_MLS_Report;

                begin
                    Clear(PrRep);
                    PurcreqRec.SetRange("No.", Rec."No.");
                    PrRep.SetTableView(PurcreqRec);
                    PrRep.RunModal();
                end;
            }
            action("Report SRM")
            {
                ApplicationArea = All;
                Caption = 'PR-SRM';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction()
                var
                    PurcreqRec: Record AMG_PurchRequisitionHeader;
                    PrRep: Report PR_SRM_Report;

                begin
                    Clear(PrRep);
                    PurcreqRec.SetRange("No.", Rec."No.");
                    PrRep.SetTableView(PurcreqRec);
                    PrRep.RunModal();
                end;
            }

        }
    }
    trigger OnAfterGetRecord()
    Var
        LineRec: Record AMG_PurchRequisitionLine;
    begin
        //LineRec.UpdateOrderStatus(Rec."No.");
    End;

    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
        LineRec: Record AMG_PurchRequisitionLine;
    begin
        //LineRec.UpdateOrderStatus(rec."No.");
    end;

    trigger OnOpenPage()
    Var
        LineRec: Record AMG_PurchRequisitionLine;
    begin
        //LineRec.UpdateOrderStatus(Rec."No.");
    End;



}