unit LoggerManager;
{version 1.1
LastModify: 28/07/2017
*Change for FMX
*Change for console}
interface
{$Define FMX}
//{$Define VCL}
//{$Define Service}
{$IFDEF MSWindows}
  //{$Define TacLog}
{$ENDIF}
{$Define TextLog}
uses
  {$IFDEF CodeSiteLogging}
  CodeSiteLogging,
  {$ENDIF}
  Classes, SyncObjs,
  System.IniFiles
  {$IFDEF TacLog}
  ,untLogsubSystem
  {$ENDIF}
  ,System.Generics.Collections
  {$IFDEF TextLog}
  ,asanyab.TextLog
  {$ENDIF}
  ;

type
  TOnLog = procedure(aData: string; aShowType: string) of object;
  TOnShowMessageToUser = procedure(aMessage: string) of object;
  TLogType = (ltError, ltWarning, ltEvent, ltDebug, ltDebugDetails, ltAll);

  TLogCategory = class(TObject)
  private
    FName: string;
    FLogType: TLogType;
    {$IFDEF TacLog}
    FTacLogTopic: TLogTopic;
    {$ENDIF}
    procedure SetLogType(const Value: TLogType);
  public
    constructor Create(aName: string; aLogType: TLogType = ltEvent);
    property LogType: TLogType read FLogType write SetLogType;
    property Name: string read FName;
    {$IFDEF TacLog}
    property TacLogTopic: TLogTopic read FTacLogTopic;
    {$ENDIF}
  end;

  TLogger = class(TObject)
  private
    FOnLog: TOnLog;
    //FCategoryList: TList;
    FCategoryList: TList<TLogCategory>;
    FCS: TCriticalSection;
    FOnShowMessageToUser: TOnShowMessageToUser;
    FLastLogDate: TDate;
    FLogFileName: string;
    FConfigFile: TIniFile;
    FComputerName: string;
    FShowErrorMessage: Boolean;
    FCategory: string;
    procedure SetOnLog(const Value: TOnLog);
    procedure SetOnShowMessageToUser(const Value: TOnShowMessageToUser);
    procedure SetComputerName(const Value: string);
    procedure SetShowErrorMessage(const Value: Boolean);
  protected
    {$IFDEF CodeSiteLogging}
    FCodeSite: TCodeSiteLogger;
    FLogDest: TCodeSiteDestination;
    {$ENDIF}
    {$IFDEF TacLog}
    FTacLog: TLogTopic;
    {$ENDIF}
    {$IFDEF TextLog}
    FTextLog: TTextLog;
    {$ENDIF}
    function VarRecToStr(AVarRec: TVarRec): string;
    function VarArrayToStr(AVarArray: array of const ): string;
    function FindCategory(aCategoryName: string): TLogCategory;
    function CheckCategoryLogMode(aCategory: string; aLogType: TLogType)
      : Boolean;
    procedure LoadCategoryLevels;
    function CreateLogFile: Boolean;
    {$IFDEF TacLog}
    function GetTacLogLevel(aLogType: TLogType): Integer;
    {$ENDIF}
    function GetCurrentComputerName: string;
    function GetApplicationPath: string;
    function GetOSVersion: string;
  public
    constructor Create(aLogFileName: string = ''; aSubsystem: string = 'Global');
    destructor Destroy; override;
    procedure DoLog(aLogType: TLogType; aMethodName: string; aCategory: string;
      args: array of const; aContextID: Integer = 0);
    procedure AddCategory(aCategoty: string; aLogType: TLogType = ltEvent);
    procedure SetCategoryLevel(aCategory: string; aLevel: TLogType);
    Procedure SetAllCategoryLevels(aLevel: TLogType);
    function GetCategoryList: TList<TLogCategory>;
    procedure SaveSettings;
    procedure LoadSettings;
    procedure ShowMessageToUser(aMessage: string);
    procedure LogSystemInfo;

    property OnLog: TOnLog read FOnLog write SetOnLog;
    property OnShowMessageToUser: TOnShowMessageToUser read FOnShowMessageToUser write SetOnShowMessageToUser;
    property ComputerName: string read FComputerName;
    property ShowErrorMessage: Boolean read FShowErrorMessage write SetShowErrorMessage default False;
  end;

var
  Logger: TLogger = nil;

implementation

uses
  SysUtils, KADSolarUtl{$IFDEF TacLog},untLog{$ENDIF}
  {$IFDEF FMX},FMX.Dialogs, FMX.Forms, FMX.Platform{$ENDIF}
  {$IFDEF MSWINDOWS}, Winapi.Windows{$ENDIF}, System.IOUtils, System.UITypes
  {$IFDEF Android},Android.Tools,Androidapi.Helpers,Androidapi.JNI.Os{$ENDIF};
{ TLogger }

procedure TLogger.AddCategory(aCategoty: string; aLogType: TLogType);
var
  Categoty: TLogCategory;
begin
  FCS.Acquire;
  try
    if not Assigned(FindCategory(aCategoty)) then
    begin
      Categoty := TLogCategory.Create(aCategoty, aLogType);
      {$IFDEF TacLog}
      Categoty.FTacLogTopic := LogManager.DefaultSubSystem.AddTopic(aCategoty);
      {$ENDIF}
      FCategoryList.Add(Categoty);
    end;
  finally
    FCS.Release;
  end;
end;

function TLogger.CheckCategoryLogMode(aCategory: string; aLogType: TLogType)
  : Boolean;
var
  LogCategory: TLogCategory;
begin
  Result := False;
  try
    LogCategory := FindCategory(aCategory);
    if Assigned(LogCategory) then
    begin
      if LogCategory.FLogType >= aLogType then
      begin
        Result := True;
      end
      else
      begin
        Result := False;
      end;
    end;
  except
    on E: Exception do
{$IFDEF CodeSiteLogging}
      FCodeSite.SendError('TLogger.CheckCategoryLogMode:' + E.Message);
{$ENDIF}
  end;
end;

constructor TLogger.Create(aLogFileName: string; aSubsystem: string);
begin
  FCS := TCriticalSection.Create;
  FCategoryList := TList<TLogCategory>.Create;
  FCategory := ClassName;
  AddCategory(FCategory);
  FLogFileName := 'LogFile.log';
  {$IFDEF CodeSiteLogging}
  FLogFileName := 'LogFile.csl';
  {$ENDIF}
  {$IFDEF TextLog}
  FLogFileName := 'LogFile.txt';
  {$ENDIF}
  if aLogFileName <> '' then
    FLogFileName := aLogFileName;

  {$IFDEF TacLog}
  LogManager.AddSubSystem(aSubsystem);
  FTacLog := LogManager.DefaultSubSystem.AddTopic('Default');
  {$ENDIF};

  {$IFDEF CodeSiteLogging}
  FCodeSite := TCodeSiteLogger.Create(nil);
  FLogDest := TCodeSiteDestination.Create(nil);
  FLogDest.LogFile.Active := True;
  FLogDest.LogFile.FileName := FLogFileName;
  FCodeSite.Destination := FLogDest;
  { TODO -oOwner -cGeneral : Log system info }
  {$ENDIF}
  {$IFDEF TextLog}
  FTextLog := TTextLog.Create;
  FTextLog.LogFileName := FLogFileName;
  {$ENDIF}
  FConfigFile := TIniFile.Create(GetApplicationPath + 'Config.ini');
  LoadSettings;
  FComputerName := GetCurrentComputerName;
end;

function TLogger.CreateLogFile: Boolean;
var
  FilePath, FullPath: string;
  Age: Integer;
  FileDate: TDateTime;
begin
  Result := False;
  //FilePath := ExtractFilePath(Application.ExeName) + 'Log\'
  FilePath := GetApplicationPath + 'Log' + PathDelim
    + TSolar.GetEnglishDayName(DayOfWeek(Now));
  FullPath := FilePath + PathDelim + FLogFileName;
  try
    if not DirectoryExists(FilePath) then
    begin
      ForceDirectories(FilePath);
    end
    else
    begin
      if FileExists(FullPath) then
      begin
        FileAge(FullPath, FileDate);
        if FileDate < Date then
        begin
          //Delete last file
          //System.SysUtils.DeleteFile(FullPath);
          TFile.Delete(FullPath);
        end;
      end;
    end;
    Result := True;
  {$IFDEF CodeSiteLogging}
    FLogDest.LogFile.FilePath := FilePath;
  {$ENDIF}
  {$IFDEF TextLog}
    FTextLog.FilePath := FullPath;
  {$ENDIF}
  except
    on E: Exception do
    begin
{$IFDEF CodeSiteLogging}
      FCodeSite.SendError('TLogger.CreateLogFile:' + E.Message);
{$ENDIF}
    end;
  end;
end;

destructor TLogger.Destroy;
begin
  {$IFDEF TextLog}
  FreeAndNil(FTextLog);
  {$ENDIF}
{$IFDEF CodeSiteLogging}
  FreeAndNil(FLogDest);
  FreeAndNil(FCodeSite);
{$ENDIF}
  FreeAndNil(FCategoryList);
  FreeAndNil(FConfigFile);
  FreeAndNil(FCS);
  inherited;
end;

procedure TLogger.DoLog(aLogType: TLogType; aMethodName: string;
  aCategory: string; args: array of const; aContextID: Integer);
var
  I: Integer;
  LogMessage: string;
  Categoty: TLogCategory;
  {$IFDEF TacLog}
  TacLog: TLogTopic;
  {$ENDIF}
begin
  //FCS.Acquire;
  try
    if CheckCategoryLogMode(aCategory, aLogType) then
    begin
      if FLastLogDate <> Date then
      begin
        CreateLogFile;
      end;
      FLastLogDate := Date;
      LogMessage := aMethodName + ': ' + VarArrayToStr(args);
      {$IFDEF CodeSiteLogging}
      FCodeSite.Category := aCategory;
      {$ENDIF}
      {$IFDEF TacLog}
      Categoty := FindCategory(aCategory);
      if Assigned(Categoty) then
      begin
        TacLog := Categoty.FTacLogTopic;
      end
      else
      begin
        TacLog := FTacLog;
      end;
      {$ENDIF}
      case aLogType of
        ltError:
          begin
            {$IFDEF CodeSiteLogging}
            FCodeSite.SendError(LogMessage);
            {$ENDIF}
            {$IFDEF TacLog}
            TacLog.Error(0, aContextID, [LogMessage]);
            {$ENDIF}
            {$IFDEF TextLog}
            FTextLog.Error(LogMessage);
            {$ENDIF}
            if ShowErrorMessage then
            begin
              {$IFNDEF Service}
              MessageDlg(LogMessage, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
              {$ENDIF}
            end;
          end;
        ltWarning:
          begin
            {$IFDEF CodeSiteLogging}
            FCodeSite.SendWarning(LogMessage);
            {$ENDIF}
            {$IFDEF TacLog}
            TacLog.Warning(0, aContextID, [LogMessage]);
            {$ENDIF}
            {$IFDEF TextLog}
            FTextLog.Warning(LogMessage);
            {$ENDIF}
          end;
        ltEvent:
          begin
            {$IFDEF CodeSiteLogging}
            FCodeSite.Send(LogMessage);
            {$ENDIF}
            {$IFDEF TacLog}
            TacLog.Event(0, aContextID, [LogMessage]);
            {$ENDIF}
            {$IFDEF TextLog}
            FTextLog.Event(LogMessage);
            {$ENDIF}
          end;
        ltDebug:
          begin
            {$IFDEF CodeSiteLogging}
            FCodeSite.Send(LogMessage);
            {$ENDIF}
            {$IFDEF TacLog}
            TacLog.Debug(0, aContextID, [LogMessage]);
            {$ENDIF}
            {$IFDEF TextLog}
            FTextLog.Debug(LogMessage);
            {$ENDIF}
          end;
        ltDebugDetails:
          begin
            {$IFDEF CodeSiteLogging}
            FCodeSite.Send(LogMessage);
            {$ENDIF}
            {$IFDEF TacLog}
            TacLog.DebugDetailed(0, aContextID, [LogMessage]);
            {$ENDIF}
            {$IFDEF TextLog}
            FTextLog.DebugDetail(LogMessage);
            {$ENDIF}
          end;
        ltAll:
          begin
            {$IFDEF CodeSiteLogging}
            FCodeSite.Send(LogMessage);
            {$ENDIF}
            {$IFDEF TacLog}
            TacLog.DebugAll(aContextID, [LogMessage]);
            {$ENDIF}
            {$IFDEF TextLog}
            FTextLog.DebugAll(LogMessage);
            {$ENDIF}
          end;
      end;
      if Assigned(OnLog) then
        OnLog(LogMessage, 'ToDeveloper');
    end;
  finally
    //FCS.Release;
  end;

end;

function TLogger.FindCategory(aCategoryName: string): TLogCategory;
var
  MyElem: Pointer;
  I: Integer;
  Category: TLogCategory;
begin
  Result := nil;
  FCS.Acquire;
  try
    try
      for MyElem in FCategoryList do
      begin
        if TLogCategory(MyElem).FName = aCategoryName then
        begin
          Result := TLogCategory(MyElem);
          Break;
        end;
      end;
//      for I := 0 to FCategoryList.Count - 1 do
//      begin
//        Category := FCategoryList[I];
//        if Category.FName = aCategoryName then
//        begin
//          Result := Category;
//          Break;
//        end;
//      end;
    except
      on E: Exception do
      begin
        {$IFDEF CodeSiteLogging}
        FCodeSite.SendError('TLogger.FindCategory:' + E.Message);
        {$ENDIF}
        {$IFDEF TacLog}

        {$ENDIF}
      end;
    end;
  finally
    FCS.Release;
  end;
end;

function TLogger.GetApplicationPath: string;
begin
  Result := '';
  {$IFDEF MSWINDOWS}
  Result := ExtractFilePath(ParamStr(0)) + PathDelim;
  {$ENDIF}
  {$IFDEF Android}
  //Result := TPath.GetHomePath + PathDelim;
  Result := TPath.GetPublicPath + PathDelim;
  {$ENDIF}
end;

function TLogger.GetCategoryList: TList<TLogCategory>;
begin
  FCS.Acquire;
  try
    Result := FCategoryList;
  finally
    FCS.Release;
  end;
end;

function TLogger.GetCurrentComputerName: string;
//var
//  ComputerName: Array [0 .. 256] of char;
//  Size: DWORD;
begin
//  Size := 256;
//  GetComputerName(ComputerName, Size);
//  Result := ComputerName;
   Result := GetEnvironmentVariable('COMPUTERNAME');
end;

function TLogger.GetOSVersion: string;
var
  OSVersion: TOSVersion;
  OSLang: String;
  LocaleService: IFMXLocaleService;
  ModelName: String;
begin
  Result := '';
  ModelName := 'unknown';
{$IFDEF Android}
  ModelName := JStringToString(TJBuild.JavaClass.MODEL);
{$ENDIF}
{$IFDEF IOS}
  ModelName := GetDeviceModelString;
{$ENDIF}

  Result := Result + ',' + Format('ModelName=%s', [ ModelName ] );
  Result := Result + ',' + Format('OSName=%s', [OSVersion.Name]);
  Result := Result + ',' + Format('Platform=%d', [Ord(OSVersion.Platform)]);
  Result := Result + ',' + Format('Version=%d.%d', [OSVersion.Major,OSVersion.Minor]);

  OSLang := '';
  if TPlatformServices.Current.SupportsPlatformService(IFMXLocaleService, IInterface(LocaleService)) then
  begin
    OSLang := LocaleService.GetCurrentLangID();
    Result := Result + ',' + Format('Lang=%s', [OSLang]);
  end;
end;

{$IFDEF TacLog}
function TLogger.GetTacLogLevel(aLogType: TLogType): Integer;
begin
  Result := 60;
  case aLogType of
    ltError: Result := 10;
    ltWarning: Result := 20;
    ltEvent: Result := 60;
    ltDebug: Result := 80;
    ltDebugDetails: Result := 99;
    ltAll: Result := 100;
  end;
end;
{$ENDIF}

procedure TLogger.LoadCategoryLevels;
begin

end;

procedure TLogger.LoadSettings;
var
  CategoryName: string;
  CategoryLevel: Integer;
  MyElem: Pointer;
  Values: TStringList;
  I: Integer;
begin
  //FDatabaseConfig.DBName := FConfigFile.ReadString('Database', 'Name', 'SMSManager');
  FCS.Acquire;
  Values := TStringList.Create;
  try
    try
      FConfigFile.ReadSection('Log', Values);
      for I := 0 to Values.Count - 1 do
      begin
         CategoryName := Values[I];
         CategoryLevel := FConfigFile.ReadInteger('Log', CategoryName, 2);
         AddCategory(CategoryName, TLogType(CategoryLevel));
      end;
    except
      on E: Exception do
      begin
{$IFDEF CodeSiteLogging}
        FCodeSite.SendError('TLogger.FindCategory:' + E.Message);
{$ENDIF}
      end;
    end;
  finally
    FreeAndNil(Values);
    FCS.Release;
  end;
end;

procedure TLogger.LogSystemInfo;
var
  Data: string;
begin
  Data := '';
  {$IFDEF Android}
  Data := ',' + Data + ',' + AndroidTools.GetPackageName + ',' + AndroidTools.GetPackageVersionCode.ToString;
  {$ENDIF}
  Data := Data + ',' + GetCurrentComputerName;
  Data := Data + ',' + GetOSVersion;
  DoLog(ltEvent, 'LogSystemInfo', FCategory, [Data]);
end;

procedure TLogger.SaveSettings;
var
  CategoryName: string;
  CategoryLevel: Integer;
  MyElem: Pointer;
begin
  FCS.Acquire;
  try
    try
      for MyElem in FCategoryList do
      begin
         CategoryName := TLogCategory(MyElem).FName;
         CategoryLevel := Integer(TLogCategory(MyElem).FLogType);
         FConfigFile.WriteInteger('Log', CategoryName, CategoryLevel);
      end;
    except
      on E: Exception do
      begin
{$IFDEF CodeSiteLogging}
        FCodeSite.SendError('TLogger.FindCategory:' + E.Message);
{$ENDIF}
      end;
    end;
  finally
    FCS.Release;
  end;
end;

procedure TLogger.SetAllCategoryLevels(aLevel: TLogType);
var
  MyElem: Pointer;
  I: Integer;
  Category: TLogCategory;
begin
  FCS.Acquire;
  try
    try
      for MyElem in FCategoryList do
      begin
        Category := TLogCategory(MyElem);
        if Assigned(Category) then
        begin
          Category.FLogType := aLevel;
          {$IFDEF TacLog}
          Category.FTacLogTopic.TraceLevel := GetTacLogLevel(aLevel);
          {$ENDIF}
        end;
      end;
    except
      on E: Exception do
      begin
        {$IFDEF CodeSiteLogging}
        FCodeSite.SendError('TLogger.FindCategory:' + E.Message);
        {$ENDIF}
        {$IFDEF TacLog}

        {$ENDIF}
      end;
    end;
  finally
    FCS.Release;
  end;
end;

procedure TLogger.SetCategoryLevel(aCategory: string; aLevel: TLogType);
var
  LogCategory: TLogCategory;
begin
  try
    LogCategory := FindCategory(aCategory);
    if Assigned(LogCategory) then
    begin
      LogCategory.FLogType := aLevel;
      {$IFDEF TacLog}
       LogCategory.FTacLogTopic.TraceLevel := GetTacLogLevel(aLevel);
      {$ENDIF}
    end;
  except
    on E: Exception do
    begin
{$IFDEF CodeSiteLogging}
      FCodeSite.SendError('TLogger.SetCategoryLevel:' + E.Message);
{$ENDIF}
    end;
  end;
end;

procedure TLogger.SetComputerName(const Value: string);
begin
  FComputerName := Value;
end;

procedure TLogger.SetOnLog(const Value: TOnLog);
begin
  FOnLog := Value;
end;

procedure TLogger.SetOnShowMessageToUser(const Value: TOnShowMessageToUser);
begin
  FOnShowMessageToUser := Value;
end;

procedure TLogger.SetShowErrorMessage(const Value: Boolean);
begin
  FShowErrorMessage := Value;
end;

procedure TLogger.ShowMessageToUser(aMessage: string);
begin
  if Assigned(FOnShowMessageToUser) then
    FOnShowMessageToUser(aMessage);
end;

function TLogger.VarArrayToStr(AVarArray: array of const ): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to High(AVarArray) do
    Result := Result + ' ' + VarRecToStr(AVarArray[I]);
end;

function TLogger.VarRecToStr(AVarRec: TVarRec): string;
const
  Bool: array [Boolean] of string = ('False', 'True');
begin
  case AVarRec.VType of
    vtInteger:
      Result := IntToStr(AVarRec.VInteger);
    vtBoolean:
      Result := Bool[AVarRec.VBoolean];
    vtChar:
      {$IFNDEF NEXTGEN}
      Result := AVarRec.VChar;
      {$ELSE}
      Result := AVarRec.VWideChar;
      {$ENDIF !NEXTGEN}
    vtExtended:
      Result := FloatToStr(AVarRec.VExtended^);
    vtString:
      {$IFNDEF NEXTGEN}
      Result := AVarRec.VString^;
      {$ELSE}
      Result := '';
      {$ENDIF !NEXTGEN}
    vtPChar:
      {$IFNDEF NEXTGEN}
      Result := AVarRec.VPChar;
      {$ELSE}
      Result := AVarRec.VPWideChar;
      {$ENDIF !NEXTGEN}
    vtObject:
      {$IFNDEF NEXTGEN}
      Result := AVarRec.VObject.ClassName;
      {$ELSE}
      Result := IntToStr(Integer(AVarRec.VObject));
      {$ENDIF !NEXTGEN}
    vtClass:
      Result := AVarRec.VClass.ClassName;
    vtAnsiString:
      {$IFNDEF NEXTGEN}
      Result := string(AVarRec.VAnsiString);
      {$ELSE}
      Result := '';
      {$ENDIF !NEXTGEN}
    vtCurrency:
      Result := CurrToStr(AVarRec.VCurrency^);
    vtVariant:
      Result := string(AVarRec.VVariant^);
    vtInterface:
      Result := string(AVarRec.VInterface^);
    vtWideString:
      Result := string(AVarRec.VWideString);
    vtInt64:
      Result := IntToStr(AVarRec.VInt64^);
    vtUnicodeString:
      Result := string(AVarRec.VUnicodeString);
  else
    Result := '';
  end;

end;

{ TLogCategory }

constructor TLogCategory.Create(aName: string; aLogType: TLogType);
begin
  FName := aName;
  FLogType := aLogType;
end;

procedure TLogCategory.SetLogType(const Value: TLogType);
begin
  FLogType := Value;
end;

end.
