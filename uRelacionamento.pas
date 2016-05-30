unit uRelacionamento;

interface

uses uIXMI, XMLIntf, XMLDoc, uPropriedades, uAtorXMI, uCasoDeUso, uClasse;

type
  TRelacionamento = class(TInterfacedObject, iXMI)
  private
    fid: Integer;
    fNome: String;
    fTipo: TTipoRelacionamento;
    fReferencia1: TObject;
    fReferencia2: TObject;
    function getNome: String;
  public
    property Id: Integer read fid write fid;
    property Nome: String read getNome write fNome;
    property Tipo: TTipoRelacionamento read fTipo write fTipo;
    property Referencia1: TObject read fReferencia1 write fReferencia1;
    property Referencia2: TObject read fReferencia2 write fReferencia2;
    function gerarTag(pXML: TXMLDocument): IXMLNode;
  end;

implementation

uses System.SysUtils;

{ TRelacionamento }

function TRelacionamento.gerarTag(pXML: TXMLDocument): IXMLNode;
var
  nodeRelacionamento, nodeAtributo,
  nodeConexao, nodeConexaoPonta1, nodeConexaoPonta2,
  nodeParticipante,
  nodeCasoDeUso, nodeAtor,
  nodeClasse: IXMLNode;
begin

  nodeRelacionamento := pXML.CreateNode('UML:Association', ntElement);

  nodeAtributo := pXML.CreateNode('isAbstract', ntAttribute);
  nodeAtributo.Text := 'false';
  nodeRelacionamento.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('isLeaf', ntAttribute);
  nodeAtributo.Text := 'false';
  nodeRelacionamento.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('isRoot', ntAttribute);
  nodeAtributo.Text := 'false';
  nodeRelacionamento.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('isSpecification', ntAttribute);
  nodeAtributo.Text := 'false';
  nodeRelacionamento.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('name', ntAttribute);
  nodeAtributo.Text := Nome;
  nodeRelacionamento.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('xmi.id', ntAttribute);
  nodeAtributo.Text := IntToStr(Id);
  nodeRelacionamento.AttributeNodes.Add(nodeAtributo);

  nodeConexaoPonta1 := pXML.CreateNode('UML:AssociationEnd', ntElement);

  nodeAtributo := pXML.CreateNode('targetScope', ntAttribute);
  nodeAtributo.Text := 'instance';
  nodeConexaoPonta1.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('changeability', ntAttribute);
  nodeAtributo.Text := 'changeable';
  nodeConexaoPonta1.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('targetScope', ntAttribute);
  nodeAtributo.Text := 'instance';
  nodeConexaoPonta1.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('aggregation', ntAttribute);
  if Tipo = trCasoDeUso then  
    nodeAtributo.Text := 'none'
  else
   nodeAtributo.Text := 'aggregate';
   
  nodeConexaoPonta1.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('ordering', ntAttribute);
  nodeAtributo.Text := 'unordered';
  nodeConexaoPonta1.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('isNavigable', ntAttribute);
  nodeAtributo.Text := 'true';
  nodeConexaoPonta1.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('isSpecification', ntAttribute);
  nodeAtributo.Text := 'false';
  nodeConexaoPonta1.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('visibility', ntAttribute);
  nodeAtributo.Text := 'public';
  nodeConexaoPonta1.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('xmi.id', ntAttribute);
  nodeAtributo.Text := IntToStr(Id) + '-1';
  nodeConexaoPonta1.AttributeNodes.Add(nodeAtributo);

  nodeParticipante := pXML.CreateNode('UML:AssociationEnd.participant', ntElement);

  if Tipo = trCasoDeUso then
  begin

    nodeAtor := pXML.CreateNode('UML:Actor', ntElement);
    nodeAtributo := pXML.CreateNode('xmi.idref', ntAttribute);
    nodeAtributo.Text := IntToStr(TAtorXMI(Referencia1).id);
    nodeAtor.AttributeNodes.Add(nodeAtributo);

    nodeParticipante.ChildNodes.Add(nodeAtor);

  end
  else
  begin

    nodeClasse := pXML.CreateNode('UML:Class', ntElement);
    nodeAtributo := pXML.CreateNode('xmi.idref', ntAttribute);
    nodeAtributo.Text := IntToStr(TClasse(Referencia1).id);
    nodeClasse.AttributeNodes.Add(nodeAtributo);

    nodeParticipante.ChildNodes.Add(nodeClasse);

  end;

  nodeConexaoPonta1.ChildNodes.Add(nodeParticipante);

  nodeConexaoPonta2 := pXML.CreateNode('UML:AssociationEnd', ntElement);

  nodeAtributo := pXML.CreateNode('targetScope', ntAttribute);
  nodeAtributo.Text := 'instance';
  nodeConexaoPonta2.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('changeability', ntAttribute);
  nodeAtributo.Text := 'changeable';
  nodeConexaoPonta2.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('targetScope', ntAttribute);
  nodeAtributo.Text := 'instance';
  nodeConexaoPonta2.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('aggregation', ntAttribute);
  nodeAtributo.Text := 'none';
  nodeConexaoPonta2.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('ordering', ntAttribute);
  nodeAtributo.Text := 'unordered';
  nodeConexaoPonta2.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('isNavigable', ntAttribute);
  nodeAtributo.Text := 'true';
  nodeConexaoPonta2.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('isSpecification', ntAttribute);
  nodeAtributo.Text := 'false';
  nodeConexaoPonta2.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('visibility', ntAttribute);
  nodeAtributo.Text := 'public';
  nodeConexaoPonta2.AttributeNodes.Add(nodeAtributo);

  nodeAtributo := pXML.CreateNode('xmi.id', ntAttribute);
  nodeAtributo.Text := IntToStr(Id) + '-2';
  nodeConexaoPonta2.AttributeNodes.Add(nodeAtributo);

  nodeParticipante := pXML.CreateNode('UML:AssociationEnd.participant', ntElement);

  if Tipo = trCasoDeUso then
  begin

    nodeCasoDeUso := pXML.CreateNode('UML:UseCase', ntElement);
    nodeAtributo := pXML.CreateNode('xmi.idref', ntAttribute);
    nodeAtributo.Text := IntToStr(TCasoDeUso(Referencia2).id);
    nodeCasoDeUso.AttributeNodes.Add(nodeAtributo);

    nodeParticipante.ChildNodes.Add(nodeCasoDeUso);

  end
  else
  begin

    nodeClasse := pXML.CreateNode('UML:Class', ntElement);
    nodeAtributo := pXML.CreateNode('xmi.idref', ntAttribute);
    nodeAtributo.Text := IntToStr(TClasse(Referencia2).id);
    nodeClasse.AttributeNodes.Add(nodeAtributo);

    nodeParticipante.ChildNodes.Add(nodeClasse);

  end;

  nodeConexaoPonta2.ChildNodes.Add(nodeParticipante);

  nodeConexao := pXML.CreateNode('UML:Association.connection', ntElement);
  nodeConexao.ChildNodes.Add(nodeConexaoPonta1);
  nodeConexao.ChildNodes.Add(nodeConexaoPonta2);
  nodeRelacionamento.ChildNodes.Add(nodeConexao);

  Result := nodeRelacionamento;

end;

function TRelacionamento.getNome: String;
begin
  if Tipo = trCasoDeUso then
    Result := TAtorXMI(Referencia1).Nome +'_'+ TCasoDeUso(Referencia2).Nome
  else
    Result := TClasse(Referencia1).Nome +'_'+ TClasse(Referencia2).Nome;
end;

end.
