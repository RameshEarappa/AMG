pageextension 50118 DimesnionValue extends "Dimension Values"
{
    layout
    {
        // Add changes to page layout here
        addafter(Blocked)
        {
            field(Segment; Rec.Segment)
            {
                ApplicationArea = All;
                // Enabled = UnEditable;
            }

        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("F&unctions")
        {
            action("Create Job")
            {
                ApplicationArea = All;
                Image = Add;
                trigger OnAction()
                var
                    GenLedSetup: Record "General Ledger Setup";
                    CreateDoc: Codeunit "Create Document";
                begin

                    if Rec.Code <> '' then begin
                        if not Confirm('Are you sure you want to create Job for this dimesnion value?', false) then begin
                            exit;
                        end;
                        GenLedSetup.GET;
                        if Rec."Dimension Code" <> GenLedSetup."Shortcut Dimension 3 Code" then
                            Error('Dimension value must belongs to ' + GenLedSetup."Shortcut Dimension 3 Code");
                        GenLedSetup.TestField("Shortcut Dimension 3 Code");
                        Rec.TestField(Blocked, false);
                        Rec.TestField("Dimension Value Type", Rec."Dimension Value Type"::Standard);
                        Rec.TestField(Segment);
                        CreateDoc.CreateJob(Rec.Code, Rec.Segment);
                    end;
                end;
            }




            action("Create Vessel")
            {
                ApplicationArea = All;
                Image = New;
                trigger OnAction()
                var
                    GenLedSetup: Record "General Ledger Setup";
                    CreateDoc: Codeunit "Create Document";
                begin

                    if Rec.Code <> '' then begin
                        if not Confirm('Are you sure you want to create Vessel Master for this dimesnion value?', false) then begin
                            exit;
                        end;
                        GenLedSetup.GET;
                        if Rec."Dimension Code" <> GenLedSetup."Shortcut Dimension 1 Code" then
                            Error('Dimension value must belongs to ' + GenLedSetup."Shortcut Dimension 1 Code");
                        GenLedSetup.TestField("Shortcut Dimension 1 Code");
                        Rec.TestField(Blocked, false);
                        Rec.TestField("Dimension Value Type", Rec."Dimension Value Type"::Standard);
                        CreateDoc.CreareVessel(Rec.Code);
                    end;
                end;
            }
        }
    }

    var
        myInt: Integer;
}