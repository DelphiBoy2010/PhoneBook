unit CustomersListForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, RTLData.Bind.GenData,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Components, Data.Bind.ObjectScope, FMX.ListBox,
  FMX.ListView, FMX.Objects;

type
  TfrmCustomersList = class(TForm)
    VertScrollBox1: TVertScrollBox;
    DetailPanel: TPanel;
    ToolBar1: TToolBar;
    lblTitle: TLabel;
    btnBack: TButton;
    ToolBar2: TToolBar;
    btnInsert: TButton;
    ListView1: TListView;
    PrototypeBindSource1: TPrototypeBindSource;
    BindingsList1: TBindingsList;
    LinkFillControlToField1: TLinkFillControlToField;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    procedure btnCustomerListClick(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  frmCustomersList: TfrmCustomersList;

implementation

{$R *.fmx}

uses
  ViewDataModule;

{ TfrmCustomersList }

procedure TfrmCustomersList.btnCustomerListClick(Sender: TObject);
begin
  ViewGlobalModule.ShowCustomerListForm;
end;

end.
