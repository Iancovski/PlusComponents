unit PEdit;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls,
  Winapi.Messages, Winapi.Windows, PLabel;

type
  TLabelPosition = (lpAbove, lpBelow, lpLeft, lpRight);

type
  TPEdit = class(TEdit)

  private
    FEditLabel: TPLabel;
    FLabeled: Boolean;
    FLabelPosition: TLabelPosition;
    FLabelSpacing: Integer;
    procedure SetLabeled(const Value: Boolean);

  protected
    function AdjustedAlignment(RightToLeftAlignment: Boolean; Alignment: TAlignment): TAlignment;
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
    procedure SetLabelPosition(const Value: TLabelPosition);
    procedure SetLabelSpacing(const Value: Integer);
    procedure SetupInternalLabel;

  published
    property EditLabel: TPLabel read FEditLabel;
    property Labeled: Boolean read FLabeled write SetLabeled default False;
    property LabelPosition: TLabelPosition read FLabelPosition write SetLabelPosition default lpAbove;
    property LabelSpacing: Integer read FLabelSpacing write SetLabelSpacing default 3;

  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Plus Components | Standard', [TPEdit]);
end;

{ TPEdit }

function TPEdit.AdjustedAlignment(RightToLeftAlignment: Boolean; Alignment: TAlignment): TAlignment;
begin
  Result := Alignment;

  if RightToLeftAlignment then begin
    case Result of
      taLeftJustify:
        Result := taRightJustify;
      taRightJustify:
        Result := taLeftJustify;
    end;
  end;
end;

procedure TPEdit.CMBidimodechanged(var Message: TMessage);
begin
  inherited;

  if FEditLabel <> nil then
    FEditLabel.BiDiMode := BiDiMode;
end;

procedure TPEdit.CMEnabledchanged(var Message: TMessage);
begin
  inherited;

  if FEditLabel <> nil then
    FEditLabel.Enabled := Enabled;
end;

procedure TPEdit.CMVisiblechanged(var Message: TMessage);
begin
  inherited;

  if FEditLabel <> nil then
    FEditLabel.Visible := Visible;
end;

constructor TPEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FLabelPosition := lpAbove;
  FLabelSpacing := 3;

  if FLabeled then
    SetupInternalLabel;
end;

destructor TPEdit.Destroy;
begin
  if Assigned(FEditLabel) then
    FEditLabel.Free;

  inherited;
end;

procedure TPEdit.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (AComponent = FEditLabel) and (Operation = opRemove) then
    FEditLabel := nil;
end;

procedure TPEdit.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);

  SetLabelPosition(FLabelPosition);
end;

procedure TPEdit.SetLabeled(const Value: Boolean);
begin
  FLabeled := Value;

  if FLabeled then
    SetupInternalLabel
  else if Assigned(FEditLabel) then
    FEditLabel.Free;
end;

procedure TPEdit.SetLabelPosition(const Value: TLabelPosition);
var
  P: TPoint;
begin
  if FEditLabel = nil then
    Exit;

  FLabelPosition := Value;

  case Value of
    lpAbove:
      case AdjustedAlignment(UseRightToLeftAlignment, Alignment) of
        taLeftJustify:
          P := Point(Left, Top - FEditLabel.Height - FLabelSpacing);
        taRightJustify:
          P := Point(Left + Width - FEditLabel.Width, Top - FEditLabel.Height - FLabelSpacing);
        taCenter:
          P := Point(Left + (Width - FEditLabel.Width) div 2, Top - FEditLabel.Height - FLabelSpacing);
      end;
    lpBelow:
      case AdjustedAlignment(UseRightToLeftAlignment, Alignment) of
        taLeftJustify:
          P := Point(Left, Top + Height + FLabelSpacing);
        taRightJustify:
          P := Point(Left + Width - FEditLabel.Width, Top + Height + FLabelSpacing);
        taCenter:
          P := Point(Left + (Width - FEditLabel.Width) div 2, Top + Height + FLabelSpacing);
      end;
    lpLeft:
      P := Point(Left - FEditLabel.Width - FLabelSpacing, Top + ((Height - FEditLabel.Height) div 2));
    lpRight:
      P := Point(Left + Width + FLabelSpacing, Top + ((Height - FEditLabel.Height) div 2));
  end;

  FEditLabel.SetBounds(P.x, P.y, FEditLabel.Width, FEditLabel.Height);
end;

procedure TPEdit.SetLabelSpacing(const Value: Integer);
begin
  FLabelSpacing := Value;
  SetLabelPosition(FLabelPosition);
end;

procedure TPEdit.SetName(const Value: TComponentName);
var
  LClearText: Boolean;
begin
  if (csDesigning in ComponentState) and (FEditLabel <> nil) and
    ((FEditLabel.GetTextLen = 0) or (CompareText(FEditLabel.Caption, Name) = 0)) then
    FEditLabel.Caption := Value;

  LClearText := (csDesigning in ComponentState) and (Text = '');

  inherited SetName(Value);

  if LClearText then
    Text := '';
end;

procedure TPEdit.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);

  if FEditLabel = nil then
    Exit;

  FEditLabel.Parent := AParent;
  FEditLabel.Visible := True;
end;

procedure TPEdit.SetupInternalLabel;
begin
  if Assigned(FEditLabel) then
    Exit;

  FEditLabel := TPLabel.Create(Self);
  FEditLabel.FreeNotification(Self);
  FEditLabel.FocusControl := Self;

  if not Assigned(FEditLabel.Parent) and Assigned(Self.Parent) then
    FEditLabel.Parent := Self.Parent;

  SetLabelPosition(FLabelPosition);
end;

end.
