unit PDBCheckBox;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.DBCtrls;

type
  TPDBCheckBox = class(TDBCheckBox)
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
  RegisterComponents('Plus Components - Data Controls', [TPDBCheckBox]);
end;

end.
