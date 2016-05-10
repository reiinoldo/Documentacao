unit uRelacionamento;

interface

uses uClasse;

type
  TRelacionamento = class
    public
      id: Integer;
      nome: String;
      tipo: String;
      referencia1: TClasse;
      referencia2: TClasse;
  end;

implementation

end.
