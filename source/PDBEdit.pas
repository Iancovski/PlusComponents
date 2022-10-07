unit PDBEdit;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls, Vcl.Dialogs,
  Winapi.Messages, Winapi.Windows, PLabel;

type
  TLabelPosition = (lpAbove, lpBelow, lpLeft, lpRight);

type
  TPDBEdit = class(TDBEdit)

  private
    FEditLabel: TPLabel;
    FLabelPosition: TLabelPosition;
    FLabelSpacing: Integer;
    procedure SetEditLabel(const Value: TPLabel);

  protected
    function AdjustedAlignment(RightToLeftAlignment: Boolean; Alignment: TAlignment): TAlignment;
    procedure CMBidimodechanged(var Message: TMessage); message CM_BIDIMODECHANGED;
    procedure CMEnabledchanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMVisiblechanged(var Message: TMessage); message CM_VISIBLECHANGED;
    procedure SetName(const Value: TComponentName); override;
    procedure SetParent(AParent: TWinControl); override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft: Integer; ATop: Integer; AWidth: Integer; AHeight: Integer); override;
    procedure SetLabelPosition(const Value: TLabelPosition);
    procedure SetLabelSpacing(const Value: Integer);

  published
    property EditLabel: TPLabel read FEditLabel write SetEditLabel;
    property LabelPosition: TLabelPosition read FLabelPosition write SetLabelPosition default lpAbove;
    property LabelSpacing: Integer read FLabelSpacing write SetLabelSpacing default 3;

  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Plus Components - Data Controls', [TPDBEdit]);
end;

{ TPDBEdit }

function TPDBEdit.AdjustedAlignment(RightToLeftAlignment: Boolean; Alignment: TAlignment): TAlignment;
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

procedure TPDBEdit.CMBidimodechanged(var Message: TMessage);
begin
  inherited;

  if Assigned(FEditLabel) then
    FEditLabel.BiDiMode := BiDiMode;
end;

procedure TPDBEdit.CMEnabledchanged(var Message: TMessage);
begin
  inherited;

  if Assigned(FEditLabel) then
    FEditLabel.Enabled := Enabled;
end;

procedure TPDBEdit.CMVisiblechanged(var Message: TMessage);
begin
  inherited;

  if Assigned(FEditLabel) then
    FEditLabel.Visible := Visible;
end;

constructor TPDBEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FLabelPosition := lpAbove;
  FLabelSpacing := 3;
end;

destructor TPDBEdit.Destroy;
begin
  if Assigned(FEditLabel) then
    FEditLabel.Destroy;

  inherited;
end;

procedure TPDBEdit.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);

  if Assigned(FEditLabel) then
    SetLabelPosition(FLabelPosition);
end;

procedure TPDBEdit.SetEditLabel(const Value: TPLabel);
begin
  if (Value <> nil) and (Self.Owner <> Value.Owner) then begin
    ShowMessage('It is not allowed to set a EditLabel of another Owner.');
    Abort;
  end;

  FEditLabel := Value;

  if Assigned(FEditLabel) then begin
    FEditLabel.MasterLabel := nil;
    SetLabelPosition(FLabelPosition);
  end;
end;

procedure TPDBEdit.SetLabelPosition(const Value: TLabelPosition);
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

procedure TPDBEdit.SetLabelSpacing(const Value: Integer);
begin
  FLabelSpacing := Value;

  if Assigned(FEditLabel) then
    SetLabelPosition(FLabelPosition);
end;

procedure TPDBEdit.SetName(const Value: TComponentName);
begin
  if (csDesigning in ComponentState) and Assigned(FEditLabel) and
    ((FEditLabel.GetTextLen = 0) or (CompareText(FEditLabel.Caption, Name) = 0)) then
    FEditLabel.Caption := Value;

  inherited SetName(Value);
end;

procedure TPDBEdit.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);

  if not Assigned(FEditLabel) then
    Exit;

  FEditLabel.Parent := AParent;
  FEditLabel.Visible := True;
end;

end.
