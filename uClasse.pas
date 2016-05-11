unit uClasse;

interface

type

  TClasse = class
  private
    fVisibilidade: String;
    function getVisibilidade: String;
  public
    id: Integer;
    nome: String;
    property Visibilidade: String read getVisibilidade write fVisibilidade;
    constructor create;
  end;

implementation

uses uPropriedades;
{ TClasse }

constructor TClasse.create;
begin
  Self.fVisibilidade := 'private';
end;

function TClasse.getVisibilidade: String;
begin
  Result := visibilidadeComponenteParaXMI(fVisibilidade);
end;

end.
