unit LogLevelForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, LoggerManager;

type
  TfrmLogLevel = class(TForm)
    rgLevel: TRadioGroup;
    pnlButtons: TPanel;
    btnOk: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Category: string;
    LogType: TLogType;
  end;

var
  frmLogLevel: TfrmLogLevel;

implementation

uses
  System.TypInfo;

{$R *.dfm}

procedure TfrmLogLevel.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  Self.Close;
end;

procedure TfrmLogLevel.btnOkClick(Sender: TObject);
begin
  LogType := TLogType(rgLevel.ItemIndex);
  ModalResult := mrOk;
end;

procedure TfrmLogLevel.FormCreate(Sender: TObject);
var
  Elm: TLogType;
begin
  pnlButtons.ShowCaption := False;
  Category := '';
  LogType := ltEvent;

  for Elm := Low(TLogType) to High(TLogType) do
  begin
    rgLevel.Items.Add(GetEnumName(TypeInfo(TLogType),Integer(Elm)));
  end;
end;

procedure TfrmLogLevel.FormShow(Sender: TObject);
begin
  rgLevel.Caption := Category;
  rgLevel.ItemIndex := Integer(LogType);
end;

end.
