unit PFDQuery;

interface

uses
  System.SysUtils, System.Classes, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TPFDQuery = class(TFDQuery)
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
  RegisterComponents('Plus Components - FireDAC', [TPFDQuery]);
end;

end.
