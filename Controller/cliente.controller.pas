unit cliente.controller;

interface

uses cliente.model, clienterepository.model, conexao.model, Biblioteca, System.SysUtils, FireDAC.Comp.Client, FireDAC.Stan.Param;

type
  TCampoInvalido = (ciNome, ciCpfCnpj, ciCidade, ciUF, ciCPF, ciCNPJ);
  TClienteController = class

  private
    FCliente: TCliente;
    FClienteRepo : TClienteRepository;

  public
    constructor Create();
    destructor Destroy; override;
    procedure PreencherGrid(TblClientes: TFDQuery; APesquisa, ACampo: string);
    procedure PreencherComboCliente(TblClientes: TFDQuery);
    function CarregarCampos(QryClientes: TFDQuery; FCliente: TCliente; ACodigo: Integer): Boolean;
    function Inserir(QryClientes: TFDQuery; FCliente: TCliente; Transacao: TFDTransaction; out sErro: string): Boolean;
    function Alterar(QryClientes: TFDQuery; FCliente: TCliente; Transacao: TFDTransaction; ACodigo: Integer; out sErro: string): Boolean;
    function Excluir(QryClientes: TFDQuery; Transacao: TFDTransaction; ACodigo: Integer; out sErro : string): Boolean;
    function ValidarDados(const ANomeCliente, ACpfCnpj, ACidade, AUF: string; out AErro: TCampoInvalido): Boolean;
    function VerificaClienteUtilizado(QryTemp: TFDQuery; ACodigo: Integer): Boolean;

  end;

implementation

{ TClienteController }

constructor TClienteController.Create;
begin
  FCliente := TCliente.Create();
  FClienteRepo := TClienteRepository.Create();
end;

destructor TClienteController.Destroy;
begin
  FCliente.Free;
  FClienteRepo.Free;
  inherited;
end;

procedure TClienteController.PreencherGrid(TblClientes: TFDQuery; APesquisa, ACampo: string);
var LCampo, SErro: string;
begin
  try
    if ACampo = 'C�digo' then
      LCampo := 'cli.cod_cliente';

    if ACampo = 'Nome' then
      LCampo := 'cli.des_nomecliente';

    if ACampo = 'Cpf/Cnpj' then
      LCampo := 'cli.des_cpfcnpj';

    if ACampo = 'Cidade' then
      LCampo := 'cli.des_cidade';

    if ACampo = '' then
      LCampo := 'cli.des_nomecliente';

    FClienteRepo.PreencherGrid(TblClientes, APesquisa, LCampo);
  except on E: Exception do
    begin
      SErro := 'Ocorreu um erro ao pesquisar o cliente!' + sLineBreak + E.Message;
      raise;
    end;
  end;
end;

procedure TClienteController.PreencherComboCliente(TblClientes: TFDQuery);
begin
  FClienteRepo.PreencherComboCliente(TblClientes);
end;

function TClienteController.Inserir(QryClientes: TFDQuery; FCliente: TCliente; Transacao: TFDTransaction; out sErro: string): Boolean;
begin
  Result := FClienteRepo.Inserir(QryClientes, FCliente, Transacao, sErro);
end;

function TClienteController.CarregarCampos(QryClientes: TFDQuery; FCliente: TCliente; ACodigo: Integer): Boolean;
var sErro: string;
begin
  try
    FClienteRepo.CarregarCampos(QryClientes, FCliente, ACodigo);
  except on E: Exception do
    begin
      sErro := 'Ocorreu um erro ao carregar o cliente!' + sLineBreak + E.Message;
      raise;
    end;
  end;
  Result := True;
end;

function TClienteController.Alterar(QryClientes: TFDQuery; FCliente: TCliente; Transacao: TFDTransaction; ACodigo: Integer; out sErro: string): Boolean;
begin
   Result := FClienteRepo.Alterar(QryClientes, FCliente, Transacao, ACodigo, sErro);
end;

function TClienteController.Excluir(QryClientes: TFDQuery;  Transacao: TFDTransaction; ACodigo: Integer; out sErro: string): Boolean;
begin
   Result := FClienteRepo.Excluir(QryClientes, Transacao, ACodigo, sErro);
end;

function TClienteController.ValidarDados(const ANomeCliente, ACpfCnpj, ACidade, AUF: string; out AErro: TCampoInvalido): Boolean;
var LCpf, LCnpj: string;
begin
  if ANomeCliente = EmptyStr then
  begin
    AErro := ciNome;
    Exit;
  end;

  if ACpfCnpj = EmptyStr then
  begin
    AErro := ciCpfCnpj;
    Exit;
  end;

  if Length(ACpfCnpj) = 14 then
  begin
    LCpf := SoNumeros(ACpfCnpj);
    if not ValidarCPF(LCpf) then
    begin
      AErro := ciCPF;
      Exit;
    end;
  end;

  if Length(ACpfCnpj) = 18 then
  begin
    LCnpj := SoNumeros(ACpfCnpj);
    if not ValidarCNPJ(LCnpj) then
    begin
      AErro := ciCNPJ;
      Exit;
    end;
  end;

  if ACidade = EmptyStr then
  begin
    AErro := ciCidade;
    Exit;
  end;

  if AUF = EmptyStr then
  begin
    AErro := ciUF;
    Exit;
  end;

  Result := True;
end;
function TClienteController.VerificaClienteUtilizado(QryTemp: TFDQuery; ACodigo: Integer): Boolean;
begin
  Result := FClienteRepo.VerificaClienteUtilizado(QryTemp, ACodigo);
end;

end.
