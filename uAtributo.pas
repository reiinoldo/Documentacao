unit uAtributo;

interface

uses uIXMI, XMLIntf, XMLDoc;

type

  TAtributo = class(TInterfacedObject, iXMI)
  private
    fId: Integer;
    fNome: String;
    fTipo: String;
    fVisibilidade: String;
    function getTipo : String;
    function getVisibilidade: String;
  public
    constructor create;
    property Id: Integer read fId write fId;
    property Nome: String read fNome write fNome;
    property Tipo: String read getTipo write fTipo;
    property Visibilidade: String read getVisibilidade write fVisibilidade;
    function gerarTag(pXML: TXMLDocument): IXMLNode;

  end;

implementation

{ TAtributo }

uses System.SysUtils,
     uPropriedades;

constructor TAtributo.create;
begin

  Self.fTipo := 'String';
  Self.fVisibilidade := 'private';

end;

function TAtributo.gerarTag(pXML: TXMLDocument): IXMLNode;
var
  nodeElemento, nodeAtributo, nodeTipo, nodeEstrutura: IXMLNode;
begin

  nodeElemento := pXML.CreateNode('UML:Attribute', ntElement);

  nodeAtributo := pXML.CreateNode('targetScope', ntAttribute);
  nodeAtributo.Text := 'instance';
  nodeElemento.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('changeability', ntAttribute);
  nodeAtributo.Text := 'addOnly';
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

  nodeTipo := pXML.CreateNode('UML:DataType', ntElement);

  nodeAtributo := pXML.CreateNode('xmi.idref', ntAttribute);
  nodeAtributo.Text := Self.Tipo;
  nodeTipo.AttributeNodes.Add(nodeAtributo);

  nodeEstrutura := pXML.CreateNode('UML:StructuralFeature.type', ntElement);
  nodeElemento.ChildNodes.Add(nodeEstrutura);
  nodeEstrutura.ChildNodes.Add(nodeTipo);

  Result := nodeElemento;

end;

function TAtributo.getTipo: String;
begin
  Result := tipoComponenteParaXMI(FTipo);
end;

function TAtributo.getVisibilidade: String;
begin
  Result := visibilidadeComponenteParaXMI(fVisibilidade);
end;

end.
