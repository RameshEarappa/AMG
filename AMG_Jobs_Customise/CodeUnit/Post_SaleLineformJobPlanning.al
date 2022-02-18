codeunit 50101 post_JobLine_SalesInvoic
{
    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, 1002, 'OnAfterCreateSalesLine', '', false, false)]
    procedure OnBeforeModifySalesLine(VAR SalesLine: Record "Sales Line";
                                            SalesHeader: Record "Sales Header";
                                            Job: Record Job;
                                            JobPlanningLine: Record "Job Planning Line")
    var
        SalesHeaderRecL: Record "Sales Header";
        SalesLineRec: Record "Sales Line";
    begin
        SalesLine.Validate("Line Number", JobPlanningLine."Line Number");
        SalesLine.Validate("Contract No", JobPlanningLine."Contract No");
        SalesLine.Validate("Cost of Revenue", JobPlanningLine."Cost of Revenue");
        SalesLine.Validate(Retention, JobPlanningLine.Retention);
        SalesLine."From Date" := JobPlanningLine."From Date";
        SalesLine."From Time" := JobPlanningLine."From Time";
        SalesLine."To Date" := JobPlanningLine."To Date";
        SalesLine."To Time" := JobPlanningLine."To Time";
        SalesLine.Modify();
        //LT
        SalesHeaderRecL.Get(SalesLine."Document Type", SalesLine."Document No.");
        SalesHeaderRecL."Dimension Set ID" := SalesLine."Dimension Set ID";
        SalesHeaderRecL."Shortcut Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
        SalesHeaderRecL."Shortcut Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
        SalesHeaderRecL.Modify();

        //LT
    End;


}