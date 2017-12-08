unit HelpForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.TabControl, System.Actions,
  FMX.ActnList, FMX.Gestures, FMX.Objects;

type
  TfrmHelp = class(TForm)
    Panel1: TPanel;
    ToolBar1: TToolBar;
    btnBack: TSpeedButton;
    lblTitle: TLabel;
    VertScrollBox1: TVertScrollBox;
    MainLayout: TLayout;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    TabItem4: TTabItem;
    TabItem5: TTabItem;
    GestureManager1: TGestureManager;
    ActionList1: TActionList;
    NextTabAction1: TNextTabAction;
    PreviousTabAction1: TPreviousTabAction;
    btnNext: TSpeedButton;
    Layout1: TLayout;
    Layout2: TLayout;
    lblApptitle: TLabel;
    ImageControl1: TImageControl;
    ImageControl2: TImageControl;
    ImageControl3: TImageControl;
    Layout3: TLayout;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label6: TLabel;
    Label14: TLabel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmHelp: TfrmHelp;

implementation

{$R *.fmx}

uses GlobalUnit;

procedure TfrmHelp.FormShow(Sender: TObject);
begin
  TabControl1.TabIndex := 0;
  lblApptitle.Text := 'نرم افزار' + ' ' + Global.ServerTitle + '_' + Global.ClientTitle;
//  lblFirstPage.Text := 'آیا دوست دارید پایتخت تمام کشورها را حفظ کنید؟'
//    +#10 +'این نرم افزار با روش تداعی دوگانه کلمات، امکان به خاطر سپردن آنها را به شما می دهد.'
//    +#10 +'ابتدا می توانید یک قاره را انتخاب کنید'
//    +#10 +'سپس نرم افزار نام کشور و پایتخت آن را به شما نمایش می دهد'
//    +#10 +'در مرحله بعد نام کشور نمایش داده نمی شود و شما باید نام آن را به خاطر بیاورید'
//    +#10 +'این روند پنج بار تکرار می شود'
//    +#10 +'البته فاصله بین این تکرارها طوری تنظیم شده است که نام مورد نظر در حافظه کوتاه مدت شما باقی بماند'
//    +#10 +'و سپس در تکرارهای بعدی به حافظه بلند مدت منتقل شود'
//    +#10 +'خودتان امتحان کنید.';

//  lblLastPage.Text := 'با آرزوی موفقیت برای شما عزیزان'
//    +#10 +'در صورتیکه اشکالی در برنامه ملاحظه کردید '
//    +#10 +'لطفا از طریق ایمیل پشتیبانی به ما اطلاع دهید';
end;

end.
