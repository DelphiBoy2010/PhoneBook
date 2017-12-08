unit AboutUs;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Layouts;

type
  TfrmAboutUs = class(TForm)
    Panel1: TPanel;
    ToolBar1: TToolBar;
    btnBack: TSpeedButton;
    lblTitle: TLabel;
    Layout1: TLayout;
    lblOwner: TLabel;
    Layout2: TLayout;
    Layout3: TLayout;
    lblVersion: TLabel;
    Layout4: TLayout;
    lblAppTitle: TLabel;
    btnSite: TSpeedButton;
    lblVerionTitle: TLabel;
    procedure btnBackClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSiteClick(Sender: TObject);
  private
    { Private declarations }
    procedure FillData;
  public
    { Public declarations }
  end;

var
  frmAboutUs: TfrmAboutUs;

implementation

{$R *.fmx}

uses Android.Tools, GlobalUnit;

procedure TfrmAboutUs.btnBackClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAboutUs.btnSiteClick(Sender: TObject);
begin
  {$IFDEF Android}
  AndroidTools.OpenURL(Global.SiteURL);
  {$ENDIF}
end;

procedure TfrmAboutUs.FillData;
begin
  lblAppTitle.Text := '‰—„ «›“«—' + ' ' + Global.ServerTitle + '_' + Global.ClientTitle;
  lblOwner.Text := Global.OwnerTitle;
  {$IFDEF Android}
  lblVersion.Text := AndroidTools.GetPackageVersion;
  {$ENDIF}
  btnSite.Text := Global.SiteURL;
end;

procedure TfrmAboutUs.FormShow(Sender: TObject);
begin
  FillData;
end;

end.
