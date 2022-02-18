page 50126 SignatureCrd
{
    Caption = 'Signature';
    PageType = Card;
    SourceTable = SignatureTable;

    layout
    {
        area(content)
        {
            group(General)
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

