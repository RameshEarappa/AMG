page 50153 AMG_PurchRequisitionSubform
{
    AutoSplitKey = true;
    Caption = 'Purchase Requisition Line';
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = AMG_PurchRequisitionLine;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(QuoteCreated; Rec.QuoteCreated)
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows weather the line is linked with any purchase quote.';
                    Visible = False;
                }
                field(OrderCreated; Rec.OrderCreated)
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows weather the line is linked with any purchase order.';
                    Visible = false;
                }
                field(PQCreated; Rec.PQCreated)
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows weather the line is linked with any purchase quote.';

                }
                field(POCreated; Rec.POCreated)
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows weather the line is linked with any purchase order.';

                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the line type.';
                    ShowMandatory = true;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of a general ledger account or item,depending on what you selected in the Type field.';
                    ShowMandatory = true;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the entry.';
                    ShowMandatory = true;
                    Editable = SetEditableDescriptionG;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how each unit of the item is measured, such as in pieces.';
                    ShowMandatory = true;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a code for the location where you want the items to be placed when they are received.';
                    ShowMandatory = true;
                }
                field(Inventory; Rec.Inventory)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how many units, such as pieces, boxes, or cans, of the item are in inventory.';
                    ShowMandatory = true;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of units of the item specified on the line.';
                    ShowMandatory = true;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    ShowMandatory = true;
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
                    Visible = false;
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
                }
                field("Shortcut Dimension 8 Code"; Rec."Shortcut Dimension 8 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for Shortcut Dimension 8, which is codes that you set up in the General Ledger Setup window.';
                    ShowMandatory = true;
                }
                field(ROB; Rec.ROB) { ApplicationArea = all; }
                field(Remarks; Rec.Remarks) { ApplicationArea = all; }
                field("Remarks 2"; Rec."Remarks 2") { ApplicationArea = all; }
                field("Certificate Required"; Rec."Certificate Required") { ApplicationArea = all; }
                field("Special Instructions"; Rec."Special Instructions") { ApplicationArea = all; }
                field(Select; Rec.Select)
                {
                    ApplicationArea = all;
                    Editable = True;
                }
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
                ApplicationArea = Dimensions;
                Caption = 'Dimensions';
                Image = Dimensions;
                ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to purchase documents to distribute costs and analyze transaction history.';

                trigger OnAction()
                begin
                    Rec.ShowDimensions;
                end;
            }
            action(Select_Line)
            {
                ApplicationArea = all;
                Caption = 'Slect Lines';
                Promoted = true;
                PromotedOnly = true;
                Image = SelectLineToApply;
                trigger OnAction()
                var
                    LineRec: Record AMG_PurchRequisitionLine;
                begin
                    CurrPage.SETSELECTIONFILTER(LineRec);
                    If LineRec.FindSet() then begin
                        repeat
                            LineRec.Validate(Select, true);
                            LineRec.Modify();
                        until LineRec.next = 0;
                    End;
                    CurrPage.Update();
                End;
            }
            action(Unselect_Line)
            {
                ApplicationArea = all;
                Caption = 'Unslect Lines';
                Promoted = true;
                PromotedOnly = true;
                Image = SelectLineToApply;
                trigger OnAction()
                var
                    LineRec: Record AMG_PurchRequisitionLine;
                begin
                    CurrPage.SETSELECTIONFILTER(LineRec);
                    If LineRec.FindSet() then begin
                        repeat
                            LineRec.Validate(Select, false);
                            LineRec.Modify();
                        until LineRec.next = 0;
                    End;
                    CurrPage.Update();
                End;
            }

        }
    }
    trigger OnOpenPage()
    begin
        EditableDescripton;
    end;

    trigger OnAfterGetCurrRecord()
    var
        LineRec: Record AMG_PurchRequisitionLine;
    begin
        // LineRec.UpdateOrderStatus("Document No.");
        EditableDescripton;
    end;

    trigger OnAfterGetRecord()
    var
        LineRec: Record AMG_PurchRequisitionLine;
    begin
        //LineRec.UpdateOrderStatus("Document No.");
        EditableDescripton;
    end;

    trigger OnInit()
    Var
        LineRec: Record AMG_PurchRequisitionLine;
    begin
        LineRec.UpdateOrderStatus(Rec."No.");
    End;

    var
        SetEditableDescriptionG: Boolean;

    local procedure EditableDescripton()
    var
        UserSetupG: Record "User Setup";
    begin
        if Rec.Type = Rec.Type::Item then begin
            Clear(UserSetupG);
            if UserSetupG.Get(UserId) then begin
                if UserSetupG.EnablePODescription then
                    SetEditableDescriptionG := true
                else
                    SetEditableDescriptionG := false;
            end;
        end else
            SetEditableDescriptionG := true;
    end;
}


