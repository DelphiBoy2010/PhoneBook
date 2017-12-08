unit ProfileForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ScrollBox, FMX.Memo, FMX.StdCtrls, FMX.Edit, FMX.ListBox, FMX.Layouts,
  FMX.Controls.Presentation, DAL.DataManager, FMX.Objects;

type
  TfrmProfile = class(TForm)
    DetailPanel: TPanel;
    Layout5: TLayout;
    Layout7: TLayout;
    Layout8: TLayout;
    lblname: TLabel;
    Layout1: TLayout;
    btnSaveProfile: TButton;
    Layout4: TLayout;
    Layout6: TLayout;
    Layout13: TLayout;
    cbCity: TComboBox;
    VertScrollBox1: TVertScrollBox;
    edtFirstName: TEdit;
    memAddress: TMemo;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ToolBar1: TToolBar;
    lblTitle: TLabel;
    btnBack: TButton;
    lblFileNumber: TLabel;
    Label6: TLabel;
    Rectangle1: TRectangle;
    edtLastName: TEdit;
    edtPhoneNumber: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btnSaveProfileClick(Sender: TObject);
  private
    { Private declarations }
    procedure LoadData;
  public
    { Public declarations }
  end;

var
  frmProfile: TfrmProfile;

implementation

{$R *.fmx}

procedure TfrmProfile.btnSaveProfileClick(Sender: TObject);
var
  ResMessage: string;
begin
  DataManager.SaveProfileData(edtFirstName.Text, edtLastName.Text,
    edtPhoneNumber.Text, cbCity.Items[cbCity.ItemIndex], memAddress.Text, ResMessage);
  ShowMessage(ResMessage);
end;

procedure TfrmProfile.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //Action := TCloseAction.caFree;
end;

procedure TfrmProfile.FormShow(Sender: TObject);
begin
  LoadData;
end;

procedure TfrmProfile.LoadData;
var
  FirstName, LastName, PhoneNumber, City, Address: string;
  Comment, ProblemType: string;
  Res: string;
begin
  DataManager.LoadProfileData(FirstName, LastName, PhoneNumber, City, Address, Comment, ProblemType, Res);
  edtFirstName.Text := FirstName;
  edtLastName.Text := LastName;
  edtPhoneNumber.Text := PhoneNumber;
  memAddress.Text := Address;
  cbCity.ItemIndex := cbCity.Items.IndexOf(City)
end;

end.
