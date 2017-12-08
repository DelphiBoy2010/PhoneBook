unit DAL.Profiles;

interface

uses BaseClass;

type
  TProfile = class(TBaseClass)
  private
    FPhoneNumber: string;
    FLastName: string;
    FFirstName: string;
    FProblemType: string;
    FAddress: string;
    FCity: string;
    FComments: string;
    procedure SetFirstName(const Value: string);
    procedure SetLastName(const Value: string);
    procedure SetPhoneNumber(const Value: string);
    procedure SetAddress(const Value: string);
    procedure SetCity(const Value: string);
  public
    constructor Create; override;
    destructor Destroy; override;

    {Methods}
    function SaveData(aData: string): Boolean; overload;
    function SaveData: Boolean; overload;
    function LoadData(var aData: string): Boolean; overload;
    function LoadData: Boolean; overload;

    {Properties}
    property FirstName: string read FFirstName write SetFirstName;
    property LastName: string read FLastName write SetLastName;
    property PhoneNumber: string read FPhoneNumber write SetPhoneNumber;
    property City: string read FCity write SetCity;
    property Address: string read FAddress write SetAddress;
  end;

implementation

uses
  System.SysUtils, LoggerManager, FireDAC.Comp.Client, DataModule;

{ TProfile }

constructor TProfile.Create;
begin
  inherited;

end;

destructor TProfile.Destroy;
begin

  inherited;
end;

function TProfile.LoadData: Boolean;
const
  MethodName = 'LoadData';
var
  qry: TFDQuery;
begin
  Result := False;
  if DataModule1.ConnectDB then
  begin
    qry := TFDQuery.Create(nil);
    try
      try
        qry.Connection := DataModule1.FDConnection1;
        qry.SQL.Text := 'Select * From tbl_Profiles';
        qry.Open();
        if qry.IsEmpty then
        begin
          //
        end
        else
        begin
          FFirstName := qry.FieldByName('FirstName').AsString;
          FLastName := qry.FieldByName('LastName').AsString;
          FPhoneNumber := qry.FieldByName('PhoneNumber').AsString;
          FCity := qry.FieldByName('City').AsString;
          FAddress := qry.FieldByName('Address').AsString;
          Result := True;
        end;
        qry.Close;
      except
        on E: Exception do
        begin
          Logger.DoLog(ltError, ClassName + '.' + MethodName, FCategory, [E.Message]);
        end;
      end;
    finally
      FreeAndNil(qry);
    end;
  end
  else
  begin
    Logger.DoLog(ltWarning, ClassName + '.' + MethodName, FCategory, ['DB connection is close']);
  end;

end;

function TProfile.LoadData(var aData: string): Boolean;
const
  MethodName = 'LoadData';
var
  qry: TFDQuery;
begin
  Result := False;
  if DataModule1.ConnectDB then
  begin
    qry := TFDQuery.Create(nil);
    try
      try
        qry.SQL.Text := 'Select * From tbl_Profiles';
        qry.Open();
        if qry.IsEmpty then
        begin
          aData := '';
        end
        else
        begin
          aData := qry.FieldByName('Data').AsString;
        end;
        qry.Close;
        Result := True;
      except
        on E: Exception do
        begin
          Logger.DoLog(ltError, ClassName + '.' + MethodName, FCategory, [E.Message]);
        end;
      end;
    finally
      FreeAndNil(qry);
    end;
  end
  else
  begin
    Logger.DoLog(ltWarning, ClassName + '.' + MethodName, FCategory, ['DB connection is close']);
  end;
end;

function TProfile.SaveData(aData: string): Boolean;
const
  MethodName = 'SaveData';
var
  qry: TFDQuery;
begin
  Result := False;
  if DataModule1.ConnectDB then
  begin
    qry := TFDQuery.Create(nil);
    try
      try
        qry.Connection := DataModule1.FDConnection1;
        qry.SQL.Text := 'Select * From tbl_Profiles';
        qry.Open();
        if qry.IsEmpty then
        begin
          qry.Insert;
        end
        else
        begin
          qry.Edit;
        end;
        qry.FieldByName('Data').AsString := aData;
        qry.Post;

        Result := True;
      except
        on E: Exception do
        begin
          Logger.DoLog(ltError, ClassName + '.' + MethodName, FCategory, [E.Message]);
        end;
      end;
    finally
      FreeAndNil(qry);
    end;
  end
  else
  begin
    Logger.DoLog(ltWarning, ClassName + '.' + MethodName, FCategory, ['DB connection is close']);
  end;
end;

function TProfile.SaveData: Boolean;
const
  MethodName = 'SaveData';
var
  qry: TFDQuery;
begin
  Result := False;
  if DataModule1.ConnectDB then
  begin
    qry := TFDQuery.Create(nil);
    try
      try
        qry.Connection := DataModule1.FDConnection1;
        qry.SQL.Text := 'Select * From tbl_Profiles';
        qry.Open();
        if qry.IsEmpty then
        begin
          qry.Insert;
        end
        else
        begin
          qry.Edit;
        end;

        qry.FieldByName('FirstName').AsString := FFirstName;
        qry.FieldByName('LastName').AsString := FLastName;
        qry.FieldByName('PhoneNumber').AsString := FPhoneNumber;
        qry.FieldByName('City').AsString := FCity;
        qry.FieldByName('Address').AsString := FAddress;
        qry.Post;

        Result := True;
      except
        on E: Exception do
        begin
          Logger.DoLog(ltError, ClassName + '.' + MethodName, FCategory, [E.Message]);
        end;
      end;
    finally
      FreeAndNil(qry);
    end;
  end
  else
  begin
    Logger.DoLog(ltWarning, ClassName + '.' + MethodName, FCategory, ['DB connection is close']);
  end;
end;

procedure TProfile.SetAddress(const Value: string);
begin
  FAddress := Value;
end;

procedure TProfile.SetCity(const Value: string);
begin
  FCity := Value;
end;

procedure TProfile.SetFirstName(const Value: string);
begin
  FFirstName := Value;
end;

procedure TProfile.SetLastName(const Value: string);
begin
  FLastName := Value;
end;

procedure TProfile.SetPhoneNumber(const Value: string);
begin
  FPhoneNumber := Value;
end;

end.
