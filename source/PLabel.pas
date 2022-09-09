unit PLabel;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.Dialogs;

type
  TLabelAlignment = (laTop, laLeft, laRight, laCenter);

type
  TPLabel = class(TLabel)

  private
    FLabelAlignment: TLabelAlignment;
    FMasterLabel: TPLabel;
    procedure SetLabelAlignment(const Value: TLabelAlignment);
    procedure SetMasterLabel(const Value: TPLabel);

  protected
    SettingMasterAlignment: Boolean;
    procedure AdjustBounds; override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft: Integer; ATop: Integer; AWidth: Integer; AHeight: Integer); override;

  published
    property MasterAlignment: TLabelAlignment read FLabelAlignment write SetLabelAlignment default laLeft;
    property MasterLabel: TPLabel read FMasterLabel write SetMasterLabel;
  end;

procedure Register;

implementation

uses
  PEdit;

procedure Register;
begin
  RegisterComponents('Plus Components', [TPLabel]);
end;

{ TPLabel }

procedure TPLabel.AdjustBounds;
begin
  inherited AdjustBounds;

  if Owner is TPEdit then
    TPEdit(Owner).SetLabelPosition(TPEdit(Owner).LabelPosition);

  if not SettingMasterAlignment then
    SetLabelAlignment(FLabelAlignment);
end;

constructor TPLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  SettingMasterAlignment := False;
  FLabelAlignment := laLeft;

  if Owner is TPEdit then begin
    Name := 'SubLabel';
    SetSubComponent(True);
    Caption := AOwner.Name;
  end;
end;

destructor TPLabel.Destroy;
var
  i: Integer;
begin
  for i := 0 to Owner.ComponentCount - 1 do begin
    if (Owner.Components[i] is TPLabel) then begin
      if (Assigned(TPLabel(Owner.Components[i]).MasterLabel)) and (TPLabel(Owner.Components[i]).MasterLabel = Self) then
        TPLabel(Owner.Components[i]).MasterLabel := nil;
    end;
  end;

  inherited;
end;

procedure TPLabel.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);

  if not SettingMasterAlignment then
    SetLabelAlignment(FLabelAlignment);
end;

procedure TPLabel.SetLabelAlignment(const Value: TLabelAlignment);
begin
  FLabelAlignment := Value;

  if Assigned(MasterLabel) then begin
    SettingMasterAlignment := True;
    try
      case FLabelAlignment of
        laTop:
          Self.Top := MasterLabel.Top;
        laLeft:
          Self.Left := MasterLabel.Left;
        laRight:
          Self.Left := (MasterLabel.Left + MasterLabel.Width) - Self.Width;
        laCenter:
          Self.Left := (MasterLabel.Left + MasterLabel.Width div 2) - (Self.Width div 2);
      end;
    finally
      SettingMasterAlignment := False;
    end;
  end;
end;

procedure TPLabel.SetMasterLabel(const Value: TPLabel);
begin
  if (Value <> nil) and (Self.Owner <> Value.Owner) then begin
    ShowMessage('It is not allowed to set a MasterLabel of another Owner.');
    Abort;
  end;

  if (Value <> nil) and (Value = Self) then begin
    ShowMessage('The MasterLabel cannot be the label itself.');
    Abort;
  end;

  FMasterLabel := Value;

  if not SettingMasterAlignment then
    SetLabelAlignment(FLabelAlignment);
end;

end.
