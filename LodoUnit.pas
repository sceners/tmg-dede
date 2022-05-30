unit LodoUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, RXCtrls;

type
  TLogoForm = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    RxLabel1: TRxLabel;
    Image3: TImage;
    RxLabel2: TRxLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LogoForm: TLogoForm;

implementation

{$R *.DFM}

end.
