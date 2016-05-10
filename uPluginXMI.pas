unit uPluginXMI;

interface

uses ToolsApi, VCL.Menus, VCL.Forms;

type
  TPluginXMI = Class
    private
      procedure Teste(Sender: TObject);
      procedure AdicionaMenu;

  End;

  var
    MenuIDE: TMainMenu;
    obj : TPluginXMI;

implementation

uses Fmx.dialogs;

{ TPluginXMI }

procedure TPluginXMI.AdicionaMenu;
var
  menuItem : TMenuItem;
begin
  menuItem := TMenuItem.Create(Application);
  menuItem.Caption := 'Documentação';
  menuItem.OnClick := Teste;
//  if Assigned(menuItem.Find('Help')) then
    MenuIDE.Items.Find('Tools').Add(menuItem);


end;

procedure TPluginXMI.Teste(Sender: TObject);
begin
 SHowMEssage('Funfa');
end;

initialization
  MenuIDE := (ToolsApi.BorlandIDEServices as INTAServices).MainMenu;
  obj :=  TPluginXMI.Create;
  obj.AdicionaMenu
finalization

end.
