{*******************************************************}
{                                                       }
{            Delphi Visual Component Library            }
{                                                       }
{ Copyright(c) 1995-2021 Embarcadero Technologies, Inc. }
{              All rights reserved                      }
{                                                       }
{*******************************************************}

unit PVclDBReg;

interface

procedure Register;

implementation

uses
  Windows, SysUtils, Classes, System.Actions, Controls, Forms, Mask, TypInfo, DB,
  DesignIntf, DesignEditors, DBConsts,
  ColnEdit, ActnList, PDBColnEd,
  DBCtrls, DBGrids, DBCGrids, DBActns,
  FileCtrl, ActiveX, DBOleCtl, PDBGrid;

{ TDBGridEditor }

type
  TDBGridEditor = class(TComponentEditor{$IFDEF LINUX}, IDesignerThreadAffinity{$ENDIF})
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

procedure TDBGridEditor.ExecuteVerb(Index: Integer);
begin
  ShowCollectionEditorClass(Designer, TDBGridColumnsEditor, Component,
    (Component as TPDBGrid).Columns, 'Columns');
end;

function TDBGridEditor.GetVerb(Index: Integer): string;
begin
  Result := 'Column Editor';
end;

function TDBGridEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

{ Registration }

procedure Register;
begin
  RegisterComponentEditor(TPDBGrid, TDBGridEditor);
end;

end.
