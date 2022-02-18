/*page 50179 "Test Cu"
{
    DelayedInsert = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    ShowFilter = false;
    Caption = 'Test page Ex';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            field(FromDate; FromDate)
            {
                Caption = 'From Date';
                ApplicationArea = ALL;

            }
            field(Todate; Todate)
            {
                Caption = 'To Date';
                ApplicationArea = all;
                trigger OnValidate()
                begin

                    TestCode.RunExcel(FromDate, Todate);
                    CurrPage.CLOSE
                end;
            }
        }
    }

    actions
    {
    }

    var
        FromDate: Date;
        Todate: Date;
        TestCode: Codeunit TestCde;
}

*/