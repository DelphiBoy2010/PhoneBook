unit Asanyab.Tools;

interface

uses
  System.Classes;

type
  TTools = class(TObject)
  private const
    HTTPConnectTimeout = 30000;
    HTTPReadTimeout = 30000;
  private
    FCategory: string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure DownloadImageFromURL(aURL: string; var aMemory: TMemoryStream);
    /// <summary>
    /// Only works on Windows
    /// </summary>
    function CheckInternetConnection(aIP: string): Boolean;

    function CheckInternetConnectionAllPlatforms(aIP: string): Boolean;
  end;

var
  Tools: TTools = nil;

implementation

uses
  System.Net.HttpClientComponent, System.SysUtils, LoggerManager, IdIcmpClient,
  IdTCPClient;

{ TTools }

function TTools.CheckInternetConnection(aIP: string): Boolean;
const
  MethodName = 'CheckInternetConnection';
var
  IdIcmpClient1: TIdIcmpClient;
begin
  Result := False;
  IdIcmpClient1 := TIdIcmpClient.Create(nil);
  try
    try
      IdIcmpClient1.Host := aIP;
      IdIcmpClient1.Ping();
      Result := True;
    except
      on E: Exception do
      begin
        Logger.DoLog(ltError, ClassName + '.' + MethodName, FCategory,
          [E.Message]);
      end;
    end;
  finally
    FreeAndNil(IdIcmpClient1);
  end;
end;

function TTools.CheckInternetConnectionAllPlatforms(aIP: string): Boolean;
const
  MethodName = 'CheckInternetConnectionAllPlatforms';
var
  TCPClient: TIdTCPClient;
begin
  Result := False;
  Logger.DoLog(ltDebug, MethodName, FCategory, ['try to check internet connection']);
  TCPClient := TIdTCPClient.Create(nil);
  try
    try
      TCPClient.ReadTimeout := 2000;
      TCPClient.ConnectTimeout := 2000;
      TCPClient.Port := 80;
      TCPClient.Host := aIP;
      TCPClient.Connect;
      TCPClient.Disconnect;
      Result := True;
    except
      on E: Exception do
      begin
        Logger.DoLog(ltError, ClassName + '.' + MethodName, FCategory,
          [E.Message]);
      end;
    end;
  finally
    FreeAndNil(TCPClient);
  end;

end;

constructor TTools.Create;
begin
  FCategory := ClassName;
  Logger.AddCategory(FCategory);
end;

destructor TTools.Destroy;
begin

  inherited;
end;

procedure TTools.DownloadImageFromURL(aURL: string; var aMemory: TMemoryStream);
var
  HttpClient: TNetHTTPClient;
begin
  if not Trim(aURL).IsEmpty then
  begin
    HttpClient := TNetHTTPClient.Create(nil);
    try
      try
        if aMemory = nil then
        begin
          aMemory := TMemoryStream.Create;
        end;
        HttpClient.ConnectionTimeout := HTTPConnectTimeout;
        HttpClient.ResponseTimeout := HTTPReadTimeout;
        HttpClient.Get(aURL, aMemory);
        aMemory.Seek(0, soFromBeginning);
      except
        on E: Exception do
        begin
          FreeAndNil(aMemory);
          raise Exception.Create(E.Message);
        end;
      end;
    finally
      FreeAndNil(HttpClient);
    end;
  end
  else
  begin
    aMemory := nil;
  end;
end;

end.
