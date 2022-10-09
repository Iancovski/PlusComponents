unit PRadioButton;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls, PLabel,
  Winapi.Messages, System.Math;

type
  TPRadioButton = class(TRadioButton)

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
    function GetRadioButtonSize: Word;

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
  System.Types;

procedure Register;
begin
  RegisterComponents('Plus Components - Standard', [TPRadioButton]);
end;

{ TPRadioButton }

procedure TPRadioButton.CMBidimodechanged(var Message: TMessage);
begin
  inherited;

  if Assigned(SubLabel) then
    SubLabel.BiDiMode := BiDiMode;
end;

procedure TPRadioButton.CMEnabledchanged(var Message: TMessage);
begin
  inherited;

  if Assigned(SubLabel) then
    SubLabel.Enabled := Enabled;
end;

procedure TPRadioButton.CMFontChanged(var Message: TMessage);
begin
  inherited;

  if Assigned(SubLabel) then
    SubLabel.Font := Self.Font;

  SetLabelPosition;
end;

procedure TPRadioButton.CMTextChanged(var Message: TMessage);
begin
  inherited;

  if Assigned(SubLabel) then
    SubLabel.Caption := Self.Caption;
end;

procedure TPRadioButton.CMVisiblechanged(var Message: TMessage);
begin
  inherited;

  if Assigned(SubLabel) then
    SubLabel.Visible := Visible;
end;

constructor TPRadioButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  ControlStyle := [csDoubleClicks];
  Height := GetRadioButtonSize();
  SettingLabelPosition := False;
  SetupInternalLabel;
end;

destructor TPRadioButton.Destroy;
begin
  if Assigned(SubLabel) then
    SubLabel.Free;

  inherited;
end;

function TPRadioButton.GetRadioButtonSize: Word;
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

procedure TPRadioButton.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  if Assigned(SubLabel) then begin
    AWidth := GetRadioButtonSize() + SubLabel.Width;
    AHeight := Max(GetRadioButtonSize(), SubLabel.Height);
  end;

  inherited SetBounds(ALeft, ATop, AWidth, AHeight);

  if not SettingLabelPosition then
    SetLabelPosition;
end;

procedure TPRadioButton.SetCaption(const Value: String);
begin
  FCaption := Value;
  SubLabel.Caption := FCaption;
  SetLabelPosition;
end;

procedure TPRadioButton.SetLabelPosition;
var
  P: TPoint;
begin
  if SubLabel = nil then
    Exit;

  SettingLabelPosition := True;
  try
    P := Point(Left + GetRadioButtonSize(), Top + ((Height - SubLabel.Height) div 2));
    SubLabel.SetBounds(P.x, P.y, SubLabel.Width, SubLabel.Height);
    Self.SetBounds(Left, Top, Width, Height);
  finally
    SettingLabelPosition := False;
  end;
end;

procedure TPRadioButton.SetName(const Value: TComponentName);
begin
  if (csDesigning in ComponentState) and (SubLabel <> nil) and
    ((SubLabel.GetTextLen = 0) or (CompareText(SubLabel.Caption, Name) = 0)) then
    Caption := Value;

  inherited SetName(Value);
end;

procedure TPRadioButton.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);

  if not Assigned(SubLabel) then
    Exit;

  SubLabel.Parent := AParent;
  SubLabel.Visible := True;
end;

procedure TPRadioButton.SetupInternalLabel;
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
