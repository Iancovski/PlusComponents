unit PRadioGroup;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TPRadioGroup = class(TRadioGroup)
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
  RegisterComponents('Plus Components - Standard', [TPRadioGroup]);
end;

end.
