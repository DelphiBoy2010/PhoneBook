unit WelcomePageForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.StdCtrls, FMX.Controls.Presentation, FMX.WebBrowser,
  FMX.Layouts;

type
  TfrmWelcomePage = class(TForm)
    Panel1: TPanel;
    ToolBar1: TToolBar;
    btnBack: TSpeedButton;
    lblTitle: TLabel;
    Layout1: TLayout;
    wbMainPage: TWebBrowser;
    procedure btnBackClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmWelcomePage: TfrmWelcomePage;

implementation

{$R *.fmx}

uses GlobalUnit;

procedure TfrmWelcomePage.btnBackClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmWelcomePage.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  wbMainPage.Stop;

end;

procedure TfrmWelcomePage.FormShow(Sender: TObject);
begin
  wbMainPage.Navigate(Global.GetWelcomeURL);
end;

end.
