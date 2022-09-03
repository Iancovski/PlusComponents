unit PButton;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Buttons;

type
  TPButton = class(TSpeedButton)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Plus Components', [TPButton]);
end;

end.
