unit DataModule;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait,
  Data.DB, FireDAC.Comp.Client, GlobalUnit, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteDef, FireDAC.Phys.SQLite, System.IOUtils;

type
  TDataModule1 = class(TDataModule)
    FDConnection1: TFDConnection;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    FCategory: string;
  public
    { Public declarations }
    function ConnectDB: Boolean;
    function IsConnected: Boolean;
  end;

var
  DataModule1: TDataModule1;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses LoggerManager;

{$R *.dfm}

{ TDataModule1 }

function TDataModule1.ConnectDB: Boolean;
const
  MethodName = 'ConnectDB';
var
  FullPath: string;
  DBName: string;
begin
  Result := False;
  try
    DBName := Global.GetDataBaseName;
    {$IFDEF Android}
    FullPath := TPath.Combine(TPath.GetHomePath, DBName); //.\assets\internal\
    //Use shared document path for database
    //FullPath := TPath.Combine(TPath.GetPublicPath, DBName);//.\assets\
    {$ENDIF}
    {$IFDEF MSWINDOWS}
    FullPath := '..\' + DBName;
    {$ENDIF}
    if FileExists(FullPath) then
    begin
      //http://docwiki.embarcadero.com/RADStudio/Tokyo/en/Using_SQLite_with_FireDAC
      //Set LockingMode to Normal to enable shared DB access.
      //Set Synchronous to Normal or Full to make committed data visible to others.
      //Set UpdateOptions.LockWait to True to enable waiting for locks.
      //Increase BusyTimeout to raise a lock waiting time.
      //Consider to set JournalMode to WAL.
      //Also set SharedCache to False to minimize locking conflicts.
      //Set Synchronous to Full to protect the DB from the committed data losses
      FDConnection1.Close;
      FDConnection1.LoginPrompt := False;
      FDConnection1.Params.Clear;
      FDConnection1.Params.Add('DriverID=SQLite');
      FDConnection1.Params.Add('Database='+ FullPath);
//      FDConnection1.Params.Add('LockingMode=Normal');
//      FDConnection1.Params.Add('Synchronous=Normal');
//      FDConnection1.Params.Add('SharedCache=False');
      FDConnection1.Open;
      Result := True;
    end
    else
    begin
      //MessageDlg('File not exists in ' + FullPath, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
      Logger.DoLog(ltWarning, MethodName, FCategory, ['File not exists in ', FullPath]);
    end;
  except
    on E: Exception do
    begin
      //ShowMessage(E.Message);
      Logger.DoLog(ltWarning, MethodName, FCategory, [E.Message]);
    end;
  end;

end;

procedure TDataModule1.DataModuleCreate(Sender: TObject);
begin
  FCategory := ClassName;
  Logger.AddCategory(FCategory);
end;

function TDataModule1.IsConnected: Boolean;
begin
  Result := FDConnection1.Connected;
end;

end.
