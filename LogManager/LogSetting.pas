unit LogSetting;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls;

type
  TfrmLogSetting = class(TForm)
    CategoryListGrid: TStringGrid;
    procedure CategoryListGridDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogSetting: TfrmLogSetting;

implementation

{$R *.dfm}

uses LoggerManager, LogLevelForm;

procedure TfrmLogSetting.CategoryListGridDblClick(Sender: TObject);
const
  MethodName = 'CategoryListGridDblClick';
begin
  try
    frmLogLevel.LogType := TLogType(StrToInt(CategoryListGrid.Cells[CategoryListGrid.Col + 1, CategoryListGrid.Row]));
    frmLogLevel.Category := CategoryListGrid.Cells[CategoryListGrid.Col, CategoryListGrid.Row];
    if frmLogLevel.ShowModal = mrOk then
    begin
      Logger.SetCategoryLevel(frmLogLevel.Category, frmLogLevel.LogType);
      CategoryListGrid.Cells[CategoryListGrid.Col + 1,CategoryListGrid.Row] := IntToStr(Integer(frmLogLevel.LogType));
    end;
  except
    on E: Exception do
      Logger.DoLog(ltError, ClassName + '.' + MethodName, 'Log', [E.Message]);
  end;
end;

procedure TfrmLogSetting.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Logger.SaveSettings;
end;

procedure TfrmLogSetting.FormShow(Sender: TObject);
const
  MethodName = 'FormShow';
var
  CategoryList: TList;
  MyElem: Pointer;
  I: Integer;
begin
  CategoryList := Logger.GetCategoryList;
  try
  I := 0;
  if Assigned(CategoryList) then
  begin
    CategoryListGrid.RowCount := CategoryList.Count;
    CategoryListGrid.ColWidths[1] := 200;
    for MyElem in CategoryList do
    begin
      CategoryListGrid.Cells[1, I] := TLogCategory(MyElem).Name;
      CategoryListGrid.Cells[2, I] := IntToStr(Integer(TLogCategory(MyElem).LogType));
      Inc(I);
    end;
  end;
  except
    on E: Exception do
      Logger.DoLog(ltError, ClassName + '.' + MethodName, 'Log', [E.Message]);
  end;
end;

end.
