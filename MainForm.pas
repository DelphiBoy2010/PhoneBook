unit MainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Graphics, FMX.Forms, FMX.Dialogs, FMX.TabControl,
  System.Actions, FMX.ActnList,
  FMX.Objects, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Ani,
  FMX.ListBox, FMX.Layouts, System.Rtti, GlobalUnit, LoggerManager, FMX.Media,
  System.ImageList, FMX.ImgList, FMX.Colors, FMX.Edit, FMX.EditBox,
  FMX.NumberBox, FMX.MultiView, IPPeerClient, Data.Bind.Components,
  Data.Bind.ObjectScope, REST.Client, Data.DB, Datasnap.DBClient, FMX.WebBrowser,
  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent,
  FMX.ScrollBox, FMX.Memo, RTL.Controls,
  RTL.ListView.Appearances, RTL.TabControl, RTL.TreeView, CustomersListForm;

type
  TfrmMain = class(TForm)
    DetailPanel: TPanel;
    ToolBar1: TToolBar;
    lblTitle: TLabel;
    MasterButton: TSpeedButton;
    Layout3: TLayout;
    Layout5: TLayout;
    MultiView1: TMultiView;
    lsbMainMenu: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ToolBar2: TToolBar;
    lblUserTitle: TLabel;
    MasterButton2: TSpeedButton;
    btnPersonList: TButton;
    ImageList1: TImageList;
    Layout1: TLayout;
    Layout2: TLayout;
    Layout4: TLayout;
    btnProfile: TButton;
    btnAction1: TButton;
    btnAction2: TButton;
    RTLFixer1: TRTLFixer;
    TreeViewRTL1: TTreeViewRTL;
    TabControlRTL1: TTabControlRTL;
    ListViewAppearanceRTL1: TListViewAppearanceRTL;
    ToolBar3: TToolBar;
    lblExhibitionPlace: TLabel;
    lblExhibitionName: TLabel;
    Rectangle1: TRectangle;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnMenuClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure btnPersonListClick(Sender: TObject);
    procedure btnWelcomePageClick(Sender: TObject);
    procedure cbStyleChange(Sender: TObject);
    procedure btnProfileClick(Sender: TObject);
  private
    { Private declarations }
    FCategory: string;
    procedure FillMenu;
    procedure ShowMenu(Sender: TObject);
    procedure SetTitles;
    procedure ShowGroups(aSender: TObject);
    procedure ShowContactUs(aSender: TObject);
    procedure ShowAboutUs(aSender: TObject);
    procedure ShowVote(aSender: TObject);
    procedure ShowCheckUpdate(aSender: TObject);
    procedure ShowOtherApps(aSender: TObject);
    procedure ShowReportBug(aSender: TObject);
    procedure ShowHelp(aSender: TObject);
    procedure ShowBuyPackage(aSender: TObject);
    procedure CheckForUpdate;
    procedure UpdateComfirmResult(const AResult: TModalResult);
    procedure ShowWelcomePage;
    procedure ShowPeopleList(aSender: TObject);
    procedure ShowSearchPeople(aSender: TObject);
    procedure ShowProfile(aSender: TObject);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses System.IOUtils, FMX.DialogService, Common.Messages, Android.Tools,
  AboutUs, HelpForm, WelcomePageForm, Asanyab.Tools, ViewDataModule,
  ProfileForm;

procedure TfrmMain.UpdateComfirmResult(const AResult: TModalResult);
begin
  if AResult = mrYes then
  begin

  end;
end;

procedure TfrmMain.btnMenuClick(Sender: TObject);
begin
  ShowMenu(Sender);
end;

procedure TfrmMain.btnProfileClick(Sender: TObject);
begin
  ShowProfile(Sender);
end;

procedure TfrmMain.btnWelcomePageClick(Sender: TObject);
begin
  ShowWelcomePage;
end;

procedure TfrmMain.btnPersonListClick(Sender: TObject);
begin
  ShowPeopleList(Sender);
end;

procedure TfrmMain.btnHelpClick(Sender: TObject);
begin
  ShowHelp(Sender);
end;

procedure TfrmMain.Button2Click(Sender: TObject);
begin
  ShowOtherApps(Sender);
end;

procedure TfrmMain.Button3Click(Sender: TObject);
begin
  ShowAboutUs(Sender);
end;

procedure TfrmMain.cbStyleChange(Sender: TObject);
begin
  //StyleBook := TStyleBook(cbStyle.Items.Objects[cbStyle.ItemIndex]);
end;

procedure TfrmMain.CheckForUpdate;
var
  CurrentVersion: Integer;
  NewVersion: Integer;
begin
  {$IFDEF Android}
  CurrentVersion := AndroidTools.GetPackageVersionCode;
  {$ENDIF}
  if NewVersion > CurrentVersion then
  begin
    TDialogService.MessageDialog(Mess_UpdateComfirm, TMsgDlgType.mtConfirmation, mbYesNo, TMsgDlgBtn.mbYes, 0, UpdateComfirmResult);
  end
  else
  begin
    ShowMessage('نسخه جدیدی وجود ندارد');
  end;
end;

procedure TfrmMain.FillMenu;
var
  MenuItem: TListBoxItem;
begin

  lsbMainMenu.Clear;
  MenuItem := TListBoxItem.Create(nil);
  MenuItem.Name := 'lsbiShowPeopleList';
  MenuItem.ImageIndex := 1;
  MenuItem.Text := 'لیست افراد';
  MenuItem.OnClick := ShowPeopleList;
  lsbMainMenu.AddObject(MenuItem);

  MenuItem := TListBoxItem.Create(nil);
  MenuItem.Name := 'lsbiHelp';
  MenuItem.ImageIndex := 8;
  MenuItem.Text := 'راهنمای برنامه';
  MenuItem.OnClick := ShowHelp;
  lsbMainMenu.AddObject(MenuItem);

  MenuItem := TListBoxItem.Create(nil);
  MenuItem.Name := 'lsbiAboutUs';
  MenuItem.ImageIndex := 8;
  MenuItem.Text := 'درباره ما';
  MenuItem.OnClick := ShowAboutUs;
  lsbMainMenu.AddObject(MenuItem);
  MenuItem := TListBoxItem.Create(nil);
  MenuItem.Name := 'lsbiVote';
  MenuItem.ImageIndex := 8;
  MenuItem.Text := 'نظر دادن';
  MenuItem.OnClick := ShowVote;
  lsbMainMenu.AddObject(MenuItem);

  MenuItem := TListBoxItem.Create(nil);
  MenuItem.Name := 'lsbiContactUs';
  MenuItem.Text := 'تماس با ما';
  MenuItem.OnClick := ShowContactUs;
  lsbMainMenu.AddObject(MenuItem);

  MenuItem := TListBoxItem.Create(nil);
  MenuItem.Name := 'lsbiOtherApps';
  MenuItem.ImageIndex := 5;
  MenuItem.Text := 'سایر نرم افزارهای ما';
  MenuItem.OnClick := ShowOtherApps;
  lsbMainMenu.AddObject(MenuItem);

  MenuItem := TListBoxItem.Create(nil);
  MenuItem.Name := 'lsbiBugReport';
  MenuItem.Text := 'گزارش اشکال برنامه';
  MenuItem.OnClick := ShowReportBug;
  lsbMainMenu.AddObject(MenuItem);

  MenuItem := TListBoxItem.Create(nil);
  MenuItem.Name := 'lsbiCheckUpdate';
  MenuItem.ImageIndex := 4;
  MenuItem.Text := 'بررسی به روزرسانی';
  MenuItem.OnClick := ShowCheckUpdate;
  lsbMainMenu.AddObject(MenuItem);

  MenuItem := TListBoxItem.Create(nil);
  MenuItem.Name := 'lsbiBuyPackage';
  MenuItem.ImageIndex := 7;
  MenuItem.Text := 'خرید بسته';
  MenuItem.OnClick := ShowBuyPackage;
  lsbMainMenu.AddObject(MenuItem);


end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  //ReportMemoryLeaksOnShutdown := True;
  Global := TGlobal.Create;
  Logger := TLogger.Create('', Global.ServerAppName + '_' + Global.ClientAppName);
  FCategory := ClassName;
  Logger.AddCategory(FCategory);
  Tools := TTools.Create;
  FillMenu;
  SetTitles;
  {$IFDEF Android}
  AndroidTools := TAndroidTools.Create;
  {$ENDIF}

end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  {$IFDEF Android}
  FreeAndNil(AndroidTools);
  {$ENDIF}
  FreeAndNil(Tools);
  FreeAndNil(Global);
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  Logger.DoLog(ltEvent, 'FormShow', FCategory, ['Show main form']);
  //CheckForUpdate;
  //ShowWelcomePage;
end;

procedure TfrmMain.SetTitles;
begin
  Self.Caption := Global.ServerAppName + '_' + Global.ClientAppName;
  lblTitle.Text := Global.ServerTitle + '_' + Global.ClientTitle;
end;

procedure TfrmMain.ShowAboutUs(aSender: TObject);
begin
  frmAboutUs.Show;
  if aSender is TListBoxItem then
  begin
    ShowMenu(aSender);
  end;
end;

procedure TfrmMain.ShowBuyPackage(aSender: TObject);
begin
  if Global.AllowBuyPackage then
  begin

  end
  else
  begin
    ShowMessage('این قسمت هنوز فعال نشده است');
  end;
end;

procedure TfrmMain.ShowCheckUpdate(aSender: TObject);
begin
  CheckForUpdate;
  if aSender is TListBoxItem then
  begin
    ShowMenu(aSender);
  end;
end;

procedure TfrmMain.ShowContactUs(aSender: TObject);
begin
  if aSender is TListBoxItem then
  begin
    ShowMenu(aSender);
  end;
end;

procedure TfrmMain.ShowPeopleList(aSender: TObject);
begin
  ViewGlobalModule.ShowCustomerListForm;
end;

procedure TfrmMain.ShowProfile(aSender: TObject);
begin
  frmProfile.Show;
end;

procedure TfrmMain.ShowGroups(aSender: TObject);
begin

end;

procedure TfrmMain.ShowHelp(aSender: TObject);
begin
 frmHelp.Show;
 if aSender is TListBoxItem then
  begin
    ShowMenu(aSender);
  end;
end;

procedure TfrmMain.ShowMenu(Sender: TObject);
begin

end;

procedure TfrmMain.ShowOtherApps(aSender: TObject);
begin

  if aSender is TListBoxItem then
  begin
    ShowMenu(aSender);
  end;
end;

procedure TfrmMain.ShowReportBug(aSender: TObject);
begin
 if aSender is TListBoxItem then
  begin
    ShowMenu(aSender);
  end;
end;

procedure TfrmMain.ShowSearchPeople(aSender: TObject);
begin

end;

procedure TfrmMain.ShowVote(aSender: TObject);
begin

  if aSender is TListBoxItem then
  begin
    ShowMenu(aSender);
  end;
end;

procedure TfrmMain.ShowWelcomePage;
begin
  frmWelcomePage.Show;
end;

end.
