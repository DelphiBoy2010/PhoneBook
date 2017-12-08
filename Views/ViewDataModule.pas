unit ViewDataModule;

interface

uses
  System.SysUtils, System.Classes, FMX.TabControl, System.Actions, FMX.ActnList,
  FMX.StdActns, FMX.Types, FMX.Controls;

type
  TViewGlobalModule = class(TDataModule)
    ActionList1: TActionList;
    NextTabAction1: TNextTabAction;
    PreviousTabAction1: TPreviousTabAction;
    actCloseForm: TAction;
    WindowClose1: TWindowClose;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ShowCustomerListForm;
  end;

var
  ViewGlobalModule: TViewGlobalModule;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses CustomersListForm;

{$R *.dfm}

{ TViewGlobalModule }

procedure TViewGlobalModule.ShowCustomerListForm;
begin
  frmCustomersList.Show;
end;

end.
