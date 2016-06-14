unit uGerarXMI;

interface

uses SysUtils, Contnrs, Classes, xmldom, XMLIntf, msxmldom, XMLDoc, Generics.Collections,
     uMetodo, uAtributo, uClasse, uAtorXMI, uCasoDeUso, uRelacionamento, uTiposDeDados, uPropriedades,
     uEstereotipoXMI;

var
  ListaObj : TObjectList;
  ListaObjDados : TDictionary<String,TTiposDeDados>;
  ListaObjAtor : TDictionary<String,TAtorXMI>;
  ListaObjCaso : TDictionary<String,TCasoDeUso>;
  ListaObjRelacionamento : TDictionary<String,TRelacionamento>;
  ListaObjEstereotipo : TDictionary<String,TEstereotipoXMI>;
  vIdentificador: Integer;

  function gerarXMI(pDiretorio, pLocalSalvar: String): Boolean;
  function getIdentificador: Integer;

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
     (POS('TImagem', pConteudoArquivo.Strings[pIndice]) > 0) or
     (POS('TRotulo', pConteudoArquivo.Strings[pIndice]) > 0) then
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
      begin
        Result := True;
      end;

      inc(vLinha);

    end;

  end;

end;

function ehMetodo(const pLinha: String): Boolean;
begin
  Result := POS('TBotao', pLinha) > 0;
end;

function fncFillDir(const AMask: string): TStringList;
var
  SearchRec : TSearchRec;
  intControl : integer;
begin

  Result := TStringList.create;

  intControl := FindFirst( AMask, faAnyFile, SearchRec );

  if intControl = 0 then
  begin

    while (intControl = 0) do
    begin

      Result.Add( SearchRec.Name );
      intControl := FindNext( SearchRec );

    end;

    FindClose(SearchRec);
  end;

end;

procedure lerArquivo(pDiretorio: String);
var
  vArquivo: TStringList;
  vIndice: Integer;
  ClassePrincipal: TClasse;
  ClasseSecundaria: TClasse;
  Atributo: TAtributo;
  Metodo: TMetodo;
  Ator: TAtorXMI;
  CasoDeUso: TCasoDeUso;
  Relacionamento: TRelacionamento;
  TiposDeDados : TTiposDeDados;
  Estereotipo : TEstereotipoXMI;
  PairEstereotipo: TPair<String, TEstereotipoXMI>;
  vIndiceEnd, vIntI : Integer;
  vlstFiles: TStringList;
begin

  vIdentificador := 1;

  vArquivo := TStringList.Create;
      ListaObj := TObjectList.Create;
      ListaObjDados := TDictionary<String,TTiposDeDados>.Create;
      ListaObjAtor := TDictionary<String,TAtorXMI>.Create;
      ListaObjCaso := TDictionary<String,TCasoDeUso>.Create;
      ListaObjRelacionamento := TDictionary<String,TRelacionamento>.Create;
      ListaObjEstereotipo := TDictionary<String,TEstereotipoXMI>.Create;

  vlstFiles := fncFillDir(pDiretorio + '*.fmx');
  for vIntI := 0 to vlstFiles.Count - 1 do
  begin

    if FileExists(pDiretorio + vlstFiles.Strings[vIntI]) then
    begin

      vArquivo.LoadFromFile(pDiretorio + vlstFiles.Strings[vIntI]);

      vIndice := 0;



      ClassePrincipal := nil;

      while vIndice <= Pred(vArquivo.Count) do
      begin

        if POS('TEstereotipo',vArquivo.Strings[vIndice]) > 0 then
        begin

          Estereotipo := TEstereotipoXMI.Create;
          Estereotipo.Id := getIdentificador;
          Estereotipo.Nome := getValor(vArquivo.Strings[vIndice]);
          Estereotipo.Tipo := getValor(vArquivo.Strings[vIndice+1]);

          ListaObjEstereotipo.AddOrSetValue(Estereotipo.Nome, Estereotipo);
        end;

        Inc(vIndice);

      end;

      vIndice := 0;

      while vIndice <= Pred(vArquivo.Count) do
      begin

        if ehClasse(vIndice, vArquivo) then
        begin

          if POS('TGrade',vArquivo.Strings[vIndice]) > 0 then
          begin

            ClasseSecundaria := TClasse.Create;
            ClasseSecundaria.id := getIdentificador;
            ClasseSecundaria.nome := getValor(vArquivo.Strings[vIndice]);
            ListaObj.Add(ClasseSecundaria);

            Relacionamento := TRelacionamento.Create;
            Relacionamento.id := getIdentificador;
            Relacionamento.tipo := trClasse;
            Relacionamento.referencia1 := ClassePrincipal;
            Relacionamento.referencia2 := ClasseSecundaria;

            ListaObjRelacionamento.AddOrSetValue(Relacionamento.nome, Relacionamento);


            // Adiciona os atributos da grade
            inc(vIndice);
            vIndiceEnd := 1;
            while vIndiceEnd > 0 do
            begin

              if Pos('TStringColumn', vArquivo.Strings[vIndice]) > 0 then
              begin
                inc(vIndiceEnd);
                Atributo := TAtributo.Create;
                Atributo.id := getIdentificador;
                Atributo.nome := getValor(vArquivo.Strings[vIndice]);
                TiposDeDados := TTiposDeDados.Create;
                TiposDeDados.Nome := Atributo.tipo;
                ListaObjDados.AddOrSetValue(Atributo.tipo, TiposDeDados);

                ClasseSecundaria.ListaAtributos.Add(Atributo);
              end
              else if Pos('Documentacao.Visibilidade', vArquivo.Strings[vIndice]) > 0 then
                ClasseSecundaria.Visibilidade := getValor(vArquivo.Strings[vIndice])
              else if Pos('DocumentacaoEstereotipo', vArquivo.Strings[vIndice]) > 0 then
              begin
                inc(vIndiceEnd);
              end
              else if Pos('Estereotipo', vArquivo.Strings[vIndice]) > 0 then
              begin
                ClasseSecundaria.ListaEstereotipos.Add(ListaObjEstereotipo.Items[getValor(vArquivo.Strings[vIndice])]);
                ListaObjEstereotipo.Remove(getValor(vArquivo.Strings[vIndice]));
              end
              else if (trim(vArquivo.Strings[vIndice]) = 'end') or (trim(vArquivo.Strings[vIndice]) = 'end>') then
                dec(vIndiceEnd);

              inc(vIndice);

            end;

          end
          else
          begin

            ClassePrincipal := TClasse.Create;
            ClassePrincipal.id := getIdentificador;
            ClassePrincipal.nome := getValor(vArquivo.Strings[vIndice]);

          end;

        end
        else if EhAtributo(vIndice, vArquivo) then
        begin

          Atributo := TAtributo.Create;
          Atributo.id := getIdentificador;
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

          TiposDeDados := TTiposDeDados.Create;
          TiposDeDados.Nome := Atributo.tipo;
          ListaObjDados.AddOrSetValue(Atributo.tipo, TiposDeDados);

          ClassePrincipal.ListaAtributos.Add(Atributo);

        end
        else if EhMetodo(vArquivo.Strings[vIndice]) then
        begin

          Metodo := TMetodo.Create;
          Metodo.id := getIdentificador;
          Metodo.nome := getValor(vArquivo.Strings[vIndice]);

          inc(vIndice);
          while trim(vArquivo.Strings[vIndice]) <> 'end' do
          begin

            if Pos('Documentacao.Visibilidade', vArquivo.Strings[vIndice]) > 0 then
              Metodo.visibilidade := getValor(vArquivo.Strings[vIndice])
            else if Pos('Documentacao.Retorno', vArquivo.Strings[vIndice]) > 0 then
              Metodo.tipoRetorno := getValor(vArquivo.Strings[vIndice])
            else if Pos('Documentacao.Parametros.ListaDeParametros', vArquivo.Strings[vIndice]) > 0 then
              Metodo.listaDeParametros := getValor(vArquivo.Strings[vIndice])
            else if (Pos('DocumentacaoAtor', vArquivo.Strings[vIndice]) > 0) and (getValor(vArquivo.Strings[vIndice]) <> '<>') then
            begin

              inc(vIndice);

              while Pos('>', vArquivo.Strings[vIndice]) = 0 do
              begin

                if Pos('Ator', vArquivo.Strings[vIndice]) > 0 then
                begin

                  Ator := TAtorXMI.Create;
                  Ator.id := getIdentificador;
                  Ator.nome := getValor(vArquivo.Strings[vIndice]);

                  CasoDeUso := TCasoDeUso.Create;
                  CasoDeUso.id := getIdentificador;
                  CasoDeUso.nome := Metodo.Nome;

                  if not ListaObjAtor.ContainsKey(Ator.nome) then
                    ListaObjAtor.Add(Ator.nome, Ator);

                  if not ListaObjCaso.ContainsKey(CasoDeUso.Nome) then
                    ListaObjCaso.Add(CasoDeUso.nome, CasoDeUso);

                  Relacionamento := TRelacionamento.Create;
                  Relacionamento.id := getIdentificador;
                  Relacionamento.tipo := trCasoDeUso;
                  Relacionamento.referencia1 := ListaObjAtor.Items[Ator.Nome];
                  Relacionamento.referencia2 := ListaObjCaso.Items[CasoDeUso.Nome];

                  ListaObjRelacionamento.AddOrSetValue(Relacionamento.nome, Relacionamento);

                end;

                Inc(vIndice);

              end;

            end;

            inc(vIndice);

          end;

          ClassePrincipal.ListaMetodos.Add(Metodo);

        end;

        Inc(vIndice);

      end;

      for PairEstereotipo in ListaObjEstereotipo do
        ClassePrincipal.ListaEstereotipos.Add(PairEstereotipo.Value);

      ListaObj.Add(ClassePrincipal);

    end;

  end;

end;

function gerarXMI(pDiretorio, pLocalSalvar: String): Boolean;
var
  Obj : TObject;
  Raiz: IXMLNode;
  nodoElemento, nodoAtributo: IXMLNode; // Uso Geral
  cabecalho, documentacao, content, model, nameespace: IXMLNode; //Padrão
  XMLDocument : TXMLDocument;
  i : Integer;
begin

  lerArquivo(pDiretorio);

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

  // Adiciona primeiro os tipos de dados
  for Obj in ListaObjDados.Values do
  begin
    nameespace.ChildNodes.Add(TTiposDeDados(Obj).gerarTag(XMLDocument));
  end;

  for I := 0 to ListaObj.Count - 1 do
  begin
    Obj := ListaObj.Items[i];

    if Obj.ClassNameIs('TClasse') then
    begin

      nameespace.ChildNodes.Add(TClasse(Obj).gerarTag(XMLDocument));

    end;

  end;

  for Obj in ListaObjAtor.Values do
  begin
    nameespace.ChildNodes.Add(TAtorXMI(Obj).gerarTag(XMLDocument));
  end;

  for Obj in ListaObjCaso.Values do
  begin
    nameespace.ChildNodes.Add(TCasoDeUso(Obj).gerarTag(XMLDocument));
  end;

  for Obj in ListaObjRelacionamento.Values do
  begin
    nameespace.ChildNodes.Add(TRelacionamento(Obj).gerarTag(XMLDocument));
  end;

  XMLDocument.SaveToFile(pLocalSalvar);
  XMLDocument.Active := False;

  result := True;

end;

function getIdentificador: Integer;
begin
  inc(vIdentificador);
  Result := vIdentificador;
end;

end.
