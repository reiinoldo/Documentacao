unit uGerarXMI;

interface

uses SysUtils, Contnrs, Classes, xmldom, XMLIntf, msxmldom, XMLDoc,
     uMetodo, uAtributo, uClasse, uAtorXMI, uCasoDeUso;

var
  ListaObj : TObjectList;

  procedure gerarXMI;

implementation

function getValor(pValor: String): String;
begin

  if POS('=', pValor) > 0 then
    Result := Trim(Copy(pValor, POS('=', pValor) + 2, Length(pValor)))
  else if POS('object', pValor) > 0 then
    Result := Trim(Copy(pValor, POS('object', pValor) + 7, POS(':', pValor) - (POS('object', pValor) + 7 )))
  else
    Result := 'Não encontrado ' + pValor;

end;

function ehAtributo(const pIndice: Integer; const pConteudoArquivo: TStringList): Boolean;
var
  vLinha : Integer;
begin

  Result := False;

  if (POS('TAreaTexto', pConteudoArquivo.Strings[pIndice]) > 0) or
     (POS('TBotaoSelecao', pConteudoArquivo.Strings[pIndice]) > 0) or
     (POS('TCaixaCombinacao', pConteudoArquivo.Strings[pIndice]) > 0) or
     (POS('TCaixaSelecao', pConteudoArquivo.Strings[pIndice]) > 0) or
     (POS('TCaixaTexto', pConteudoArquivo.Strings[pIndice]) > 0) or
     (POS('TImagem', pConteudoArquivo.Strings[pIndice]) > 0) then
    Result := True
  else if (POS('TRotulo', pConteudoArquivo.Strings[pIndice]) > 0) then
  begin

    vLinha := pIndice;
    inc(vLinha);
    while trim(pConteudoArquivo.Strings[vLinha]) <> 'end' do
    begin

      if (Pos('Documentacao.Atributo', pConteudoArquivo.Strings[vLinha]) > 0) and
         (getValor(pConteudoArquivo.Strings[vLinha]) = 'True') then
        Result := True;

      inc(vLinha);

    end;

  end;

end;

function ehClasse(const pIndice: Integer; const pConteudoArquivo: TStringList): Boolean;
var
  vLinha : Integer;
begin

  Result := False;

  //Se for primeira linha do arquivo é classe
  if (pIndice = 0) then
    Result := True
  else if (POS('TGrade', pConteudoArquivo.Strings[pIndice]) > 0) then
  begin  // Verifica se a grade é uma classe

    vLinha := pIndice;
    inc(vLinha);
    while trim(pConteudoArquivo.Strings[vLinha]) <> 'end' do
    begin

      if (Pos('Documentacao.Classe', pConteudoArquivo.Strings[vLinha]) > 0) and
         (getValor(pConteudoArquivo.Strings[vLinha]) = 'True') then
        Result := True;

      inc(vLinha);

    end;

  end;

end;

function ehMetodo(const pLinha: String): Boolean;
begin
  Result := POS('TBotao', pLinha) > 0;
end;

procedure lerArquivo;
var
  vArquivo: TStringList;
  vIndice: Integer;
  Classe: TClasse;
  Atributo: TAtributo;
  Metodo: TMetodo;
  Ator: TAtorXMI;
  CasoDeUso: TCasoDeUso;
begin

  vArquivo := TStringList.Create;

  vArquivo.LoadFromFile('D:\Development\GitHub\Testes\Unit1.fmx');

  vIndice := 0;

  ListaObj := TObjectList.Create;

  while vIndice <= Pred(vArquivo.Count) do
  begin

    if ehClasse(vIndice, vArquivo) then
    begin

      Classe := TClasse.Create;
      Classe.id := vIndice;
      Classe.nome := getValor(vArquivo.Strings[vIndice]);
      ListaObj.Add(Classe);

    end
    else if EhAtributo(vIndice, vArquivo) then
    begin

      Atributo := TAtributo.Create;
      Atributo.id := vIndice;
      Atributo.nome := getValor(vArquivo.Strings[vIndice]);
      inc(vIndice);
      while trim(vArquivo.Strings[vIndice]) <> 'end' do
      begin

        if Pos('Documentacao.Visibilidade', vArquivo.Strings[vIndice]) > 0 then
          Atributo.visibilidade := getValor(vArquivo.Strings[vIndice])
        else if Pos('Documentacao.Tipo', vArquivo.Strings[vIndice]) > 0 then
          Atributo.tipo := getValor(vArquivo.Strings[vIndice]);

        inc(vIndice);

      end;

      ListaObj.Add(Atributo);

    end
    else if EhMetodo(vArquivo.Strings[vIndice]) then
    begin

      Metodo := TMetodo.Create;
      Metodo.id := vIndice;
      Metodo.nome := getValor(vArquivo.Strings[vIndice]);

      inc(vIndice);
      while trim(vArquivo.Strings[vIndice]) <> 'end' do
      begin

        if Pos('Documentacao.Visibilidade', vArquivo.Strings[vIndice]) > 0 then
          Metodo.visibilidade := getValor(vArquivo.Strings[vIndice])
        else if Pos('Documentacao.Tipo', vArquivo.Strings[vIndice]) > 0 then
          Metodo.tipoRetorno := getValor(vArquivo.Strings[vIndice])
        else if Pos('Documentacao.Parametros.ListaDeParametros', vArquivo.Strings[vIndice]) > 0 then
          Metodo.listaDeParametros := getValor(vArquivo.Strings[vIndice])
        else if Pos('DocumentacaoAtor', vArquivo.Strings[vIndice]) > 0 then
        begin

          while trim(vArquivo.Strings[vIndice]) <> 'end>' do
          begin

            if Pos('Ator', vArquivo.Strings[vIndice]) > 0 then
            begin

              Ator := TAtorXMI.Create;
              Ator.id := vIndice;
              Ator.nome := getValor(vArquivo.Strings[vIndice]);

              CasoDeUso := TCasoDeUso.Create;
              CasoDeUso.id := Metodo.id;
              CasoDeUso.nome := Metodo.Nome;
              CasoDeUso.ator := Ator.id;

              ListaObj.Add(Ator);
              ListaObj.Add(CasoDeUso);

            end;

            Inc(vIndice);

          end;

        end;

        inc(vIndice);

      end;

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
  cabecalho, documentacao, content, model, nameespace, classe, Classifier, DataType, StructuralFeature: IXMLNode; //Padrão
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
      nodoAtributo.Text := 'addOnly';
      nodoElemento.AttributeNodes.Add(nodoAtributo);

      nodoAtributo := XMLDocument.CreateNode('ownerScope', ntAttribute);
      nodoAtributo.Text := 'instance';
      nodoElemento.AttributeNodes.Add(nodoAtributo);

      nodoAtributo := XMLDocument.CreateNode('isSpecification', ntAttribute);
      nodoAtributo.Text := 'false';
      nodoElemento.AttributeNodes.Add(nodoAtributo);

      nodoAtributo := XMLDocument.CreateNode('visibility', ntAttribute);
      nodoAtributo.Text := TAtributo(Obj).visibilidade;
      nodoElemento.AttributeNodes.Add(nodoAtributo);

      nodoAtributo := XMLDocument.CreateNode('name', ntAttribute);
      nodoAtributo.Text := TAtributo(Obj).nome;
      nodoElemento.AttributeNodes.Add(nodoAtributo);

      nodoAtributo := XMLDocument.CreateNode('xmi.id', ntAttribute);
      nodoAtributo.Text := IntToStr(TAtributo(Obj).id);
      nodoElemento.AttributeNodes.Add(nodoAtributo);



      DataType := XMLDocument.CreateNode('UML:DataType', ntElement);

      nodoAtributo := XMLDocument.CreateNode('isAbstract', ntAttribute);
      nodoAtributo.Text := 'false';
      DataType.AttributeNodes.Add(nodoAtributo);

      nodoAtributo := XMLDocument.CreateNode('isLeaf', ntAttribute);
      nodoAtributo.Text := 'false';
      DataType.AttributeNodes.Add(nodoAtributo);

      nodoAtributo := XMLDocument.CreateNode('isRoot', ntAttribute);
      nodoAtributo.Text := 'false';
      DataType.AttributeNodes.Add(nodoAtributo);

      nodoAtributo := XMLDocument.CreateNode('isSpecification', ntAttribute);
      nodoAtributo.Text := 'false';
      DataType.AttributeNodes.Add(nodoAtributo);

      nodoAtributo := XMLDocument.CreateNode('name', ntAttribute);
      nodoAtributo.Text := TAtributo(Obj).tipo;
      DataType.AttributeNodes.Add(nodoAtributo);

      nodoAtributo := XMLDocument.CreateNode('xmi.id', ntAttribute);
      nodoAtributo.Text := IntToStr(TAtributo(Obj).id);
      DataType.AttributeNodes.Add(nodoAtributo);

      StructuralFeature := XMLDocument.CreateNode('UML:StructuralFeature.type', ntElement);
      nodoElemento.ChildNodes.Add(StructuralFeature);
      StructuralFeature.ChildNodes.Add(DataType);

      Classifier := XMLDocument.CreateNode('UML:Classifier.feature', ntElement);
      classe.ChildNodes.Add(Classifier);
      Classifier.ChildNodes.Add(nodoElemento);

    end
    else if Obj.ClassNameIs('TMetodo') then
    begin

    end;

  end;

  XMLDocument.SaveToFile('D:\xmlexemplo2.xmi');
  XMLDocument.Active := False;

end;

end.
