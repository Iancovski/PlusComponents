unit PDBGrid;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Themes, Vcl.Forms, Vcl.Grids, PDBGridClass,
  Winapi.Windows;

type
  TPDBGrid = class(TCustomPDBGrid)
  strict private
    class constructor Create;
    class destructor Destroy;
  protected
    procedure CellClick(Column: TColumn); override;
    procedure ChangeCheckBoxValue(Column: TColumn);
    procedure ColEnter; override;
    procedure ColExit; override;
    procedure DoEnter; override;
    procedure DrawColumnCell(const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
  private
    OldGridOptions: TDBGridOptions;
  public
    property Canvas;
    property SelectedRows;
  published
    property Align;
    property Anchors;
    property BiDiMode;
    property BorderStyle;
    property Color;
    [Stored(False)]
    property Columns stored False;
    property Constraints;
    property Ctl3D;
    property DataSource;
    property DefaultDrawing;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DrawingStyle;
    property Enabled;
    property FixedColor;
    property GradientEndColor;
    property GradientStartColor;
    property Font;
    property ImeMode;
    property ImeName;
    property Options;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property TitleFont;
    property Touch;
    property Visible;
    property StyleElements;
    property StyleName;
    property OnCellClick;
    property OnColEnter;
    property OnColExit;
    property OnColumnMoved;
    property OnDrawDataCell;
    property OnDrawColumnCell;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEditButtonClick;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGesture;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnStartDock;
    property OnStartDrag;
    property OnTitleClick;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Plus Components - Data Controls', [TPDBGrid]);
end;

{ TPDBGrid }

procedure TPDBGrid.CellClick(Column: TColumn);
begin
  if Column.CheckBox then
    ChangeCheckBoxValue(Column);
end;

procedure TPDBGrid.ChangeCheckBoxValue(Column: TColumn);
begin
  if DataSource.Dataset.IsEmpty then
    Exit;

  DataSource.Dataset.Edit;

  if (DataSource.Dataset.FieldByName(Column.FieldName).AsVariant = Column.CheckBoxValues.CheckedValue) or
    (DataSource.Dataset.FieldByName(Column.FieldName).IsNull and (Column.CheckBoxValues.NullValue = cvUnchecked)) then
    DataSource.Dataset.FieldByName(Column.FieldName).AsVariant := Column.CheckBoxValues.UncheckedValue
  else
    DataSource.Dataset.FieldByName(Column.FieldName).AsVariant := Column.CheckBoxValues.CheckedValue;

  DataSource.Dataset.Post;
end;

procedure TPDBGrid.ColEnter;
begin
  inherited;

  if Columns[SelectedIndex].CheckBox then begin
    OldGridOptions := Options;
    Options := Options - [dgEditing];
  end;
end;

procedure TPDBGrid.ColExit;
begin
  inherited;

  if Columns[SelectedIndex].CheckBox then begin
    Options := OldGridOptions;
  end;
end;

class constructor TPDBGrid.Create;
begin
  TCustomStyleEngine.RegisterStyleHook(TPDBGrid, TScrollingStyleHook);
end;

class destructor TPDBGrid.Destroy;
begin
  TCustomStyleEngine.UnRegisterStyleHook(TPDBGrid, TScrollingStyleHook);
end;

procedure TPDBGrid.DoEnter;
begin
  inherited;

  ColEnter;
end;

procedure TPDBGrid.DrawColumnCell(const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  vChecked: Integer;
  vRect: TRect;
begin
  inherited;

  if DataSource.Dataset.IsEmpty then
    Exit;

  if Column.CheckBox then begin
    Canvas.FillRect(Rect);

    if (DataSource.Dataset.FieldByName(Column.FieldName).AsVariant = Column.CheckBoxValues.CheckedValue) or
      (DataSource.Dataset.FieldByName(Column.FieldName).IsNull and (Column.CheckBoxValues.NullValue = cvUnchecked)) then
      vChecked := DFCS_CHECKED
    else
      vChecked := 0;

    vRect := Rect;
    InflateRect(vRect, -2, -2);
    DrawFrameControl(Canvas.Handle, vRect, DFC_BUTTON, DFCS_BUTTONCHECK or vChecked);
  end;
end;

procedure TPDBGrid.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;

  if Key = VK_SPACE then begin
    if Columns[SelectedIndex].CheckBox then
      ChangeCheckBoxValue(Columns[SelectedIndex]);
  end;
end;

end.
