unit uAtributo;

interface

uses uIXMI, XMLIntf;

type

  TAtributo = class(TInterfacedObject, iXMI)
  private
    fId: Integer;
    fNome: String;
    fTipo: String;
    fVisibilidade: String;
    fModificabilidade: String;
    fValorInicial: String;
  public
    constructor create;
    property Id: Integer read fId write fId;
    property Nome: String read fNome write fNome;
    property Tipo: String read fTipo write fTipo;
    property Visibilidade: String read fVisibilidade write fVisibilidade;
    function gerarTag: IXMLNode;

  end;

implementation

{ TAtributo }

constructor TAtributo.create;
begin

  Self.fTipo := 'String';
  Self.fVisibilidade := 'private';

end;

function TAtributo.gerarTag: IXMLNode;
begin

end;

end.
