unit PGroupBox;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls;

type
  TTitleAlignment = (taLeft, taCenter, taRight, taCustom);

type
  TPGroupBox = class(TGroupBox)
  private
    FCaption: String;
    FTitleAlignment: TTitleAlignment;
    procedure SetCaption(const Value: String);
    procedure SetTitleAlignment(const Value: TTitleAlignment);
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
    property Caption: String read FCaption write SetCaption;
    property TitleAlignment: TTitleAlignment read FTitleAlignment write SetTitleAlignment;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Plus Components - Standard', [TPGroupBox]);
end;

{ TPGroupBox }

procedure TPGroupBox.SetCaption(const Value: String);
begin
  FCaption := Value;
end;

procedure TPGroupBox.SetTitleAlignment(const Value: TTitleAlignment);
begin
  FTitleAlignment := Value;
end;

end.
