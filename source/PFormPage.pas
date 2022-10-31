unit PFormPage;

interface

uses
  System.SysUtils, System.Classes, Vcl.ExtCtrls, Vcl.Forms,
  Vcl.StdCtrls, Vcl.Buttons, System.UITypes, Vcl.Graphics, Vcl.Controls;

type
  TTabColors = class(TPersistent)
  private
    FFocusedColor: TColor;
    FUnfocusedColor: TColor;
    procedure SetFocusedColor(const Value: TColor);
    procedure SetUnfocusedColor(const Value: TColor);
  published
    property FocusedColor: TColor read FFocusedColor write SetFocusedColor default $00F6F6F6;
    property UnfocusedColor: TColor read FUnfocusedColor write SetUnfocusedColor default $00EBEBEB;
  end;

  TPTab = class(TPanel)
  private
    FTabSeparator: TPanel;
    FTabButton: TSpeedButton;
    FTabLabel: TLabel;

    procedure TabClick(Sender: TObject);
    procedure CloseClick(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    property TabLabel: TLabel read FTabLabel;
    property TabButton: TSpeedButton read FTabButton;
    property TabSeparator: TPanel read FTabSeparator;
  end;

  TPPage = class(TPanel)
  private
    FForm: TForm;
    FTab: TPTab;
    FActive: Boolean;
    procedure SetForm(const Value: TForm);
    procedure SetTab(const Value: TPTab);
    procedure SetActive(const Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    property Active: Boolean read FActive write SetActive;
    property Tab: TPTab read FTab write SetTab;
    property Form: TForm read FForm write SetForm;
  end;

  TPFormPage = class(TPanel)
  private
    FTabColors: TTabColors;
    FTabScrollBox: TScrollBox;
    FTabFlowPanel: TFlowPanel;
    procedure SetTabColors(const Value: TTabColors);
  protected
    property TabScrollBox: TScrollBox read FTabScrollBox;
    property TabFlowPanel: TFlowPanel read FTabFlowPanel;
    procedure FocusOnTab(ATab: TPTab);
  public
    constructor Create(AOwner: TComponent); override;
    function GetPage(ATab: TPTab): TPPage; overload;
    function GetPage(AForm: TForm): TPPage; overload;
    function GetActivePage: TPPage;
    function NewPage(AForm: TForm): TPPage;
    procedure FocusOnPage(AForm: TForm); overload;
  published
    property TabColors: TTabColors read FTabColors write SetTabColors;
  end;

procedure Register;

implementation

uses
  Winapi.Windows;

procedure Register;
begin
  RegisterComponents('Plus Components - Standard', [TPFormPage]);
end;

{ TTabColors }

procedure TTabColors.SetFocusedColor(const Value: TColor);
begin
  FFocusedColor := Value;
end;

procedure TTabColors.SetUnfocusedColor(const Value: TColor);
begin
  FUnfocusedColor := Value;
end;

{ TPTab }

constructor TPTab.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  Self.Align := alLeft;
  Self.AutoSize := True;
  Self.BevelOuter := bvNone;
  Self.Caption := EmptyStr;
  Self.Height := 25;
  Self.Parent := TFlowPanel(AOwner);
  Self.ParentBackground := False;

  Self.FTabSeparator := TPanel.Create(Self);
  Self.FTabSeparator.Align := alLeft;
  Self.FTabSeparator.AlignWithMargins := True;
  Self.FTabSeparator.Caption := EmptyStr;
  Self.FTabSeparator.Color := clBlack;
  Self.FTabSeparator.Margins.SetBounds(0, 5, 0, 5);
  Self.FTabSeparator.Parent := Self;
  Self.FTabSeparator.Width := 1;

  Self.FTabButton := TSpeedButton.Create(Self);
  Self.FTabButton.Align := alLeft;
  Self.FTabButton.AlignWithMargins := True;
  Self.FTabButton.Caption := 'X';
  Self.FTabButton.Font.Name := 'Roboto Lt';
  Self.FTabButton.Flat := True;
  Self.FTabButton.Margins.SetBounds(5, 5, 5, 5);
  Self.FTabButton.OnClick := Self.CloseClick;
  Self.FTabButton.Parent := Self;
  Self.FTabButton.Width := 15;

  Self.FTabLabel := TLabel.Create(Self);
  Self.FTabLabel.Align := alLeft;
  Self.FTabLabel.Layout := tlCenter;
  Self.FTabLabel.OnClick := Self.TabClick;
  Self.FTabLabel.Parent := Self;
end;

procedure TPTab.CloseClick(Sender: TObject);
var
  i: Integer;
  vTabIndex: Integer;
  vForm: TForm;
begin
  if (TFlowPanel(Self.Owner).ComponentCount > 1) and //
    (TPFormPage(Self.Owner.Owner).GetPage(Self) = TPFormPage(Self.Owner.Owner).GetActivePage) then begin

    vTabIndex := 1;

    for i := 0 to TFlowPanel(Self.Owner).ComponentCount - 1 do begin
      if TPTab(TFlowPanel(Self.Owner).Components[i]) = Self then begin
        vTabIndex := i;
        Break;
      end;
    end;

    if vTabIndex = 0 then
      vForm := TPFormPage(Self.Owner.Owner).GetPage(TPTab(TFlowPanel(Self.Owner).Components[vTabIndex + 1])).Form
    else
      vForm := TPFormPage(Self.Owner.Owner).GetPage(TPTab(TFlowPanel(Self.Owner).Components[vTabIndex - 1])).Form;

    TPFormPage(Self.Owner.Owner).FocusOnPage(vForm);
  end;

  TPFormPage(Self.Owner.Owner).GetPage(Self).Destroy;
  Self.Destroy;
end;

procedure TPTab.TabClick(Sender: TObject);
begin
  TPFormPage(Self.Owner.Owner).FocusOnPage(TPFormPage(Self.Owner.Owner).GetPage(Self).Form);
end;

{ TPPage }

constructor TPPage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  Self.Align := alClient;
  Self.BevelOuter := bvNone;
  Self.Caption := EmptyStr;
  Self.Parent := TWinControl(AOwner);
end;

procedure TPPage.SetActive(const Value: Boolean);
var
  i: Integer;
begin
  FActive := Value;

  if FActive then begin
    for i := 0 to Self.Owner.ComponentCount - 1 do begin
      if Self.Owner.Components[i] is TPPage then begin
        if TPPage(Self.Owner.Components[i]) <> Self then begin
          TPPage(Self.Owner.Components[i]).Active := False;
        end;
      end;
    end;
  end;
end;

procedure TPPage.SetForm(const Value: TForm);
begin
  FForm := Value;

  FForm.Parent := Self;
end;

procedure TPPage.SetTab(const Value: TPTab);
begin
  FTab := Value;
end;

{ TPFormPage }

constructor TPFormPage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  Self.Caption := EmptyStr;
  Self.BevelOuter := bvNone;

  Self.FTabScrollBox := TScrollBox.Create(Self);
  Self.FTabScrollBox.Align := alTop;
  Self.FTabScrollBox.BevelInner := bvNone;
  Self.FTabScrollBox.BevelOuter := bvNone;
  Self.FTabScrollBox.BorderStyle := bsNone;
  Self.FTabScrollBox.Height := 25;
  Self.FTabScrollBox.Parent := Self;

  Self.FTabFlowPanel := TFlowPanel.Create(Self);
  Self.FTabFlowPanel.Align := alLeft;
  Self.FTabFlowPanel.AutoSize := True;
  Self.FTabFlowPanel.AutoWrap := False;
  Self.FTabFlowPanel.Caption := EmptyStr;
  Self.FTabFlowPanel.BevelOuter := bvNone;
  Self.FTabFlowPanel.Parent := Self.TabScrollBox;

  Self.FTabColors := TTabColors.Create;
  Self.FTabColors.FocusedColor := $00F6F6F6;
  Self.FTabColors.UnfocusedColor := $00EBEBEB;
end;

procedure TPFormPage.FocusOnPage(AForm: TForm);
var
  vPage: TPPage;
begin
  vPage := GetPage(AForm);

  vPage.Active := True;
  vPage.BringToFront;

  FocusOnTab(vPage.Tab);
end;

procedure TPFormPage.FocusOnTab(ATab: TPTab);
var
  vTabIndex, vFocusedTabIndex: Integer;
begin
  vFocusedTabIndex := 0;

  for vTabIndex := 0 to Self.TabFlowPanel.ComponentCount - 1 do begin
    if TPTab(Self.TabFlowPanel.Components[vTabIndex]) = ATab then begin
      TPTab(Self.TabFlowPanel.Components[vTabIndex]).Color := Self.TabColors.FocusedColor;
      TPTab(Self.TabFlowPanel.Components[vTabIndex]).TabSeparator.Visible := False;
      vFocusedTabIndex := vTabIndex;
    end
    else begin
      TPTab(Self.TabFlowPanel.Components[vTabIndex]).Color := Self.TabColors.UnfocusedColor;
      TPTab(Self.TabFlowPanel.Components[vTabIndex]).TabSeparator.Visible := True;
    end;
  end;

  if vFocusedTabIndex > 0 then
    TPTab(Self.TabFlowPanel.Components[vFocusedTabIndex - 1]).TabSeparator.Visible := False;

  TPTab(Self.TabFlowPanel.Components[Self.TabFlowPanel.ComponentCount - 1]).TabSeparator.Visible := False;
end;

function TPFormPage.GetActivePage: TPPage;
var
  i: Integer;
begin
  Result := nil;

  for i := 0 to Self.ComponentCount - 1 do begin
    if Self.Components[i] is TPPage then begin
      if TPPage(Self.Components[i]).Active then begin
        Result := TPPage(Self.Components[i]);
        Break;
      end;
    end;
  end;
end;

function TPFormPage.GetPage(AForm: TForm): TPPage;
var
  i: Integer;
begin
  Result := nil;

  for i := 0 to Self.ComponentCount - 1 do begin
    if Self.Components[i] is TPPage then begin
      if TPPage(Self.Components[i]).Form = AForm then begin
        Result := TPPage(Self.Components[i]);
        Break;
      end;
    end;
  end;
end;

function TPFormPage.GetPage(ATab: TPTab): TPPage;
var
  i: Integer;
begin
  Result := nil;

  for i := 0 to Self.ComponentCount - 1 do begin
    if Self.Components[i] is TPPage then begin
      if TPPage(Self.Components[i]).Tab = ATab then begin
        Result := TPPage(Self.Components[i]);
        Break;
      end;
    end;
  end;
end;

function TPFormPage.NewPage(AForm: TForm): TPPage;
var
  vPage: TPPage;
  vTab: TPTab;
begin
  vPage := TPPage.Create(Self);
  vTab := TPTab.Create(Self.TabFlowPanel);

  vPage.Tab := vTab;
  vPage.Form := AForm;
  vTab.TabLabel.Caption := '  ' + AForm.Caption;

  FocusOnPage(AForm);

  Result := vPage;

  ShowScrollBar(Self.Handle, SB_VERT, False);
end;

procedure TPFormPage.SetTabColors(const Value: TTabColors);
begin
  FTabColors := Value;
end;

end.
