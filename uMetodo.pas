unit uMetodo;

interface

uses uIXMI, XMLIntf, XMLDoc;

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
  nodeElemento, nodeAtributo: IXMLNode;
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

  Result := nodeElemento;

end;

function TMetodo.getTipoRetorno: String;
begin
  Result := tipoComponenteParaXMI(ftipoRetorno);
end;

function TMetodo.getVisibilidade: String;
begin
  Result := visibilidadeComponenteParaXMI(fVisibilidade);
end;

end.
