unit uPluginXMI;

interface

uses ToolsApi, VCL.Menus, VCL.Forms;

type
  TPluginXMI = Class
    private
      procedure Execute(Sender: TObject);
      procedure AdicionaMenu;

  End;

  var
    MenuIDE: TMainMenu;
    obj : TPluginXMI;

implementation

uses uPluginTela;

{ TPluginXMI }


procedure TPluginXMI.AdicionaMenu;
var
  menuItem : TMenuItem;
begin
  menuItem := TMenuItem.Create(Application);
  menuItem.Caption := 'Documentação';
  menuItem.OnClick := Execute;
  MenuIDE.Items.Find('Help').Add(menuItem);
end;

procedure TPluginXMI.Execute(Sender: TObject);
begin
  PluginTela.Show;
end;

initialization
  MenuIDE := (ToolsApi.BorlandIDEServices as INTAServices).MainMenu;
  obj :=  TPluginXMI.Create;
  obj.AdicionaMenu;
  PluginTela := TPluginTela.Create(nil);

finalization
  PluginTela.Free;
  Obj.Free;

end.
