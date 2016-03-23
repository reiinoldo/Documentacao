unit uGerarXMI;

interface
uses SysUtils, Contnrs, Classes, xmldom, XMLIntf, msxmldom, XMLDoc;

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

var
  ListaObj : TObjectList;

  procedure gerarXMI;

implementation

function ehAtributo(const pLinha: String): Boolean;
begin
  Result := POS('TCaixaTexto', pLinha) > 0;
end;

function ehMetodo(const pLinha: String): Boolean;
begin
  Result := POS('TBotao', pLinha) > 0;
end;

function getValor(pValor: String): String;
begin

  if POS('=', pValor) > 0 then
    Result := Trim(Copy(pValor, POS('=', pValor) + 2, Length(pValor)))
  else if POS('object', pValor) > 0 then
    Result := Trim(Copy(pValor, POS('object', pValor) + 7, POS(':', pValor) - (POS('object', pValor) + 7 )))
  else
    Result := 'Não encontrado ' + pValor;

end;


procedure lerArquivo;
var
  vArquivo : TStringList;
  vIndice : Integer;
  Classe : TClasse;
  Atributo: TAtributo;
  Metodo: TMetodo;
begin

  vArquivo := TStringList.Create;

  vArquivo.LoadFromFile('C:\Users\Reinoldo\Documents\Embarcadero\Studio\Projects\utesteCadastroUsuario.fmx');

  vIndice := 0;

  ListaObj := TObjectList.Create;

  while vIndice <= Pred(vArquivo.Count) do
  begin

    if vIndice = 0 then
    begin

      Classe := TClasse.Create;
      Classe.id := vIndice;
      Classe.nome := getValor(vArquivo.Strings[vIndice]);
      ListaObj.Add(Classe);
    end
    else if EhAtributo(vArquivo.Strings[vIndice]) then
    begin

      Atributo := TAtributo.Create;
      Atributo.id := vIndice;
      Atributo.nome := getValor(vArquivo.Strings[vIndice]);
      inc(vIndice);
      while trim(vArquivo.Strings[vIndice]) <> 'end' do
      begin

        if Pos('Visibilidade', vArquivo.Strings[vIndice]) > 0 then
          Atributo.visibilidade := getValor(vArquivo.Strings[vIndice])
        else if Pos('Modificabilidade', vArquivo.Strings[vIndice]) > 0 then
          Atributo.modificabilidade := getValor(vArquivo.Strings[vIndice])
        else if Pos('Tipo', vArquivo.Strings[vIndice]) > 0 then
          Atributo.tipo := getValor(vArquivo.Strings[vIndice]);

        inc(vIndice)
      end;

      ListaObj.Add(Atributo);
    end
    else if EhMetodo(vArquivo.Strings[vIndice]) then
    begin

      Metodo := TMetodo.Create;
      Metodo.id := vIndice;
      Metodo.nome := getValor(vArquivo.Strings[vIndice]);

      ListaObj.Add(Metodo);
    end;

    Inc(vIndice);

  end;

end;

procedure gerarXMI;
var
  Obj : TObject;
  Raiz: IXMLNode;
  nodoElemento, nodoAtributo: IXMLNode; // Uso Geral
  cabecalho, documentacao, content, model, nameespace, classe, Classifier: IXMLNode; //Padrão
  XMLDocument : TXMLDocument;
  i : Integer;
begin

  XMLDocument := TXMLDocument.Create(nil);
  XMLDocument.FileName := '';
  XMLDocument.XML.Text := '';
  XMLDocument.Active := False;
  XMLDocument.Active := True;
  XMLDocument.Version := '1.0';
  XMLDocument.Encoding := 'UTF-8';

  // Criando a RAIZ
  Raiz := XMLDocument.AddChild('XMI');
  // Atributos
  nodoAtributo := XMLDocument.CreateNode('xmlns:UML', ntAttribute);
  nodoAtributo.Text := 'org.omg.xmi.namespace.UML';
  Raiz.AttributeNodes.Add(nodoAtributo);

  nodoAtributo := XMLDocument.CreateNode('xmi.version', ntAttribute);
  nodoAtributo.Text := '1.2';
  Raiz.AttributeNodes.Add(nodoAtributo);

  // Criando outro nodulo na RAIZ (um node filho de RAIZ)
  cabecalho := XMLDocument.CreateNode('XMI.header', ntElement);
  Raiz.ChildNodes.Add(cabecalho);

  documentacao := XMLDocument.CreateNode('XMI.documentation', ntElement);
  cabecalho.ChildNodes.Add(documentacao);

  nodoElemento := XMLDocument.CreateNode('XMI.exporter', ntElement);
  nodoElemento.Text := 'TCC Reinoldo';
  documentacao.ChildNodes.Add(nodoElemento);

  nodoElemento := XMLDocument.CreateNode('XMI.metamodel', ntElement);
  cabecalho.ChildNodes.Add(nodoElemento);

  nodoAtributo := XMLDocument.CreateNode('xmi.version', ntAttribute);
  nodoAtributo.Text := '1.4';
  nodoElemento.AttributeNodes.Add(nodoAtributo);

  nodoAtributo := XMLDocument.CreateNode('xmi.name', ntAttribute);
  nodoAtributo.Text := 'UML';
  nodoElemento.AttributeNodes.Add(nodoAtributo);

  content := XMLDocument.CreateNode('XMI.content', ntElement);
  Raiz.ChildNodes.Add(content);

  model := XMLDocument.CreateNode('UML:Model', ntElement);

  nodoAtributo := XMLDocument.CreateNode('isAbstract', ntAttribute);
  nodoAtributo.Text := 'false';
  model.AttributeNodes.Add(nodoAtributo);

  nodoAtributo := XMLDocument.CreateNode('isLeaf', ntAttribute);
  nodoAtributo.Text := 'false';
  model.AttributeNodes.Add(nodoAtributo);

  nodoAtributo := XMLDocument.CreateNode('isRoot', ntAttribute);
  nodoAtributo.Text := 'false';
  model.AttributeNodes.Add(nodoAtributo);

  nodoAtributo := XMLDocument.CreateNode('isSpecification', ntAttribute);
  nodoAtributo.Text := 'false';
  model.AttributeNodes.Add(nodoAtributo);

  nodoAtributo := XMLDocument.CreateNode('name', ntAttribute);
  nodoAtributo.Text := 'Modelo';
  model.AttributeNodes.Add(nodoAtributo);

  nodoAtributo := XMLDocument.CreateNode('xmi.id', ntAttribute);
  nodoAtributo.Text := '1';
  model.AttributeNodes.Add(nodoAtributo);

  content.ChildNodes.Add(model);

  nameespace := XMLDocument.CreateNode('UML:Namespace.ownedElement', ntElement);
  model.ChildNodes.Add(nameespace);

  lerArquivo;

  for I := 0 to ListaObj.Count - 1 do
  begin
    Obj := ListaObj.Items[i];

    if Obj.ClassNameIs('TClasse') then
    begin

      classe := XMLDocument.CreateNode('UML:Class', ntElement);

      nodoAtributo := XMLDocument.CreateNode('isActive', ntAttribute);
      nodoAtributo.Text := 'false';
      classe.AttributeNodes.Add(nodoAtributo);

      nodoAtributo := XMLDocument.CreateNode('isAbstract', ntAttribute);
      nodoAtributo.Text := 'false';
      classe.AttributeNodes.Add(nodoAtributo);

      nodoAtributo := XMLDocument.CreateNode('isLeaf', ntAttribute);
      nodoAtributo.Text := 'false';
      classe.AttributeNodes.Add(nodoAtributo);

      nodoAtributo := XMLDocument.CreateNode('isRoot', ntAttribute);
      nodoAtributo.Text := 'false';
      classe.AttributeNodes.Add(nodoAtributo);

      nodoAtributo := XMLDocument.CreateNode('isSpecification', ntAttribute);
      nodoAtributo.Text := 'false';
      classe.AttributeNodes.Add(nodoAtributo);

      nodoAtributo := XMLDocument.CreateNode('visibility', ntAttribute);
      nodoAtributo.Text := 'public';
      classe.AttributeNodes.Add(nodoAtributo);

      nodoAtributo := XMLDocument.CreateNode('name', ntAttribute);
      nodoAtributo.Text := TClasse(Obj).nome;
      classe.AttributeNodes.Add(nodoAtributo);

      nodoAtributo := XMLDocument.CreateNode('xmi.id', ntAttribute);
      nodoAtributo.Text := IntToStr(TClasse(Obj).id);
      classe.AttributeNodes.Add(nodoAtributo);

      nameespace.ChildNodes.Add(classe);

    end
    else if Obj.ClassNameIs('TAtributo') then
    begin

      nodoElemento := XMLDocument.CreateNode('UML:Attribute', ntElement);

      nodoAtributo := XMLDocument.CreateNode('targetScope', ntAttribute);
      nodoAtributo.Text := 'instance';
      nodoElemento.AttributeNodes.Add(nodoAtributo);

      nodoAtributo := XMLDocument.CreateNode('changeability', ntAttribute);
      if TAtributo(Obj).modificabilidade = 'apenasAdicionar' then
        nodoAtributo.Text := 'addOnly';

      nodoElemento.AttributeNodes.Add(nodoAtributo);

      nodoAtributo := XMLDocument.CreateNode('ownerScope', ntAttribute);
      nodoAtributo.Text := 'instance';
      nodoElemento.AttributeNodes.Add(nodoAtributo);

      nodoAtributo := XMLDocument.CreateNode('isSpecification', ntAttribute);
      nodoAtributo.Text := 'false';
      nodoElemento.AttributeNodes.Add(nodoAtributo);

      nodoAtributo := XMLDocument.CreateNode('visibility', ntAttribute);
      if TAtributo(Obj).visibilidade = 'publico' then
        nodoAtributo.Text := 'public';

      nodoElemento.AttributeNodes.Add(nodoAtributo);

      nodoAtributo := XMLDocument.CreateNode('name', ntAttribute);
      nodoAtributo.Text := TAtributo(Obj).nome;
      nodoElemento.AttributeNodes.Add(nodoAtributo);

      nodoAtributo := XMLDocument.CreateNode('xmi.id', ntAttribute);
      nodoAtributo.Text := IntToStr(TAtributo(Obj).id);
      nodoElemento.AttributeNodes.Add(nodoAtributo);


      Classifier := XMLDocument.CreateNode('UML:Classifier.feature', ntElement);
      classe.ChildNodes.Add(Classifier);
      Classifier.ChildNodes.Add(nodoElemento);


    end
    else if Obj.ClassNameIs('TMetodo') then
    begin

    end;

  end;

  XMLDocument.SaveToFile('D:\xmlexemplo.xmi');
  XMLDocument.Active := False;



end;



end.
