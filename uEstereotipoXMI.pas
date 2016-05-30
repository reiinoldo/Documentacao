unit uEstereotipoXMI;

interface

uses uIXMI, XMLIntf, XMLDoc;

type
  TEstereotipoXMI = class(TInterfacedObject, iXMI)
  private
    fid: Integer;
    fNome: String;
    fTipo: String;
    function getTipo: String;
  public
    property Id: Integer read fId write fId;
    property Nome: String read fNome write fNome;
    property Tipo: String read getTipo write fTipo;
    function gerarTag(pXML: TXMLDocument): IXMLNode;
  end;

implementation

uses System.SysUtils,
     uPropriedades;

{ TAtorXMI }

function TEstereotipoXMI.gerarTag(pXML: TXMLDocument): IXMLNode;
var
  nodeElemento, nodeAtributo, nodeEstereotipo: IXMLNode;
begin

  nodeElemento := pXML.CreateNode('UML:Stereotype', ntElement);

  nodeAtributo := pXML.CreateNode('isAbstract', ntAttribute);
  nodeAtributo.Text := 'false';
  nodeElemento.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('isLeaf', ntAttribute);
  nodeAtributo.Text := 'false';
  nodeElemento.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('isRoot', ntAttribute);
  nodeAtributo.Text := 'false';
  nodeElemento.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('isSpecification', ntAttribute);
  nodeAtributo.Text := 'false';
  nodeElemento.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('name', ntAttribute);
  nodeAtributo.Text := Self.Tipo;
  nodeElemento.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('xmi.id', ntAttribute);
  nodeAtributo.Text := IntToStr(Self.Id);
  nodeElemento.AttributeNodes.Add(nodeAtributo);

  nodeEstereotipo := pXML.CreateNode('UML:ModelElement.stereotype', ntElement);
  nodeEstereotipo.ChildNodes.Add(nodeElemento);

  Result := nodeEstereotipo;

end;

function TEstereotipoXMI.getTipo: String;
begin
  result := tipoEstereotipoComponenteParaXMI(Self.fTipo);
end;

end.
