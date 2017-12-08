unit DAL.DataManager;

interface

uses BaseClass, DAL.Profiles, LoggerManager;

type
  TDataManager = class(TBaseClass)
  private
    function GetParamValue(aData, aTag: string): string;
  public
    constructor Create; override;
    destructor Destroy; override;

    function SaveProfileData(aFirstName, aLastName, aPhoneNumber,
      aCity, aAddress: string; var aResultMessage: string): Boolean;

    function LoadProfileData(var aFirstName, aLastName, aPhoneNumber,
      aCity, aAddress, aComment, aProblemType: string; var aResultMessage: string): Boolean;
  end;
var
  DataManager: TDataManager = nil;

implementation
uses
  System.SysUtils;

{ TDataManager }

constructor TDataManager.Create;
begin
  inherited;

end;

destructor TDataManager.Destroy;
begin
  inherited;
end;

function TDataManager.GetParamValue(aData, aTag: string): string;
var
  Pos1, Pos2: Integer;
begin
  Pos1 := aData.IndexOf(aTag) + aTag.Length;
  Pos2 := aData.IndexOf('&', Pos1);
  Result := Copy(aData, Pos1 + 1, Pos2 - Pos1);
end;

function TDataManager.LoadProfileData(var aFirstName, aLastName,
  aPhoneNumber, aCity, aAddress, aComment, aProblemType,
  aResultMessage: string): Boolean;
const
  MethodName = 'LoadProfileData';
var
  Profile: TProfile;
begin
  Result := False;
  Profile := TProfile.Create;
  try
    try
      Profile.LoadData;
      aFirstName := Profile.FirstName;
      aLastName := Profile.LastName;
      aPhoneNumber := Profile.PhoneNumber;
      aCity := Profile.City;
      aAddress := Profile.Address;
      Result := True;
    except
      on E: Exception do
      begin
        Logger.DoLog(ltError, ClassName + '.' + MethodName, FCategory, [E.Message]);
      end;
    end;
  finally
    FreeAndNil(Profile);
  end;
end;

function TDataManager.SaveProfileData(aFirstName, aLastName,
  aPhoneNumber, aCity, aAddress: string; var aResultMessage: string): Boolean;
const
  MethodName = 'SaveProfileData';
var
  Profile: TProfile;
begin
  Result := False;
  Profile := TProfile.Create;
  try
    try
      Profile.FirstName := aFirstName;
      Profile.LastName := aLastName;
      Profile.PhoneNumber := aPhoneNumber;
      Profile.City := aCity;
      Profile.Address := aAddress;
      Profile.SaveData;
      aResultMessage := 'ثبت شد';
      Result := True;
    except
      on E: Exception do
      begin
        Logger.DoLog(ltError, ClassName + '.' + MethodName, FCategory, [E.Message]);
      end;
    end;
  finally
    FreeAndNil(Profile);
  end;
end;


end.
