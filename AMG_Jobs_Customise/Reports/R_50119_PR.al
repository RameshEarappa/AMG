report 50119 "PR_SRM_Report"
{
    DefaultLayout = RDLC;
    //RDLCLayout = '50101_28_V2.rdl';
    Caption = 'Purchase requisition SRM';
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(AMG_PurchRequisitionHeader; AMG_PurchRequisitionHeader)
        {
            column(CompLogo; CompInfoRec.Picture) { }
            column(CompName; CompInfoRec.Name) { }
            column(No_; "No.") { }
            column(Requisition_Date; FORMAT("Requisition Date", 8, '<Day,2>-<Month,2>-<year,2>')) { }
            column(Requested_By; "Requested By") { }
            column(Shortcut_Dimension_1_Code; Format(Vessalname)) { }
            column(Shortcut_Dimension_3_Code; Format("Shortcut Dimension 3 Code")) { }
            column(Shortcut_Dimension_2_Code; Format("Shortcut Dimension 2 Code")) { }
            column(Segnemt; Format(Segment)) { }
            column(DivisionName; Format(DivisionName)) { }
            column(Coordinator_Name; "Coordinator Name") { }
            column(Coordinator_No_; "Coordinator No.") { }
            dataitem(AMG_PurchRequisitionLine; AMG_PurchRequisitionLine)

            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = sorting("Document No.", "Line No.") order(ascending) where(Select = const(true), "No." = filter(<> ''), Quantity = filter(<> 0));
                column(Item_No; "No.") { }
                column(Description; Description) { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(Quantity; Quantity) { }
                column(Certificate_Required; "Certificate Required") { }
                column(Special_Instructions; "Special Instructions") { }
                column(Select; Select) { }
                column(S_No; S_No) { }
                trigger OnPreDataItem();
                begin

                end;

                trigger OnAfterGetRecord();
                begin

                end;
            }
            trigger OnPreDataItem();
            begin
            eND;

            trigger OnAfterGetRecord();
            begin
                S_No += 1;
                DimRec.Reset();
                DimRec.SetRange(Code, "Shortcut Dimension 1 Code");
                IF DimRec.FindFirst() then
                    Vessalname := DimRec.Name;
                DimRec.Reset();

                DimRec.SetRange(Code, "Shortcut Dimension 6 Code");
                IF DimRec.FindFirst() then
                    DivisionName := DimRec.Name;
                DimRec.Reset();

                DimRec.SetRange(Code, "Shortcut Dimension 2 Code");
                IF DimRec.FindFirst() then
                    Segment := DimRec.Name;
            end;
        }

    }
    trigger OnPreReport();
    begin
        CompInfoRec.GET;
        CompInfoRec.CALCFIELDS(Picture);

    end;

    var
        CompInfoRec: Record "Company Information";
        S_No: Integer;
        DimRec: Record "Dimension Value";
        Vessalname: Text;
        DivisionName: Text;
        Segment: Text;
}
