codeunit 50102 "Single Instant Codeunit"
{
    SingleInstance = true;

    trigger OnRun()
    begin


    end;

    procedure SetJobNo(JobNoP: Code[20])
    begin
        JobNo := JobNoP;
    end;

    procedure SetJobTaskNo(JobTaskNoP: Code[20])
    begin
        JobTaskNo := JobTaskNoP;
    end;

    procedure GetJobNO(): Code[20]
    Begin
        exit(JobNo);
    End;

    procedure GetJobTaskNO(): Code[20]
    Begin
        exit(JobTaskNo);
    End;

    var
        JobNo: Code[20];
        JobTaskNo: Code[20];
}