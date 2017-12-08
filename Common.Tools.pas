unit Common.Tools;

interface
type
  TCommonTools = class(TObject)
  private
    FCategory: string;
    FApplicationPath: string;

    function GetApplicationPath: string;
  public
    constructor Create();
    destructor Destroy; override;

    property ApplicationPath: string read GetApplicationPath;
  end;
implementation

uses
  System.SysUtils, LoggerManager, System.IOUtils;

{ TCommonTools }

constructor TCommonTools.Create();
begin
  FCategory := ClassName;
  Logger.AddCategory(FCategory);

end;

destructor TCommonTools.Destroy;
begin

  inherited;
end;

function TCommonTools.GetApplicationPath: string;
const
  MethodName = 'GetApplicationPath';
begin
  {$IFDEF Android}
  FApplicationPath := TPath.GetHomePath;
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  FApplicationPath := ExtractFilePath(ParamStr(0));
  {$ENDIF}
  Result := FApplicationPath;

end;

end.
