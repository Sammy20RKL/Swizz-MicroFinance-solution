page 70788 "Agent Picture"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = CardPart;
    SourceTable = Agents;

    layout
    {
        area(content)
        {
            field(Image; Rec.Image)
            {
                ApplicationArea = All;
                ShowCaption = false;
                ToolTip = 'Specifies the picture of the agent.';
                ShowMandatory = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(TakePicture)
            {
                ApplicationArea = All;
                Caption = 'Take';
                Image = Picture;
                Enabled = RecordIsOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Open camera on the device.';
                Visible = CameraAvailable;

                trigger OnAction()
                begin
                    TakeNewPicture();
                end;
            }
            action(ImportPicture)
            {
                ApplicationArea = All;
                Caption = 'Import';
                Image = Import;
                Enabled = RecordIsOpen;
                ToolTip = 'Import a picture file.';

                trigger OnAction()
                var
                    DialogTittle: Label 'Select The Picture File...';
                    FileName: Text;
                    InstreamFile: InStream;
                begin
                    Rec.TestField(Rec."No.");
                    if UploadIntoStream(DialogTittle, '', 'All Files (*.*)|*.*', FileName, InstreamFile) then begin
                        if Rec.Image.HasValue() then
                            if not Confirm(OverrideImageQst, false) then
                                exit;

                        Rec.Image.ImportStream(InstreamFile, FileName);
                        if not Rec.Modify(true) then
                            Rec.Insert(true);
                    end;
                end;
            }
            action(ExportFile)
            {
                ApplicationArea = All;
                Caption = 'Export';
                Enabled = DeleteExportEnabled and RecordIsOpen;
                Image = Export;
                ToolTip = 'Export the picture to a file.';

                trigger OnAction()
                var
                    TenantMedia: Record "Tenant Media";
                    FileName: Text;
                    InstreamPic: InStream;
                begin
                    Rec.TestField(Rec."No.");
                    if TenantMedia.Get(Rec.Image.MediaId) then begin
                        TenantMedia.CalcFields(TenantMedia.Content);
                        if TenantMedia.Content.HasValue then begin
                            FileName := StrSubstNo('%1.png', Rec."No.");
                            TenantMedia.Content.CreateInStream(InstreamPic, TextEncoding::UTF8);
                            DownloadFromStream(InstreamPic, '', '', '', FileName)
                        end;
                    end;
                end;
            }
            action(DeletePicture)
            {
                ApplicationArea = All;
                Caption = 'Delete';
                Enabled = DeleteExportEnabled and RecordIsOpen;
                Image = Delete;
                ToolTip = 'Delete Picture.';

                trigger OnAction()
                begin
                    Rec.TestField(Rec."No.");

                    if not Confirm(DeleteImageQst) then
                        exit;

                    Clear(Rec.Image);
                    Rec.Modify(true);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetEditableOnPictureActions();
        if Rec."Approval Status" = Rec."Approval Status"::Open then
            RecordIsOpen := true;
    end;

    trigger OnOpenPage()
    begin
        CameraAvailable := Camera.IsAvailable();
    end;

    var
        Camera: Codeunit Camera;
        RecordIsOpen: Boolean;
        CameraAvailable: Boolean;
        OverrideImageQst: Label 'The existing picture will be replaced. Do you want to continue?';
        DeleteImageQst: Label 'Are you sure you want to delete the picture?';
        DeleteExportEnabled: Boolean;
        MimeTypeTok: Label 'image/jpeg', Locked = true;

    procedure TakeNewPicture()
    var
        PictureInstream: InStream;
        PictureDescription: Text;
    begin
        Rec.TestField(Rec."No.");

        if Rec.Image.HasValue() then
            if not Confirm(OverrideImageQst) then
                exit;

        if Camera.GetPicture(PictureInstream, PictureDescription) then begin
            Rec.Image.ImportStream(PictureInstream, PictureDescription, MimeTypeTok);
            Rec.Modify(true)
        end;
    end;

    local procedure SetEditableOnPictureActions()
    begin
        DeleteExportEnabled := Rec.Image.HasValue;
    end;
}
