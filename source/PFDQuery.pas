unit PFDQuery;

interface

uses
  System.SysUtils, System.Classes, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TPFDQuery = class(TFDQuery)
  private
  protected
    procedure DoBeforeInsert; override;
  public
  published
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Plus Components - FireDAC', [TPFDQuery]);
end;

{ TPFDQuery }

procedure TPFDQuery.DoBeforeInsert;
begin
  if Assigned(Self.MasterSource) then begin
    if Self.MasterSource.State in dsEditModes then begin
      Self.MasterSource.DataSet.Post;
    end;
  end;

  inherited;
end;

end.
