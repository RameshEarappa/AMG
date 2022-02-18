
pageextension 50156 pageextension50156 extends "Purchase Order Subform"
{
    layout
    {
        addlast(Control1)
        {
            field(AMG_ShortClosed; Rec.AMG_ShortClosed)
            {
                Visible = ShortCloseVisible;
                ApplicationArea = All;
                ToolTip = 'Specifies the order is short closed.';
            }

            field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                Enabled = True;
                ApplicationArea = all;
            }
            field(AMG_ShortClosedQty; Rec.AMG_ShortClosedQty)
            {
                Visible = ShortCloseVisible;
                ApplicationArea = All;
                ToolTip = 'Specifies the quantity is short closed quantity.';
            }
            field(AMG_Cancelled; Rec.AMG_Cancelled)
            {
                Visible = ShortCloseVisible;
                ApplicationArea = All;
                ToolTip = 'Specifies the order is cancelled.';
            }
            field(AMG_CancelledQty; Rec.AMG_CancelledQty)
            {
                Visible = ShortCloseVisible;
                ApplicationArea = All;
                ToolTip = 'Specifies the quantity is Cancelled quantity.';
            }
            // field(AMG_AppliedForClose; AMG_AppliedForClose)
            // {
            //     Visible = false;
            //     ApplicationArea = All;
            //     ToolTip = 'Specifies the order is applied for short close.';
            // }

            field(AMG_InitSourceNo; Rec.AMG_InitSourceNo)
            {
                Visible = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the purchase requisition number.';
            }
            field(AMG_InitSourceLineNo; Rec.AMG_InitSourceLineNo)
            {
                Visible = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the purchase requisition line number.';
            }

        }
        addafter("Variant Code")
        {
            field(Backcharge; Rec.Backcharge)
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
            {
                ApplicationArea = all;
                Visible = false;
            }

        }
        addbefore(Type)

        {
            field("Line No"; Rec."Line No.")
            {
                ApplicationArea = all;
                Editable = SetEditableG;
            }
        }
        addafter(Quantity)
        {
            field("Qty to Receive"; Rec."Qty. to Receive")
            {
                ApplicationArea = all;
            }
        }
        //02.11.2020
        modify(Type) { Editable = SetEditableG; }
        modify("No.") { Editable = SetEditableG; }
        modify(Description) { Editable = SetEditableDescriptionG; }
        modify("Location Code") { Editable = SetEditableG; }
        modify("Bin Code") { Editable = SetEditableG; }
        modify(Quantity) { Editable = SetEditableG; }
        modify("Allow Invoice Disc.") { Editable = SetEditableG; }
        modify("Reserved Quantity") { Editable = SetEditableG; }
        modify("Unit of Measure Code") { Editable = SetEditableG; }
        modify("Line Discount Amount") { Editable = SetEditableG; }
        modify("Direct Unit Cost") { Editable = SetEditableG; }
        modify("Line Amount") { Editable = SetEditableG; }
        modify("VAT Prod. Posting Group") { Editable = SetEditableG; }
        modify("Quantity Received") { Editable = True; }
        modify("Qty. to Invoice") { Editable = SetEditableG; }
        modify("Quantity Invoiced") { Visible = True; Editable = True; }
        modify("Qty. to Assign") { Editable = SetEditableG; }
        modify("Qty. Assigned") { Editable = SetEditableG; }
        modify("Promised Receipt Date") { Editable = SetEditableG; }
        modify("Planned Receipt Date") { Editable = SetEditableG; }
        modify("Expected Receipt Date") { Editable = SetEditableG; }
        modify("Shortcut Dimension 1 Code") { Editable = SetEditableG; }
        modify("Shortcut Dimension 2 Code") { Editable = SetEditableG; }
        modify(ShortcutDimCode3) { Editable = SetEditableG; }
        modify(ShortcutDimCode4) { Editable = SetEditableG; }
        modify(ShortcutDimCode5) { Editable = SetEditableG; }
        modify(ShortcutDimCode6) { Editable = SetEditableG; }
        modify(ShortcutDimCode7) { Editable = SetEditableG; }
        modify(ShortcutDimCode8) { Editable = SetEditableG; }
        modify("Over-Receipt Quantity") { Editable = SetEditableG; }
        modify("Over-Receipt Code") { Editable = SetEditableG; }
        modify("Line Discount %") { Editable = SetEditableG; }
        //02.11.2020
    }

    trigger OnAfterGetRecord()
    begin

        ShortCloseVisible := Rec.AMG_ShortClosed or Rec.AMG_Cancelled;
        if (Rec."Quantity Received" = 0) and (Rec."Job Task No." = '') then begin
            RecJob.reset;
            if recjob.get(ShortcutDimCode[3]) and (Rec.Type <> Rec.Type::" ") then begin
                Rec."Job No." := ShortcutDimCode[3];

                if Rec.type = Rec.Type::"G/L Account" then begin
                    RecJobTask.Reset;
                    RecJobTask.SetRange("Job No.", ShortcutDimCode[3]);
                    RecJobTask.SetRange("Job Task No.", 'J-0002');
                    if RecJobTask.findfirst then
                        Rec."Job Task No." := 'J-0002';
                end else begin
                    if Rec.type = Rec.Type::Item then begin
                        RecJobTask.Reset;
                        RecJobTask.SetRange("Job No.", ShortcutDimCode[3]);
                        RecJobTask.SetRange("Job Task No.", 'J-0001');
                        if RecJobTask.findfirst then
                            Rec."Job Task No." := 'J-0001';
                    end;
                end;

            end;

        end;
        EditableDescripton;
    end;
    //02.11.2020
    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
    begin

        Clear(PurchaseHeaderG);
        PurchaseHeaderG.SetRange("Document Type", Rec."Document Type");
        PurchaseHeaderG.SetRange("No.", Rec."Document No.");
        if PurchaseHeaderG.FindFirst() then
            SetEditableG := PurchaseHeaderG.Status = PurchaseHeaderG.Status::Open;
        if (Rec."Quantity Received" = 0) and (Rec."Job Task No." = '') then begin
            RecJob.reset;
            if recjob.get(ShortcutDimCode[3]) and (Rec.type <> Rec.Type::" ") then begin
                Rec.VALIDATE("Job No.", ShortcutDimCode[3]);

                if Rec.type = Rec.Type::"G/L Account" then begin
                    RecJobTask.Reset;
                    RecJobTask.SetRange("Job No.", ShortcutDimCode[3]);
                    RecJobTask.SetRange("Job Task No.", 'J-0002');
                    if RecJobTask.findfirst then
                        Rec."Job Task No." := 'J-0002';
                end else begin

                    if Rec.type = Rec.Type::Item then begin
                        RecJobTask.Reset;
                        RecJobTask.SetRange("Job No.", ShortcutDimCode[3]);
                        RecJobTask.SetRange("Job Task No.", 'J-0001');
                        if RecJobTask.findfirst then
                            Rec."Job Task No." := 'J-0001';
                    end;
                end;

            end;
        end;
        EditableDescripton;
    end;
    //02.11.2020

    trigger OnOpenPage()
    begin
        EditableDescripton;
    end;

    var
        ShortCloseVisible: Boolean;
        //02.11.2020
        PurchaseHeaderG: Record "Purchase Header";
        SetEditableG: Boolean;
        RecJob: Record Job;
        RecJobTask: Record "Job Task";
        SetEditableDescriptionG: Boolean;
    //02.11.2020

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