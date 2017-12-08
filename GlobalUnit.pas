unit GlobalUnit;

interface
type
  TGlobal = class(TObject)
  const
    DeveloperID = '';
    MainPackageName = 'com.asanyab';
    ServerAppName = 'asan';
    ClientAppName = 'phonebook';
    LockKeyRegistery = '';
    RegistryKeyName = '';
    TrialDays = 30;
    LogFolder = '.\Log';
    ServerTitle = 'دفترچه';
    ClientTitle = 'تلفن';
    HashCode = '';
    ConfigHashCode = '';
    DataBaseName = 'PhoneBook_DB';
    MenuGroupsTitle = '';
    SiteURL = 'http://www.asanyab.org'; //Our company site, show in about us
    AppURL = '';
    OwnerTitle = 'گروه نرم افزاری آسان یاب';
    WelcomeURL = '';
    HTMLPath = '';

  private
    FCategory: string;
    FLastReportDate: string;

  public
    AllowBuyPackage: Boolean;
    constructor Create;
    destructor Destroy; override;

    function GetDatabaseName: string;
    function GetPackageName: string;
    function GetWelcomeURL: string;
    function GetHTMLPath: string;
    function GetPublicPath: string;
  end;

var
  Global: TGlobal = nil;

implementation

uses
  System.IOUtils, System.SysUtils;

{ TGlobal }
constructor TGlobal.Create;
begin
  AllowBuyPackage := False;
end;

destructor TGlobal.Destroy;
begin

  inherited;
end;

function TGlobal.GetDatabaseName: string;
begin
  Result := DataBaseName + '.db';
end;

function TGlobal.GetHTMLPath: string;
begin
  {$IFDEF MSWindows}
  Result := '..\' + HTMLPath;
  {$ENDIF}

  {$IFDEF Android}
  Result := TPath.GetHomePath +   TPath.DirectorySeparatorChar + HTMLPath;
  {$ENDIF}
end;

function TGlobal.GetPackageName: string;
begin
  Result := MainPackageName + '.' + ServerAppName + '_' + ClientAppName;
end;

function TGlobal.GetPublicPath: string;
begin
  {$IFDEF MSWindows}
  //Result := ExtractFilePath()
  {$ENDIF}

  {$IFDEF Android}
  Result := TPath.GetPublicPath + TPath.DirectorySeparatorChar;
  {$ENDIF}
end;
function TGlobal.GetWelcomeURL: string;
begin
  Result := 'http://asanyab.org/';
end;

end.
