pageextension 50125 PQ_Sumform extends "Purchase Quote Subform"

{
    layout
    {
        addbefore(Type)
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addafter(Quantity)
        {
            field("Qty. to Receive"; Rec."Qty. to Receive")
            {
                ApplicationArea = all;
            }
        }
        modify(Description) { Editable = SetEditableDescriptionG; }
    }

    actions
    {
        // Add changes to page actions here
    }
    trigger OnAfterGetCurrRecord()
    begin
        EditableDescripton;
    end;

    trigger OnAfterGetRecord()
    begin
        EditableDescripton;
    end;

    trigger OnOpenPage()
    begin
        EditableDescripton;
    end;

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