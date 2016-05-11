unit uIXmi;

interface

uses XMLIntf, XMLDoc;

type
  iXMI = interface
    function gerarTag(pXML: TXMLDocument): IXMLNode;
  end;

implementation

end.
