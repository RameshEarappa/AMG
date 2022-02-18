report 50110 "Job Cost Analysis"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report-rdlc-files/R_50110.rdl';
    Caption = 'Job Cost Analysis';
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Job; Job)
        {
            DataItemTableView = SORTING("No.")
                                ORDER(Ascending);
            RequestFilterFields = "No.";
            column(No_; "No.") { }
            column(Bill_to_Name; "Bill-to Name") { }
            column(Loction; Loction) { }
            column(Language_Code; "Language Code") { }
            column(VessalName; VessalName) { }

            //column()

            dataitem("Job Planning Line"; "Job Planning Line")
            {
                DataItemLink = "Job No." = FIELD("No.");
                //DataItemTableView = SORTING(J"ob No.,Job Task No.,Line No.) ORDER(Ascending) WHERE(Unit Cost=FILTER(<>0),Line Type=FILTER(Budget));
                DataItemTableView = SORTING("Job Task No.")
                                ORDER(Ascending)
                                WHERE("Line Type" = FILTER(Budget));
                column(Job_Task_No_; "Job Task No.") { }
                column(Description; JobDes) { }

                column(Unit_Price; "Unit Cost") { }
                column(Quantity; Quantity) { }
                column(ItemNo; "No.") { }
                column(Sno; Sno) { }


                trigger OnPreDataItem();
                begin

                end;

                trigger OnAfterGetRecord();
                begin
                    Clear(JobDes);
                    JobTaskRec.Reset();
                    JobTaskRec.SetRange("Job No.", "Job Planning Line"."Job No.");
                    JobTaskRec.SetRange("Job Task No.", "Job Planning Line"."Job Task No.");
                    If JobTaskRec.FindFirst() then
                        JobDes := JobTaskRec.Description;
                    if "Unit Price" <> UpTemp then
                        Sno += 1;
                    UpTemp := "Unit Price";

                end;
            }
            trigger OnPreDataItem();
            begin
            eND;

            trigger OnAfterGetRecord();
            begin
                DimRec.Reset();
                DimRec.SetRange(Code, "Global Dimension 1 Code");
                IF DimRec.FindFirst() then
                    VessalName := DimRec.Name;
            end;
        }

    }
    trigger OnPreReport();
    begin
        CompInfoRec.GET;
        CompInfoRec.CALCFIELDS(Picture);
        CheckRep.InitTextVariable;
    end;

    var
        CompInfoRec: Record "Company Information";
        CheckRep: Codeunit "Amount In Word LT";
        JobNo: Text;
        VessalName: Text;
        GLSetup: Record "General Ledger Setup";
        DimSetEntRec: Record "Dimension Set Entry";
        DimRec: Record "Dimension Value";
        JobTaskRec: Record "Job Task";
        JobDes: Text;
        Sno: Integer;
        UpTemp: Decimal;
}
