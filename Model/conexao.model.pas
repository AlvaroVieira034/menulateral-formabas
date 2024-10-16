unit conexao.model;

interface

uses connection.model, System.SysUtils;

type
  // Singleton
  TConexao = class
    private
      FConnection: TConnection;


    public
      constructor Create;
      destructor Destroy; override;
      class function GetInstance: TConexao;

      property Connection: TConnection read FConnection write FConnection;

  end;

implementation

{ TConexao}

var
  InstanciaBD: TConexao;


constructor TConexao.Create;
begin
  inherited Create;
  FConnection := TConnection.Create;
end;

destructor TConexao.Destroy;
begin

  inherited;
  FreeAndNil(FConnection);
end;

class function TConexao.GetInstance: TConexao;
begin
  if InstanciaBD = nil then
    InstanciaBD := TConexao.Create;

  Result := InstanciaBD
end;

initialization
  InstanciaBD := nil;

finalization
  if InstanciaBD <> nil then
    InstanciaBD.Free;

end.
