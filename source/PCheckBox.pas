unit PCheckBox;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls, Winapi.Messages,
  PLabel;

type
  TPCheckBox = class(TCheckBox)

  private
    FCaption: String;
    FLabelSpacing: Integer;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure SetCaption(const Value: String);
    procedure SetLabelSpacing(const Value: Integer);

  protected
    SettingLabelPosition: Boolean;
    SubLabel: TPLabel;
    procedure CMBidimodechanged(var Message: TMessage); message CM_BIDIMODECHANGED;
    procedure CMEnabledchanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMVisiblechanged(var Message: TMessage); message CM_VISIBLECHANGED;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetName(const Value: TComponentName); override;
    procedure SetParent(AParent: TWinControl); override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft: Integer; ATop: Integer; AWidth: Integer; AHeight: Integer); override;
    procedure SetLabelPosition;
    procedure SetupInternalLabel;

  published
    property Caption: String read FCaption write SetCaption;
    property LabelSpacing: Integer read FLabelSpacing write SetLabelSpacing default 3;

  end;

procedure Register;

implementation

uses
  System.Types, System.Math;

procedure Register;
begin
  RegisterComponents('Plus Components - Standard', [TPCheckBox]);
end;

{ TPCheckBox }

procedure TPCheckBox.CMBidimodechanged(var Message: TMessage);
begin
  inherited;

  if SubLabel <> nil then
    SubLabel.BiDiMode := BiDiMode;
end;

procedure TPCheckBox.CMEnabledchanged(var Message: TMessage);
begin
  inherited;

  if SubLabel <> nil then
    SubLabel.Enabled := Enabled;
end;

procedure TPCheckBox.CMFontChanged(var Message: TMessage);
begin
  inherited;

  if SubLabel <> nil then
    SubLabel.Font := Self.Font;

  SetLabelPosition;
end;

procedure TPCheckBox.CMTextChanged(var Message: TMessage);
begin
  inherited;

  if SubLabel <> nil then
    SubLabel.Caption := Self.Caption;
end;

procedure TPCheckBox.CMVisiblechanged(var Message: TMessage);
begin
  inherited;

  if SubLabel <> nil then
    SubLabel.Visible := Visible;
end;

constructor TPCheckBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  ControlStyle := [csDoubleClicks];
  Height := 17;
  FLabelSpacing := 3;
  SettingLabelPosition := False;
  SetupInternalLabel;
end;

destructor TPCheckBox.Destroy;
begin
  if Assigned(SubLabel) then
    SubLabel.Free;

  inherited;
end;

procedure TPCheckBox.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (AComponent = SubLabel) and (Operation = opRemove) then
    SubLabel := nil;
end;

procedure TPCheckBox.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  if Assigned(SubLabel) then begin
    AWidth := 17 + FLabelSpacing + SubLabel.Width;
    AHeight := Max(17, SubLabel.Height);
  end;

  inherited SetBounds(ALeft, ATop, AWidth, AHeight);

  if not SettingLabelPosition then
    SetLabelPosition;
end;

procedure TPCheckBox.SetCaption(const Value: String);
begin
  FCaption := Value;
  SubLabel.Caption := FCaption;
  SetLabelPosition;
end;

procedure TPCheckBox.SetLabelPosition;
var
  P: TPoint;
begin
  if SubLabel = nil then
    Exit;

  SettingLabelPosition := True;
  try
    P := Point(Left + 17 + FLabelSpacing, Top + ((Height - SubLabel.Height) div 2));
    SubLabel.SetBounds(P.x, P.y, SubLabel.Width, SubLabel.Height);
    Self.SetBounds(Left, Top, Width, Height);
  finally
    SettingLabelPosition := False;
  end;
end;

procedure TPCheckBox.SetLabelSpacing(const Value: Integer);
begin
  FLabelSpacing := Value;
  SetLabelPosition;
end;

procedure TPCheckBox.SetName(const Value: TComponentName);
begin
  if (csDesigning in ComponentState) and (SubLabel <> nil) and
    ((SubLabel.GetTextLen = 0) or (CompareText(SubLabel.Caption, Name) = 0)) then
    Caption := Value;

  inherited SetName(Value);
end;

procedure TPCheckBox.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);

  if SubLabel = nil then
    Exit;

  SubLabel.Parent := AParent;
  SubLabel.Visible := True;
end;

procedure TPCheckBox.SetupInternalLabel;
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
