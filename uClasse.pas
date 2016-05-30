unit uClasse;

interface

uses Generics.Collections, XMLIntf, XMLDoc, SysUtils,
     uIXMI,
     uAtributo, uMetodo, uEstereotipoXMI;

type

  TClasse = class(TInterfacedObject, iXMI)
  private
    fId: Integer;
    fNome: String;
    fVisibilidade: String;
    fListaAtributos: TObjectList<TAtributo>;
    fListaMetodos: TObjectList<TMetodo>;
    fListaEstereotipos: TObjectList<TEstereotipoXMI>;
    function getVisibilidade: String;
  public
    property Id: Integer read fId write fId;
    property Nome: String read fNome write fNome;
    property Visibilidade: String read getVisibilidade write fVisibilidade;
    property ListaAtributos: TObjectList<TAtributo> read fListaAtributos write fListaAtributos;
    property ListaMetodos: TObjectList<TMetodo> read fListaMetodos write fListaMetodos;
    property ListaEstereotipos: TObjectList<TEstereotipoXMI> read fListaEstereotipos write fListaEstereotipos;
    constructor create;
    function gerarTag(pXML: TXMLDocument): IXMLNode;
  end;

implementation

uses uPropriedades;
{ TClasse }

constructor TClasse.create;
begin
  Self.ListaAtributos := TObjectList<TAtributo>.Create;
  Self.ListaMetodos := TObjectList<TMetodo>.Create;
  Self.ListaEstereotipos := TObjectList<TEstereotipoXMI>.Create;
end;

function TClasse.gerarTag(pXML: TXMLDocument): IXMLNode;
var
  nodeClasse, nodeAtributo, nodeClassificador: IXMLNode;
  ObjAtributo: TAtributo;
  ObjMetodo: TMetodo;
  ObjEstereotipo: TEstereotipoXMI;
begin

  nodeClasse := pXML.CreateNode('UML:Class', ntElement);

  nodeAtributo := pXML.CreateNode('isActive', ntAttribute);
  nodeAtributo.Text := 'false';
  nodeClasse.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('isAbstract', ntAttribute);
  nodeAtributo.Text := 'false';
  nodeClasse.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('isLeaf', ntAttribute);
  nodeAtributo.Text := 'false';
  nodeClasse.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('isRoot', ntAttribute);
  nodeAtributo.Text := 'false';
  nodeClasse.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('isSpecification', ntAttribute);
  nodeAtributo.Text := 'false';
  nodeClasse.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('visibility', ntAttribute);
  nodeAtributo.Text := Self.Visibilidade;
  nodeClasse.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('name', ntAttribute);
  nodeAtributo.Text := Self.Nome;
  nodeClasse.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('xmi.id', ntAttribute);
  nodeAtributo.Text := IntToStr(Self.Id);
  nodeClasse.AttributeNodes.Add(nodeAtributo);

  for ObjEstereotipo in Self.ListaEstereotipos do
  begin
    nodeClasse.ChildNodes.Add(ObjEstereotipo.gerarTag(pXML));
  end;

  nodeClassificador := pXML.CreateNode('UML:Classifier.feature', ntElement);
  nodeClasse.ChildNodes.Add(nodeClassificador);

  for ObjAtributo in Self.ListaAtributos do
  begin
    nodeClassificador.ChildNodes.Add(ObjAtributo.gerarTag(pXML));
  end;

  for ObjMetodo in Self.ListaMetodos do
  begin
    nodeClassificador.ChildNodes.Add(ObjMetodo.gerarTag(pXML));
  end;

  Result := nodeClasse;

end;

function TClasse.getVisibilidade: String;
begin
  Result := visibilidadeComponenteParaXMI(fVisibilidade);
end;

end.
