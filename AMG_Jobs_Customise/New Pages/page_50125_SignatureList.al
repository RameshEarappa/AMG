page 50125 SignatureList
{
    Caption = 'Signature List';
    PageType = List;
    SourceTable = SignatureTable;
    CardPageId = SignatureCrd;
    ApplicationArea = all;
    UsageCategory = Lists;


    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = all;
                }
                field(image; Rec.image)
                {
                    Caption = 'Signature';
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }

    actions
    {
    }
}

