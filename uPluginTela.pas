unit uPluginTela;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Ani, FMX.Layouts, FMX.Gestures,
  FMX.StdCtrls, uCaixaSelecao, uBotao, uRotulo, FMX.Edit, uCaixaTexto,
  FMX.Controls.Presentation;

type
  TPluginTela = class(TForm)
    StyleBook1: TStyleBook;
    ToolbarHolder: TLayout;
    ToolbarPopup: TPopup;
    ToolbarPopupAnimation: TFloatAnimation;
    ToolBar1: TToolBar;
    ToolbarApplyButton: TButton;
    ToolbarCloseButton: TButton;
    ToolbarAddButton: TButton;
    localPrototipagem: TCaixaTexto;
    Rotulo1: TRotulo;
    localSalvar: TCaixaTexto;
    Rotulo2: TRotulo;
    gerar: TBotao;
    ProgressBar1: TProgressBar;
    IncluirSubpastas: TCaixaSelecao;
    Rotulo3: TRotulo;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    EditButton1: TEditButton;
    EditButton2: TEditButton;
    procedure ToolbarCloseButtonClick(Sender: TObject);
    procedure FormGesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure gerarClick(Sender: TObject);
    procedure EditButton1Click(Sender: TObject);
    procedure EditButton2Click(Sender: TObject);
  private
    FGestureOrigin: TPointF;
    FGestureInProgress: Boolean;
    { Private declarations }
    procedure ShowToolbar(AShow: Boolean);
  public
    { Public declarations }
  end;

var
  PluginTela: TPluginTela;

implementation

uses uGerarXMI;
{$R *.fmx}

procedure TPluginTela.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkEscape then
    ShowToolbar(not ToolbarPopup.IsOpen);
end;

procedure TPluginTela.ToolbarCloseButtonClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TPluginTela.gerarClick(Sender: TObject);
begin
  if gerarXMI then
    ShowMessage('Finalizado com sucesso!')
  else
    ShowMessage('Ops! Algo ocorreu de forma inesperada...');
end;

procedure TPluginTela.EditButton1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    localPrototipagem.Text := OpenDialog1.InitialDir;
end;

procedure TPluginTela.EditButton2Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
    localSalvar.Text := SaveDialog1.FileName;
end;

procedure TPluginTela.FormGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
var
  DX, DY : Single;
begin
  if EventInfo.GestureID = igiPan then
  begin
    if (TInteractiveGestureFlag.gfBegin in EventInfo.Flags)
      and ((Sender = ToolbarPopup)
        or (EventInfo.Location.Y > (ClientHeight - 70))) then
    begin
      FGestureOrigin := EventInfo.Location;
      FGestureInProgress := True;
    end;

    if FGestureInProgress and (TInteractiveGestureFlag.gfEnd in EventInfo.Flags) then
    begin
      FGestureInProgress := False;
      DX := EventInfo.Location.X - FGestureOrigin.X;
      DY := EventInfo.Location.Y - FGestureOrigin.Y;
      if (Abs(DY) > Abs(DX)) then
        ShowToolbar(DY < 0);
    end;
  end
end;

procedure TPluginTela.ShowToolbar(AShow: Boolean);
begin
  ToolbarPopup.Width := ClientWidth;
  ToolbarPopup.PlacementRectangle.Rect := TRectF.Create(0, ClientHeight-ToolbarPopup.Height, ClientWidth-1, ClientHeight-1);
  ToolbarPopupAnimation.StartValue := ToolbarPopup.Height;
  ToolbarPopupAnimation.StopValue := 0;

  ToolbarPopup.IsOpen := AShow;
end;

end.
