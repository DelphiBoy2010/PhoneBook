program asan_phonebook;



uses
  System.StartUpCopy,
  FMX.Forms,
  MainForm in 'MainForm.pas' {frmMain},
  GlobalUnit in 'GlobalUnit.pas',
  DataModule in 'DAL\DataModule.pas' {DataModule1: TDataModule},
  LoggerManager in 'LogManager\LoggerManager.pas',
  KADSolarUtl in 'LogManager\KADSolarUtl.pas',
  Common.Messages in 'Common\Common.Messages.pas',
  Common.Tools in 'Common\Common.Tools.pas',
  Android.Tools in 'Tools\Android.Tools.pas',
  FMX.Consts in 'FMX Custom Units\FMX.Consts.pas',
  AboutUs in 'AboutUs.pas' {frmAboutUs},
  HelpForm in 'HelpForm.pas' {frmHelp},
  WelcomePageForm in 'WelcomePageForm.pas' {frmWelcomePage},
  Asanyab.Tools in 'Tools\Asanyab.Tools.pas',
  REST.Response.Adapter in 'FMX Custom Units\REST.Response.Adapter.pas',
  DAL.Profiles in 'DAL\DAL.Profiles.pas',
  BaseClass in 'BaseClass.pas',
  DAL.DataManager in 'DAL\DAL.DataManager.pas',
  ProfileForm in 'Views\ProfileForm.pas' {frmProfile},
  asanyab.TextLog in 'LogManager\asanyab.TextLog.pas',
  CustomersListForm in 'Views\CustomersListForm.pas' {frmCustomersList},
  ViewDataModule in 'Views\ViewDataModule.pas' {ViewGlobalModule: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.FormFactor.Orientations := [TFormOrientation.Portrait, TFormOrientation.InvertedPortrait];
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TfrmAboutUs, frmAboutUs);
  Application.CreateForm(TfrmHelp, frmHelp);
  Application.CreateForm(TfrmWelcomePage, frmWelcomePage);
  Application.CreateForm(TfrmCustomersList, frmCustomersList);
  Application.CreateForm(TViewGlobalModule, ViewGlobalModule);
  Application.CreateForm(TfrmProfile, frmProfile);
  Application.Run;
end.
