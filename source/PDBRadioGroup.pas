unit PDBRadioGroup;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.DBCtrls;

type
  TPDBRadioGroup = class(TDBRadioGroup)
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
  RegisterComponents('Plus Components', [TPDBRadioGroup]);
end;

end.
