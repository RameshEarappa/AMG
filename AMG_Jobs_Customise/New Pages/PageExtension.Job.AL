pageextension 50110 JobPageExtension extends "Job Card"
{
    layout
    {
        modify("Creation Date")
        {
            Editable = true;
        }
        addafter("Project Manager")
        {
            field("Vessel No."; Rec."Vessel No.")
            {
                ApplicationArea = All;
                Caption = 'Vessel No.';

            }
            field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
            {
                ApplicationArea = all;
                Editable = false;
                trigger OnValidate()
                begin
                    CurrPage.Update();

                end;
            }
            field("Vessel Name"; Rec."Vessel Name")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Contract No."; Rec."Contract No.")
            {
                ApplicationArea = all;
                Caption = 'Contract No.';
            }
            field(Loction; Rec.Loction)
            {
                ApplicationArea = all;
                Caption = 'Location';
            }
        }

        modify("Bill-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                AddDimension: codeunit "Create Document";
            begin
                CurrPage.Update();
                if Rec."Bill-to Customer No." <> '' then begin
                    AddDimension.CreateDefaultDimesnion(Rec."No.");
                    Rec.CreateDimesnionForVessel;
                end;
            end;
        }
        moveafter(Loction; "Currency Code")
    }
    actions
    {
        addafter("&Copy")
        {
            Action("Job Cost Analysis")
            {
                ApplicationArea = All;
                Caption = 'Job Cost Analysis';
                Promoted = true;
                PromotedOnly = true;
                Image = Print;
                trigger OnAction();
                var
                    JobRep: Report "Job Cost Analysis";
                    JobRec: Record Job;
                begin
                    Clear(JobRep);
                    JobRec.SetRange("No.", Rec."No.");
                    JobRep.SetTableView(JobRec);
                    JobRep.RunModal();
                end;
            }
        }
        addafter("Ledger E&ntries")
        {
            action("Update Ledger Entries")
            {
                ApplicationArea = All;
                Image = UpdateDescription;
                Visible = false;
                trigger OnAction()
                var
                    UpdateReport: Report "Update Job Ledger Entries";
                begin
                    Clear(UpdateReport);
                    UpdateReport.UseRequestPage(false);
                    //UpdateReport.setJobNo(Rec."No.");
                    //UpdateReport.RunModal();
                end;
            }
        }
    }

}
