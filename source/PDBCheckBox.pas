unit PDBCheckBox;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.DBCtrls, Winapi.Messages,
  PLabel;

type
  TPDBCheckBox = class(TDBCheckBox)

  private
    FCaption: String;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure SetCaption(const Value: String);

  protected
    SettingLabelPosition: Boolean;
    SubLabel: TPLabel;
    procedure CMBidimodechanged(var Message: TMessage); message CM_BIDIMODECHANGED;
    procedure CMEnabledchanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMVisiblechanged(var Message: TMessage); message CM_VISIBLECHANGED;
    procedure SetName(const Value: TComponentName); override;
    procedure SetParent(AParent: TWinControl); override;
    function GetCheckBoxSize: Word;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft: Integer; ATop: Integer; AWidth: Integer; AHeight: Integer); override;
    procedure SetLabelPosition;
    procedure SetupInternalLabel;

  published
    property Caption: String read FCaption write SetCaption;

  end;

procedure Register;

implementation

uses
  System.Types, System.Math;

procedure Register;
begin
  RegisterComponents('Plus Components - Data Controls', [TPDBCheckBox]);
end;

{ TPDBCheckBox }

procedure TPDBCheckBox.CMBidimodechanged(var Message: TMessage);
begin
  inherited;

  if Assigned(SubLabel) then
    SubLabel.BiDiMode := BiDiMode;
end;

procedure TPDBCheckBox.CMEnabledchanged(var Message: TMessage);
begin
  inherited;

  if Assigned(SubLabel) then
    SubLabel.Enabled := Enabled;
end;

procedure TPDBCheckBox.CMFontChanged(var Message: TMessage);
begin
  inherited;

  if Assigned(SubLabel) then
    SubLabel.Font := Self.Font;

  SetLabelPosition;
end;

procedure TPDBCheckBox.CMTextChanged(var Message: TMessage);
begin
  inherited;

  if Assigned(SubLabel) then
    SubLabel.Caption := Self.Caption;
end;

procedure TPDBCheckBox.CMVisiblechanged(var Message: TMessage);
begin
  inherited;

  if Assigned(SubLabel) then
    SubLabel.Visible := Visible;
end;

constructor TPDBCheckBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  ControlStyle := [csDoubleClicks];
  Height := GetCheckBoxSize();
  SettingLabelPosition := False;
  SetupInternalLabel;
end;

destructor TPDBCheckBox.Destroy;
begin
  if Assigned(SubLabel) then
    SubLabel.Free;

  inherited;
end;

function TPDBCheckBox.GetCheckBoxSize: Word;
begin
  case Self.CurrentPPI of
    96:
      Result := 17;
    120:
      Result := 20;
  else
    Result := 24;
  end;
end;

procedure TPDBCheckBox.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  if Assigned(SubLabel) then begin
    AWidth := GetCheckBoxSize() + SubLabel.Width;
    AHeight := Max(GetCheckBoxSize(), SubLabel.Height);
  end;

  inherited SetBounds(ALeft, ATop, AWidth, AHeight);

  if not SettingLabelPosition then
    SetLabelPosition;
end;

procedure TPDBCheckBox.SetCaption(const Value: String);
begin
  FCaption := Value;
  SubLabel.Caption := FCaption;
  SetLabelPosition;
end;

procedure TPDBCheckBox.SetLabelPosition;
var
  P: TPoint;
begin
  if SubLabel = nil then
    Exit;

  SettingLabelPosition := True;
  try
    P := Point(Left + GetCheckBoxSize(), Top + ((Height - SubLabel.Height) div 2));
    SubLabel.SetBounds(P.x, P.y, SubLabel.Width, SubLabel.Height);
    Self.SetBounds(Left, Top, Width, Height);
  finally
    SettingLabelPosition := False;
  end;
end;

procedure TPDBCheckBox.SetName(const Value: TComponentName);
begin
  if (csDesigning in ComponentState) and (SubLabel <> nil) and
    ((SubLabel.GetTextLen = 0) or (CompareText(SubLabel.Caption, Name) = 0)) then
    Caption := Value;

  inherited SetName(Value);
end;

procedure TPDBCheckBox.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);

  if not Assigned(SubLabel) then
    Exit;

  SubLabel.Parent := AParent;
  SubLabel.Visible := True;
end;

procedure TPDBCheckBox.SetupInternalLabel;
begin
  if Assigned(SubLabel) then
    Exit;

  SubLabel := TPLabel.Create(Self);
  SubLabel.FreeNotification(Self);
  SubLabel.FocusControl := Self;
  SubLabel.Parent := Self.Parent;

  SetLabelPosition;
end;

end.
