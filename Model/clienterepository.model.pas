unit clienterepository.model;

interface

uses cliente.model, conexao.model, System.SysUtils, FireDAC.Comp.Client, FireDAC.Stan.Param;

type
  TClienteRepository = class
  public
    procedure PreencherGrid(TblClientes: TFDQuery; APesquisa, ACampo: string);
    procedure PreencherComboCliente(TblClientes: TFDQuery);
    procedure CarregarCampos(QryClientes: TFDQuery; FCliente: TCliente; ACodigo: Integer);
    function Inserir(QryClientes: TFDQuery; FCliente: TCliente; Transacao: TFDTransaction; out sErro: string): Boolean;
    function Alterar(QryClientes: TFDQuery; FCliente: TCliente; Transacao: TFDTransaction; ACodigo: Integer; out sErro: string): Boolean;
    function Excluir(QryClientes: TFDQuery; Transacao: TFDTransaction; ACodigo: Integer; out sErro : string): Boolean;
    function VerificaClienteUtilizado(QryTemp: TFDQuery; ACodigo: Integer): Boolean;

  end;

implementation

{ TProdutoRepository }

procedure TClienteRepository.PreencherGrid(TblClientes: TFDQuery; APesquisa, ACampo: string);
begin
  with TblClientes do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select cli.cod_cliente,  ');
    SQL.Add('cli.des_nomecliente, ');
    SQL.Add('cli.des_cpfcnpj, ');
    SQL.Add('cli.dta_nascimento, ');
    SQL.Add('cli.des_cep, ');
    SQL.Add('cli.des_endereco, ');
    SQL.Add('cli.des_complemento, ');
    SQL.Add('cli.des_bairro, ');
    SQL.Add('cli.des_cidade, ');
    SQL.Add('cli.des_uf ');
    SQL.Add('from tab_cliente cli');
    SQL.Add('where ' + ACampo + ' like :pNOME');
    SQL.Add('order by ' + ACampo);
    ParamByName('PNOME').AsString := APesquisa;
    Open();
  end;
end;

procedure TClienteRepository.PreencherComboCliente(TblClientes: TFDQuery);
begin
  with TblClientes do
  begin
    Close;
    SQL.Clear;
    SQL.Add('select * from tab_cliente order by des_nomecliente ');
    Open();
  end;
end;

procedure TClienteRepository.CarregarCampos(QryClientes: TFDQuery; FCliente: TCliente; ACodigo: Integer);
begin
  with QryClientes do
  begin
    SQL.Clear;
    SQL.Add('select cli.cod_cliente,  ');
    SQL.Add('cli.des_nomecliente, ');
    SQL.Add('cli.des_cpfcnpj, ');
    SQL.Add('cli.dta_nascimento, ');
    SQL.Add('cli.des_cep, ');
    SQL.Add('cli.des_endereco, ');
    SQL.Add('cli.des_complemento, ');
    SQL.Add('cli.des_bairro, ');
    SQL.Add('cli.des_cidade, ');
    SQL.Add('cli.des_uf ');
    SQL.Add('from tab_cliente cli');
    SQL.Add('where cod_cliente = :cod_cliente');
    ParamByName('cod_cliente').AsInteger := ACodigo;
    Open;

    FCliente.Cod_Cliente := FieldByName('COD_CLIENTE').AsInteger;
    FCliente.Des_NomeCliente := FieldByName('DES_NOMECLIENTE').AsString;
    FCliente.Des_CpfCnpj := FieldByName('DES_CPFCNPJ').AsString;
    FCliente.Dta_Nascimento := FieldByName('DTA_NASCIMENTO').AsDateTime;
    FCliente.Des_Cep := FieldByName('DES_CEP').AsString;
    FCliente.Des_Endereco := FieldByName('DES_ENDERECO').AsString;
    FCliente.Des_Complemento := FieldByName('DES_COMPLEMENTO').AsString;
    FCliente.Des_Bairro := FieldByName('DES_BAIRRO').AsString;
    FCliente.Des_Cidade := FieldByName('DES_CIDADE').AsString;
    FCliente.Des_UF := FieldByName('DES_UF').AsString;
  end;
end;

function TClienteRepository.Inserir(QryClientes: TFDQuery; FCliente: TCliente; Transacao: TFDTransaction; out sErro: string): Boolean;
begin
  with QryClientes, FCliente do
  begin
    Close;
    SQL.Clear;
    SQL.Add('insert into tab_cliente(');
    SQL.Add('des_nomecliente, ');
    SQL.Add('des_cpfcnpj, ');
    SQL.Add('dta_nascimento, ');
    SQL.Add('des_cep, ');
    SQL.Add('des_endereco, ');
    SQL.Add('des_complemento, ');
    SQL.Add('des_bairro, ');
    SQL.Add('des_cidade, ');
    SQL.Add('des_uf) ');
    SQL.Add('values (:des_nomecliente, ');
    SQL.Add(':des_cpfcnpj, ');
    SQL.Add(':dta_nascimento, ');
    SQL.Add(':des_cep, ');
    SQL.Add(':des_endereco, ');
    SQL.Add(':des_complemento, ');
    SQL.Add(':des_bairro, ');
    SQL.Add(':des_cidade, ');
    SQL.Add(':des_uf)');

    ParamByName('DES_NOMECLIENTE').AsString := Des_NomeCliente;
    ParamByName('DES_CPFCNPJ').AsString := Des_CpfCnpj;
    ParamByName('DTA_NASCIMENTO').AsDate := Dta_Nascimento;
    ParamByName('DES_CEP').AsString := Des_Cep;
    ParamByName('DES_ENDERECO').AsString := Des_Endereco;
    ParamByName('DES_COMPLEMENTO').AsString := Des_Complemento;
    ParamByName('DES_BAIRRO').AsString := Des_Bairro;
    ParamByName('DES_CIDADE').AsString := Des_Cidade;
    ParamByName('DES_UF').AsString := Des_UF;

    // Inicia Transa��o
    if not Transacao.Connection.Connected then
      Transacao.Connection.Open();

    try
      Prepared := True;
      Transacao.StartTransaction;
      ExecSQL;
      Transacao.Commit;
      Result := True;
    except
      on E: Exception do
      begin
        Transacao.Rollback;
        sErro := 'Ocorreu um erro ao inserir um novo cliente!' + sLineBreak + E.Message;
        raise;
      end;
    end;
  end;
end;

function TClienteRepository.Alterar(QryClientes: TFDQuery; FCliente: TCliente; Transacao: TFDTransaction; ACodigo: Integer; out sErro: string): Boolean;
begin
  with QryClientes, FCliente do
  begin
    Close;
    SQL.Clear;
    SQL.Add('update tab_cliente set ');
    SQL.Add('des_nomecliente = :des_nomecliente, ');
    SQL.Add('des_cpfcnpj = :des_cpfcnpj, ');
    SQL.Add('dta_nascimento = :dta_nascimento, ');
    SQL.Add('des_cep = :des_cep, ');
    SQL.Add('des_endereco = :des_endereco, ');
    SQL.Add('des_complemento = :des_complemento, ');
    SQL.Add('des_bairro = :des_bairro, ');
    SQL.Add('des_cidade = :des_cidade, ');
    SQL.Add('des_uf = :des_uf ');
    SQL.Add('where cod_cliente = :cod_cliente');

    ParamByName('DES_NOMECLIENTE').AsString := Des_NomeCliente;
    ParamByName('DES_CPFCNPJ').AsString := Des_CpfCnpj;
    ParamByName('DTA_NASCIMENTO').AsDate := Dta_Nascimento;
    ParamByName('DES_CEP').AsString := Des_Cep;
    ParamByName('DES_ENDERECO').AsString := Des_Endereco;
    ParamByName('DES_COMPLEMENTO').AsString := Des_Complemento;
    ParamByName('DES_BAIRRO').AsString := Des_Bairro;
    ParamByName('DES_CIDADE').AsString := Des_Cidade;
    ParamByName('DES_UF').AsString := Des_UF;
    ParamByName('COD_CLIENTE').AsInteger := ACodigo;

    // Inicia Transa��o
    if not Transacao.Connection.Connected then
      Transacao.Connection.Open();

    try
      Prepared := True;
      Transacao.StartTransaction;
      ExecSQL;
      Transacao.Commit;
      Result := True;
    except
      on E: Exception do
      begin
        Transacao.Rollback;
        sErro := 'Ocorreu um erro ao alterar os dados do cliente!' + sLineBreak + E.Message;
        raise;
      end;
    end;
  end;
end;

function TClienteRepository.Excluir(QryClientes: TFDQuery; Transacao: TFDTransaction; ACodigo: Integer; out sErro: string): Boolean;
begin
  with QryClientes do
  begin
    Close;
    SQL.Clear;
    SQL.Text := 'delete from tab_cliente where cod_cliente = :cod_cliente';
    ParamByName('COD_CLIENTE').AsInteger := ACodigo;

    // Inicia Transa��o
    if not Transacao.Connection.Connected then
      Transacao.Connection.Open();

    try
      Prepared := True;
      Transacao.StartTransaction;
      ExecSQL;
      Transacao.Commit;
      Result := True;
    except
      on E: Exception do
      begin
        Transacao.Rollback;
        sErro := 'Ocorreu um erro ao excluir o cliente !' + sLineBreak + E.Message;
        raise;
      end;
    end;
  end;
end;

function TClienteRepository.VerificaClienteUtilizado(QryTemp: TFDQuery; ACodigo: Integer): Boolean;
begin
  with QryTemp do
  begin
    SQL.Clear;
    SQL.Add('select cod_cliente ');
    SQL.Add('from tab_venda');
    SQL.Add('where cod_cliente = :cod_cliente');
    ParamByName('COD_CLIENTE').AsInteger := ACodigo;
    Open;
    Result := not QryTemp.Eof;
  end;
end;


end.
