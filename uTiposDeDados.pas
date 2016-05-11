unit uTiposDeDados;

interface

uses uIXMI, XMLIntf, XMLDoc;

type

  TTiposDeDados = class(TInterfacedObject, iXMI)
  private
    fNome : String;
  public
    property Nome: String read fNome write fNome;
    function gerarTag(pXML: TXMLDocument): IXMLNode;
  End;

implementation

{ TTiposDeDados }

function TTiposDeDados.gerarTag(pXML: TXMLDocument): IXMLNode;
var
  nodeAtributo, nodeTipo: IXMLNode;
begin

  nodeTipo := pXML.CreateNode('UML:DataType', ntElement);

  nodeAtributo := pXML.CreateNode('isAbstract', ntAttribute);
  nodeAtributo.Text := 'false';
  nodeTipo.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('isLeaf', ntAttribute);
  nodeAtributo.Text := 'false';
  nodeTipo.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('isRoot', ntAttribute);
  nodeAtributo.Text := 'false';
  nodeTipo.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('isSpecification', ntAttribute);
  nodeAtributo.Text := 'false';
  nodeTipo.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('name', ntAttribute);
  nodeAtributo.Text := Self.fNome;
  nodeTipo.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('xmi.id', ntAttribute);
  nodeAtributo.Text := Self.fNome;
  nodeTipo.AttributeNodes.Add(nodeAtributo);

  Result := nodeTipo

end;

end.
