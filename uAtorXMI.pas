unit uAtorXMI;

interface

uses uIXMI, XMLIntf, XMLDoc;

type
  TAtorXMI = class(TInterfacedObject, iXMI)
  private
    fid: Integer;
    fNome: String;
  public
    property Id: Integer read fId write fId;
    property Nome: String read fNome write fNome;
    function gerarTag(pXML: TXMLDocument): IXMLNode;
  end;

implementation

uses System.SysUtils;

{ TAtorXMI }

function TAtorXMI.gerarTag(pXML: TXMLDocument): IXMLNode;
var
  nodeElemento, nodeAtributo: IXMLNode;
begin

  nodeElemento := pXML.CreateNode('UML:Actor', ntElement);

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
  nodeAtributo.Text := Self.Nome;
  nodeElemento.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('xmi.id', ntAttribute);
  nodeAtributo.Text := IntToStr(Self.Id);
  nodeElemento.AttributeNodes.Add(nodeAtributo);

  Result := nodeElemento;

end;

end.
