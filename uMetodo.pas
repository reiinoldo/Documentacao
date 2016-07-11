unit uMetodo;

interface

uses uIXMI, XMLIntf, XMLDoc, Classes;

type

  TMetodo = class(TInterfacedObject, iXMI)
  private
    fid: Integer;
    fnome: String;
    ftipoRetorno: String;
    fvisibilidade: String;
    fListaDeParametros: String;
    function getTipoRetorno : String;
    function getVisibilidade: String;
  public
    constructor create;
    property Id: Integer read fId write fId;
    property Nome: String read fNome write fNome;
    property TipoRetorno: String read getTipoRetorno write ftipoRetorno;
    property Visibilidade: String read getVisibilidade write fVisibilidade;
    property ListaDeParametros: String read fListaDeParametros write fListaDeParametros;
    function getTiposDeParametros: TStringList;
    function gerarTag(pXML: TXMLDocument): IXMLNode;
  end;

implementation

uses System.SysUtils,
     uPropriedades;

{ TMetodo }

constructor TMetodo.create;
begin
  Self.fVisibilidade := 'private';
end;

function TMetodo.gerarTag(pXML: TXMLDocument): IXMLNode;
var
  nodeElemento, nodeAtributo, nodeTipo, nodeTipoParametro, nodeParametro, nodeGrupoParametros: IXMLNode;
  ListaParametrosPropriedades: TStringList;
  i: integer;
begin

  nodeElemento := pXML.CreateNode('UML:Operation', ntElement);

  nodeAtributo := pXML.CreateNode('isAbstract', ntAttribute);
  nodeAtributo.Text := 'false';
  nodeElemento.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('isLeaf', ntAttribute);
  nodeAtributo.Text := 'false';
  nodeElemento.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('isRoot', ntAttribute);
  nodeAtributo.Text := 'false';
  nodeElemento.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('concurrency', ntAttribute);
  nodeAtributo.Text := 'sequential';
  nodeElemento.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('isQuery', ntAttribute);
  nodeAtributo.Text := 'false';
  nodeElemento.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('ownerScope', ntAttribute);
  nodeAtributo.Text := 'instance';
  nodeElemento.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('isSpecification', ntAttribute);
  nodeAtributo.Text := 'false';
  nodeElemento.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('visibility', ntAttribute);
  nodeAtributo.Text := Self.Visibilidade;
  nodeElemento.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('name', ntAttribute);
  nodeAtributo.Text := Self.Nome;
  nodeElemento.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('xmi.id', ntAttribute);
  nodeAtributo.Text := IntToStr(Self.Id);
  nodeElemento.AttributeNodes.Add(nodeAtributo);

  if (TipoRetorno <> '') or (ListaDeParametros <> '') then
  begin

    nodeGrupoParametros := pXML.CreateNode('UML:BehavioralFeature.parameter', ntElement);

    if TipoRetorno <> '' then
    begin

      nodeParametro := pXML.CreateNode('UML:Parameter', ntElement);

      nodeAtributo := pXML.CreateNode('isSpecification', ntAttribute);
      nodeAtributo.Text := 'false';
      nodeParametro.AttributeNodes.Add(nodeAtributo);

      nodeAtributo := pXML.CreateNode('kind', ntAttribute);
      nodeAtributo.Text := 'return';
      nodeParametro.AttributeNodes.Add(nodeAtributo);

      nodeAtributo := pXML.CreateNode('name', ntAttribute);
      nodeAtributo.Text := 'return';
      nodeParametro.AttributeNodes.Add(nodeAtributo);

      nodeAtributo := pXML.CreateNode('xmi.id', ntAttribute);
      nodeAtributo.Text := IntToStr(Self.Id) + '-R';
      nodeParametro.AttributeNodes.Add(nodeAtributo);

      nodeTipoParametro := pXML.CreateNode('UML:Parameter.type', ntElement);
      nodeTipo := pXML.CreateNode('UML:DataType', ntElement);

      nodeAtributo := pXML.CreateNode('xmi.idref', ntAttribute);
      nodeAtributo.Text := Self.tipoRetorno;
      nodeTipo.AttributeNodes.Add(nodeAtributo);

      nodeTipoParametro.ChildNodes.Add(nodeTipo);
      nodeParametro.ChildNodes.Add(nodeTipoParametro);
      nodeGrupoParametros.ChildNodes.Add(nodeParametro);

    end;

    if ListaDeParametros <> '' then
    begin

      ListaParametrosPropriedades := TStringList.Create;
      try

        ListaParametrosPropriedades.Clear;
        ExtractStrings(['|'],[], PChar(StringReplace(ListaDeParametros, '''', '', [rfReplaceAll])), ListaParametrosPropriedades);

        for I := 0 to (ListaParametrosPropriedades.Count div 2) - 1 do
        begin

          nodeParametro := pXML.CreateNode('UML:Parameter', ntElement);

          nodeAtributo := pXML.CreateNode('isSpecification', ntAttribute);
          nodeAtributo.Text := 'false';
          nodeParametro.AttributeNodes.Add(nodeAtributo);

          nodeAtributo := pXML.CreateNode('kind', ntAttribute);
          nodeAtributo.Text := 'in';
          nodeParametro.AttributeNodes.Add(nodeAtributo);

          nodeAtributo := pXML.CreateNode('name', ntAttribute);
          nodeAtributo.Text := ListaParametrosPropriedades.Strings[i*2];
          nodeParametro.AttributeNodes.Add(nodeAtributo);

          nodeAtributo := pXML.CreateNode('xmi.id', ntAttribute);
          nodeAtributo.Text := IntToStr(Self.Id) +'-'+ intToStr(i*2);
          nodeParametro.AttributeNodes.Add(nodeAtributo);

          nodeTipoParametro := pXML.CreateNode('UML:Parameter.type', ntElement);
          nodeTipo := pXML.CreateNode('UML:DataType', ntElement);

          nodeAtributo := pXML.CreateNode('xmi.idref', ntAttribute);
          nodeAtributo.Text := tipoComponenteParaXMI(ListaParametrosPropriedades.Strings[(i*2)+1]);
          nodeTipo.AttributeNodes.Add(nodeAtributo);

          nodeTipoParametro.ChildNodes.Add(nodeTipo);
          nodeParametro.ChildNodes.Add(nodeTipoParametro);
          nodeGrupoParametros.ChildNodes.Add(nodeParametro);

        end;

      finally
        FreeAndNil(ListaParametrosPropriedades);
      end;

    end;

    nodeElemento.ChildNodes.Add(nodeGrupoParametros);

  end;

  Result := nodeElemento;

end;

function TMetodo.getTipoRetorno: String;
begin
  Result := tipoComponenteParaXMI(ftipoRetorno);
end;

function TMetodo.getTiposDeParametros: TStringList;
var
 i: Integer;
 listaAux: TStringList;
begin
  result := TStringList.Create;
  listaAux := TStringList.Create;
  try

    listaAux.Clear;
    ExtractStrings(['|'],[], PChar(StringReplace(ListaDeParametros, '''', '', [rfReplaceAll])), listaAux);

    for I := 0 to (listaAux.Count div 2) - 1 do
    begin
      result.Add(tipoComponenteParaXMI(listaAux.Strings[(i*2)+1]));
    end;

  finally
    FreeAndNil(listaAux);
  end;
end;

function TMetodo.getVisibilidade: String;
begin
  Result := visibilidadeComponenteParaXMI(fVisibilidade);
end;

end.
