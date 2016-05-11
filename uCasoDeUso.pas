unit uCasoDeUso;

interface

uses uIXMI, XMLIntf, XMLDoc;

type
  TCasoDeUso = class(TInterfacedObject, iXMI)
  private
    fid: Integer;
    fNome: String;
    fAtor: Integer;
  public
    property Id: Integer read fId write fId;
    property Nome: String read fNome write fNome;
    property Ator: Integer read fAtor write fAtor;
    function gerarTag(pXML: TXMLDocument): IXMLNode;
  end;

implementation

uses System.SysUtils;

{ TCasoDeUso }

function TCasoDeUso.gerarTag(pXML: TXMLDocument): IXMLNode;
var
  nodeElemento, nodeAtributo: IXMLNode;
begin

  nodeElemento := pXML.CreateNode('UML:UseCase', ntElement);

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
