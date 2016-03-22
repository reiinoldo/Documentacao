unit uGerarXMI;

interface
uses SysUtils;

type
  TClasse = class
    private
      id: Integer;
      nome: String;
  end;

  TAtributo = class
    private
      id: Integer;
      nome: String;
      tipo: String;
      visibilidade: String;
      modificabilidade: String;
      valorInicial: String;
  end;

  TMetodo = class
    private
      id: Integer;
      nome: String;
      tipoRetorno: String;
  end;

  procedure gerarXMI;

implementation

uses Classes, SysUtils;

function ehAtributo(const pLinha: String): Boolean;
begin
  Result := POS('TCaixaTexto', pLinha) > 0;
end;

function ehMetodo(const pLinha: String): Boolean;
begin
  Result := POS('TBotao', pLinha) > 0;
end;

procedure lerArquivo;
var
  vArquivo : TStringList;
  vLinha : TStrings;
  vIndice : Integer;
  Classe : TClasse;
  Atributo: TAtributo;
  Metodo: TMetodo;
begin

  vArquivo := TStringList.Create;

  vArquivo.LoadFromFile('C:\Users\Reinoldo\Documents\Embarcadero\Studio\Projects\utesteCadastroUsuario.fmx');

  vIndice := 0;

  while vIndice <= Pred(vArquivo.Count) do
  begin

    if vIndice = 0 then
    begin

      Classe := TClasse.Create;
      Classe.id := vIndice;
      Classe.nome := vArquivo.Strings[vIndice];

    end
    else if EhAtributo(vLinha.Text) then
    begin

      Atributo := TAtributo.Create;
      Atributo.id := vIndice;
      Atributo.nome := vLinha.Text;
      inc(vIndice);
      while trim(vArquivo.Strings[vIndice]) = 'end' do
      begin

        if Pos('Visibilidade', vArquivo.Strings[vIndice]) > 0 then
          Atributo.visibilidade := vArquivo.Strings[vIndice]
        else if Pos('Modificabilidade', vArquivo.Strings[vIndice]) > 0 then
          Atributo.modificabilidade := vArquivo.Strings[vIndice];

        inc(vIndice)
      end;


    end
    else if EhMetodo(vLinha.Text) then
    begin

      Metodo := TMetodo.Create;
      Metodo.id := vIndice;
      Metodo.nome := vLinha.Text;

    end;

    Inc(vIndice);

  end;

end;

end.
