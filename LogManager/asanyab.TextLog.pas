unit asanyab.TextLog;

interface

uses
  System.SyncObjs, System.IOUtils;

type
  TTextLog = class(TObject)
  private
    FLogFileName: string;
    FFilePath: string;
    FCS: TCriticalSection;
    procedure SetLogFileName(const Value: string);
    procedure SetFilePath(const Value: string);
    procedure DoLog(aMessage: string);

  public
    constructor Create;
    destructor Destroy; override;

    procedure Error(aMessage: string);
    procedure Warning(aMessage: string);
    procedure Event(aMessage: string);
    procedure Debug(aMessage: string);
    procedure DebugDetail(aMessage: string);
    procedure DebugAll(aMessage: string);

    property LogFileName: string read FLogFileName write SetLogFileName;
    property FilePath: string read FFilePath write SetFilePath;
  end;

implementation

uses
  System.SysUtils, System.Classes;

{ TTextLog }

constructor TTextLog.Create;
begin
  FCS := TCriticalSection.Create;
end;

procedure TTextLog.Debug(aMessage: string);
begin
  DoLog('Debug:' + aMessage);
end;

procedure TTextLog.DebugAll(aMessage: string);
begin
  DoLog('All:' + aMessage);
end;

procedure TTextLog.DebugDetail(aMessage: string);
begin
  DoLog('Detail:' + aMessage);
end;

destructor TTextLog.Destroy;
begin
  FreeAndNil(FCS);
  inherited;
end;

procedure TTextLog.DoLog(aMessage: string);
var
  fs: TStreamWriter;
begin
  aMessage := DateTimeToStr(Now) + ':' + aMessage;
  FCS.Acquire;
  try
    if TFile.Exists(FilePath) then
    begin
      fs := TFile.AppendText(FilePath);
    end
    else
    begin
      fs := TFile.CreateText(FilePath);
    end;

    fs.WriteLine(aMessage);
  finally
    fs.Free;
    FCS.Release;
  end;
end;

procedure TTextLog.Error(aMessage: string);
begin
  DoLog('Error:' + aMessage);
end;

procedure TTextLog.Event(aMessage: string);
begin
  DoLog('Event:' + aMessage);
end;

procedure TTextLog.SetFilePath(const Value: string);
begin
  FFilePath := Value;
end;

procedure TTextLog.SetLogFileName(const Value: string);
begin
  FLogFileName := Value;
end;

procedure TTextLog.Warning(aMessage: string);
begin
  DoLog('Warning:' + aMessage);
end;

end.
