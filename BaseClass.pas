unit BaseClass;

interface
type
  TBaseClass = class(TObject)
  private

  protected
    FCategory: string;
    constructor Create; virtual;
    destructor Destroy; override;
  end;
implementation

{ TBaseClass }

uses LoggerManager;

constructor TBaseClass.Create;
begin
  inherited;
  FCategory := ClassName;
  Logger.AddCategory(FCategory);
end;

destructor TBaseClass.Destroy;
begin

  inherited;
end;

end.
