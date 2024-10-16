unit ucadcliente;

interface

{$REGION 'Uses'}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ucadastropadrao, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  conexao.model, cliente.model, cliente.controller, cepservice.model, System.UITypes;

{$ENDREGION}

type
  TFrmCadCliente = class(TFrmCadastroPadrao)

{$REGION 'Componentes'}
    Label3: TLabel;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    EdtCep: TEdit;
    EdtEndereco: TEdit;
    EdtComplemento: TEdit;
    EdtBairro: TEdit;
    EdtCidade: TEdit;
    EdtUF: TEdit;
    EdtCodigoCliente: TEdit;
    Label8: TLabel;
    EdtCpfCnpj: TEdit;
    Label9: TLabel;
    EdtNome: TEdit;
    Label10: TLabel;
    EdtDataNascimento: TEdit;
    Label11: TLabel;
    BtnPesquisarCep: TSpeedButton;
    PnlPesquisar: TPanel;
    Label12: TLabel;
    BtnPesquisar: TSpeedButton;
    EdtPesquisar: TEdit;
    CbxFiltro: TComboBox;
    DbGridClientes: TDBGrid;

{$ENDREGION}

    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure EdtCpfCnpjKeyPress(Sender: TObject; var Key: Char);
    procedure EdtDataNascimentoKeyPress(Sender: TObject; var Key: Char);
    procedure EdtCepKeyPress(Sender: TObject; var Key: Char);
    procedure DbGridClientesDblClick(Sender: TObject);
    procedure PnlCancelarClick(Sender: TObject);
    procedure PnlExcluirClick(Sender: TObject);
    procedure PnlGravarClick(Sender: TObject);
    procedure CbxFiltroChange(Sender: TObject);
    procedure EdtPesquisarChange(Sender: TObject);
    procedure DbGridClientesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PnlAlterarClick(Sender: TObject);
    procedure PnlNovoClick(Sender: TObject);
    procedure EdtPesquisarKeyPress(Sender: TObject; var Key: Char);
    procedure BtnPesquisarClick(Sender: TObject);
    procedure BtnFecharClick(Sender: TObject);
    procedure EdtCpfCnpjChange(Sender: TObject);
    procedure BtnPesquisarCepClick(Sender: TObject);
    procedure EdtDataNascimentoChange(Sender: TObject);

  private
    TblClientes: TFDQuery;
    QryClientes: TFDQuery;
    QryTemp: TFDQuery;
    DsClientes: TDataSource;
    TransacaoClientes: TFDTransaction;
    FCliente: TCliente;
    ClienteController: TClienteController;

    procedure CriarTabelas;
    procedure CriarCamposTabelas;
    procedure PreencherGrid;
    procedure CarregarCampos;
    procedure Inserir;
    procedure Alterar;
    procedure Excluir;
    function ValidarDados: Boolean;
    procedure GravarDados;
    procedure LimpaCampos(Form: TForm);
    procedure VerificaBotoes(AOperacao: TOperacao);
    procedure MostrarMensagemErro(AErro: TCampoInvalido);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  end;

var
  FrmCadCliente: TFrmCadCliente;

implementation

{$R *.dfm}

uses untFormat, System.JSON;

{ TFrmCadCliente }


constructor TFrmCadCliente.Create(AOwner: TComponent);
begin
  inherited;
  TransacaoClientes := TFDTransaction.Create(nil);
  DsClientes := TDataSource.Create(nil);
  TblClientes := TFDQuery.Create(nil);
  QryClientes := TFDQuery.Create(nil);
  QryTemp := TFDQuery.Create(nil);
end;

destructor TFrmCadCliente.Destroy;
begin
  TransacaoClientes.Free;
  DsClientes := TDataSource.Create(nil);
  TblClientes := TFDQuery.Create(nil);
  QryClientes := TFDQuery.Create(nil);
  QryTemp := TFDQuery.Create(nil);
  inherited;
end;

procedure TFrmCadCliente.FormCreate(Sender: TObject);
begin
  inherited;
  if TConexao.GetInstance.Connection.TestarConexao then
  begin
    TConexao.GetInstance.Connection.InciarTransacao;
    CriarTabelas();
    CriarCamposTabelas();
    FCliente := TCliente.Create;
    ClienteController := TClienteController.Create;
    FOperacao := opInicio;
    SetLength(ValoresOriginais, 10);
  end
  else
  begin
    ShowMessage('N�o foi poss�vel conectar ao banco de dados!');
    Close;
  end;
end;

procedure TFrmCadCliente.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_RETURN then
    perform(WM_NEXTDLGCTL,0,0)
end;

procedure TFrmCadCliente.FormShow(Sender: TObject);
begin
  inherited;
  PreencherGrid();
  VerificaBotoes(FOperacao);
  if EdtPesquisar.CanFocus then
    EdtPesquisar.SetFocus;
end;

procedure TFrmCadCliente.CriarTabelas;
begin
  TransacaoClientes := TConexao.GetInstance.Connection.CriarTransaction;
  TblClientes := TConexao.GetInstance.Connection.CriarQuery;
  QryClientes := TConexao.GetInstance.Connection.CriarQuery;
  QryTemp := TConexao.GetInstance.Connection.CriarQuery;
  QryClientes.Transaction := TransacaoClientes;
  DsClientes := TConexao.GetInstance.Connection.CriarDataSource;
  DsClientes.DataSet := TblClientes;
  DBGridClientes.DataSource := DsClientes;
end;

procedure TFrmCadCliente.CriarCamposTabelas;
var StringField: TStringField;
    IntegerField: TIntegerField;
    DateField: TDateField;
begin
  // Criando o campo COD_PRODUTO
  IntegerField := TIntegerField.Create(TblClientes);
  IntegerField.FieldName := 'COD_CLIENTE';
  IntegerField.DataSet := TblClientes;
  IntegerField.Name := 'TblClientesCOD_CLIENTE';

   // Criando o campo DES_CPFCNPJ
  StringField := TStringField.Create(TblClientes);
  StringField.FieldName := 'DES_CPFCNPJ';
  StringField.Size := 18;
  StringField.DataSet := TblClientes;
  StringField.Name := 'TblClientesDES_CPFCNPJ';

  // Criando o campo DES_NOMECLIENTE
  StringField := TStringField.Create(TblClientes);
  StringField.FieldName := 'DES_NOMECLIENTE';
  StringField.Size := 100;
  StringField.DataSet := TblClientes;
  StringField.Name := 'TblClientesDES_NOMECLIENTE';

  // Criando o campo DTA_NASCIMENTO
  DateField := TDateField.Create(TblClientes);
  DateField.FieldName := 'DTA_NASCIMENTO';
  DateField.DataSet := TblClientes;
  DateField.Name := 'TblClientesDTA_NASCIMENTO';

  // Criando o campo DES_CEP
  StringField := TStringField.Create(TblClientes);
  StringField.FieldName := 'DES_CEP';
  StringField.Size := 10;
  StringField.DataSet := TblClientes;
  StringField.Name := 'TblClientesDES_CEP';

  // Criando o campo DES_ENDERECO
  StringField := TStringField.Create(TblClientes);
  StringField.FieldName := 'DES_ENDERECO';
  StringField.Size := 100;
  StringField.DataSet := TblClientes;
  StringField.Name := 'TblClientesDES_ENDERECO';

  // Criando o campo DES_COMPLEMENTO
  StringField := TStringField.Create(TblClientes);
  StringField.FieldName := 'DES_COMPLEMENTO';
  StringField.Size := 50;
  StringField.DataSet := TblClientes;
  StringField.Name := 'TblClientesDES_COMPLEMENTO';

  // Criando o campo DES_BAIRRO
  StringField := TStringField.Create(TblClientes);
  StringField.FieldName := 'DES_BAIRRO';
  StringField.Size := 50;
  StringField.DataSet := TblClientes;
  StringField.Name := 'TblClientesDES_BAIRRO';

  // Criando o campo DES_CIDADE
  StringField := TStringField.Create(TblClientes);
  StringField.FieldName := 'DES_CIDADE';
  StringField.Size := 100;
  StringField.DataSet := TblClientes;
  StringField.Name := 'TblClientesDES_CIDADE';

  // Criando o campo DES_UF
  StringField := TStringField.Create(TblClientes);
  StringField.FieldName := 'DES_UF';
  StringField.Size := 2;
  StringField.DataSet := TblClientes;
  StringField.Name := 'TblClientesDES_UF';

end;

procedure TFrmCadCliente.PreencherGrid;
begin
  ClienteController.PreencherGrid(TblClientes, Trim(EdtPesquisar.Text) + '%', CbxFiltro.Text);
  GrbGrid.Caption:= ' Clientes cadastrados: ' + InttoStr(DsClientes.DataSet.RecordCount) + ' ';
end;

procedure TFrmCadCliente.CarregarCampos;
begin
  ClienteController.CarregarCampos(QryClientes, FCliente, DsClientes.DataSet.FieldByName('COD_CLIENTE').AsInteger);
  with FCliente do
  begin
    EdtCodigoCliente.Text := IntToStr(Cod_Cliente);
    EdtCpfCnpj.Text := Des_CpfCnpj;
    EdtNome.Text := Des_NomeCliente;
    EdtDataNascimento.Text := DateToStr(Dta_Nascimento);
    EdtCep.Text := Des_Cep;
    EdtEndereco.Text := Des_Endereco;
    EdtComplemento.Text := Des_Complemento;
    EdtBairro.Text := Des_Bairro;
    EdtCidade.Text := Des_Cidade;
    EdtUF.Text := Des_UF;
  end;
  ValoresOriginais[0] := EdtCodigoCliente.Text;
  ValoresOriginais[1] := EdtCpfCnpj.Text;
  ValoresOriginais[2] := EdtNome.Text;
  ValoresOriginais[3] := EdtDataNascimento.Text;
  ValoresOriginais[4] := EdtCep.Text;
  ValoresOriginais[5] := EdtEndereco.Text;
  ValoresOriginais[6] := EdtComplemento.Text;
  ValoresOriginais[7] := EdtBairro.Text;
  ValoresOriginais[8] := EdtCidade.Text;
  ValoresOriginais[9] := EdtUF.Text;
end;

procedure TFrmCadCliente.PnlNovoClick(Sender: TObject);
begin
  inherited;
  FOperacao := opNovo;
  VerificaBotoes(FOperacao);
  LimpaCampos(Self);
  EdtCpfCnpj.SetFocus;
end;


procedure TFrmCadCliente.PnlAlterarClick(Sender: TObject);
begin
  inherited;
  FOperacao := opEditar;
  CarregarCampos;
  VerificaBotoes(FOperacao);
end;

procedure TFrmCadCliente.PnlExcluirClick(Sender: TObject);
begin
  inherited;
  Excluir();
  DsClientes.DataSet.Refresh;
  LimpaCampos(Self);
  GrbGrid.Caption:= ' Clientes cadastrados: ' + InttoStr(DsClientes.DataSet.RecordCount) + ' ';
end;

procedure TFrmCadCliente.PnlGravarClick(Sender: TObject);
begin
  inherited;
  if not ValidarDados then
  begin
    Exit;
  end
  else
  begin
    GravarDados();
    FOperacao := opNavegar;
    VerificaBotoes(FOperacao);
    LimpaCampos(Self);
    GrbGrid.Caption:= ' Clientes cadastrados: ' + InttoStr(DsClientes.DataSet.RecordCount) + ' ';
  end;
end;

procedure TFrmCadCliente.PnlCancelarClick(Sender: TObject);
begin
  inherited;
  if FOperacao = opNovo then
  begin
    FOperacao := opInicio;
    LimpaCampos(Self);
    EdtPesquisar.Text := EmptyStr;
    VerificaBotoes(FOperacao);
  end;

  if FOperacao = opEditar then
  begin
    FOperacao := opNavegar;
    EdtCodigoCliente.Text := ValoresOriginais[0];
    EdtCpfCnpj.Text := ValoresOriginais[1];
    EdtNome.Text := ValoresOriginais[2];
    EdtDataNascimento.Text := ValoresOriginais[3];
    EdtCep.Text := ValoresOriginais[4];
    EdtEndereco.Text := ValoresOriginais[5];
    EdtComplemento.Text := ValoresOriginais[6];
    EdtBairro.Text := ValoresOriginais[7];
    EdtCidade.Text := ValoresOriginais[8];
    EdtUF.Text := ValoresOriginais[9];
    VerificaBotoes(FOperacao);
  end;

  EdtPesquisar.SetFocus;
end;

procedure TFrmCadCliente.Inserir;
var sErro: string;
begin
  with FCliente do
  begin
    Des_CpfCnpj := EdtCpfCnpj.Text;
    Des_NomeCliente := EdtNome.Text;
    if EdtDataNascimento.Text <> EmptyStr then
      Dta_Nascimento := StrToDate(EdtDataNascimento.Text)
    else
      Dta_Nascimento := 0;

    Des_Cep := EdtCep.Text;
    Des_Endereco := EdtEndereco.Text;
    Des_Complemento := EdtComplemento.Text;
    Des_Bairro := EdtBairro.Text;
    Des_Cidade := EdtCidade.Text;
    Des_UF := EdtUF.Text;
  end;

  if ClienteController.Inserir(QryClientes, FCliente, TransacaoClientes, sErro) = false then
    raise Exception.Create(sErro)
  else
    MessageDlg('Cliente inclu�do com sucesso!', mtInformation, [mbOk], 0);

end;

procedure TFrmCadCliente.Alterar;
var sErro: String;
begin
  with FCliente do
  begin
    Des_CpfCnpj := EdtCpfCnpj.Text;
    Des_NomeCliente := EdtNome.Text;
    if EdtDataNascimento.Text <> EmptyStr then
      Dta_Nascimento := StrToDate(EdtDataNascimento.Text)
    else
      Dta_Nascimento := 0;

    Des_Cep := EdtCep.Text;
    Des_Endereco := EdtEndereco.Text;
    Des_Complemento := EdtComplemento.Text;
    Des_Bairro := EdtBairro.Text;
    Des_Cidade := EdtCidade.Text;
    Des_UF := EdtUF.Text;
  end;

  if ClienteController.Alterar(QryClientes, FCliente, TransacaoClientes, StrToInt(EdtCodigoCliente.Text), sErro) = False then
    raise Exception.Create(sErro)
  else
    MessageDlg('Cliente alterado com sucesso!', mtInformation, [mbOK], 0);

end;

procedure TFrmCadCliente.Excluir;
var sErro : String;
begin
  if MessageDlg('Deseja realmente excluir o cliente selecionado ?',mtConfirmation, [mbYes, mbNo],0) = IDYES then
  begin
    if ClienteController.VerificaClienteUtilizado(QryTemp, DsClientes.DataSet.FieldByName('COD_CLIENTE').AsInteger) = True then
    begin
      MessageDlg('Cliente n�o pode ser exclu�do! Existe(m) venda(s) para o cliente selecionado.', mtInformation, [mbOK], 0);
      Exit;
    end;

    if ClienteController.Excluir(QryClientes, TransacaoClientes, DsClientes.DataSet.FieldByName('COD_CLIENTE').AsInteger, sErro) = False then
      raise Exception.Create(sErro)
    else
      MessageDlg('Cliente exclu�do com sucesso!', mtInformation, [mbOK], 0);
  end;
end;

function TFrmCadCliente.ValidarDados: Boolean;
var LErro: TCampoInvalido;
begin
  Result := ClienteController.ValidarDados(EdtNome.Text, EdtCpfCnpj.Text, EdtCidade.Text, EdtUF.Text, LErro);
  if not Result then
  begin
    MostrarMensagemErro(LErro);
    Exit(False);
  end;

  Result := True;
end;

procedure TFrmCadCliente.GravarDados;
begin
   case FOperacao of
    opNovo    : Inserir();
    opEditar  : Alterar();
  end;
  DsClientes.DataSet.Refresh;
  FOperacao := opNavegar
end;

procedure TFrmCadCliente.DbGridClientesDblClick(Sender: TObject);
begin
  inherited;
  FOperacao := opNavegar;
  CarregarCampos;
  VerificaBotoes(FOperacao);
end;

procedure TFrmCadCliente.DbGridClientesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_RETURN then
  begin
    CarregarCampos();
    VerificaBotoes(FOperacao);
    FOperacao := opEditar;
    PnlAlterarClick(Sender);
    Key := 0;
  end;
end;


procedure TFrmCadCliente.CbxFiltroChange(Sender: TObject);
begin
  inherited;
  BtnPesquisar.Click;
  EdtPesquisar.SetFocus;
end;

procedure TFrmCadCliente.EdtPesquisarChange(Sender: TObject);
begin
  inherited;
  PreencherGrid();
end;

procedure TFrmCadCliente.EdtPesquisarKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if Key = #13 then
  begin
    CarregarCampos();
    PnlAlterarClick(Sender);
    Key := #0;
  end;
end;

procedure TFrmCadCliente.BtnPesquisarCepClick(Sender: TObject);
var FCepService: TCEPService;
    JSONValue: TJSONValue;
    JSONObject: TJSONObject;
    Response: string;
begin
  inherited;
  FCepService := TCEPService.Create;
  try
    if EdtCep.Text = EmptyStr then
    begin
      MessageDlg('O CEP a pesquisar deve ser preenchido!', mtInformation, [mbOK], 0);
      Exit;
    end;

    Response := FCepService.ConsultaCep('30320050', True);
    JSONValue := TJSONObject.ParseJSONValue(Response);
    if Assigned(JSONValue) and (JSONValue is TJSONObject) then
    begin
      JSONObject := JSONValue as TJSONObject;
      if JSONObject.GetValue('erro') <> nil then
      begin
        ShowMessage('CEP n�o encontrado!');
        Exit;
      end;

      Formatar(EdtCep, TFormato.CEP);
      EdtEndereco.Text := JSONObject.GetValue<string>('logradouro', '');
      EdtComplemento.Text := JSONObject.GetValue<string>('complemento', '');
      EdtBairro.Text := JSONObject.GetValue<string>('bairro', '');
      EdtCidade.Text := JSONObject.GetValue<string>('localidade', '');
      EdtUf.Text := JSONObject.GetValue<string>('uf', '');
      VerificaBotoes(FOperacao);
    end
    else
      ShowMessage('Erro ao processar a resposta do servi�o de pesquisa do CEP');

  finally
    FreeAndNil(FCepService);
  end;
end;

procedure TFrmCadCliente.BtnPesquisarClick(Sender: TObject);
begin
  inherited;
  PreencherGrid();
end;

procedure TFrmCadCliente.LimpaCampos(Form: TForm);
var i: Integer;
begin
  for i := 0 to Form.ComponentCount - 1 do
  begin
    if Form.Components[i] is TEdit then
    begin
      TEdit(Form.Components[i]).Text := '';
    end;
  end;
  GrbDados.Enabled := FOperacao in [opNovo, opEditar];
  DBGridClientes.Enabled := FOperacao in [opInicio, opNavegar];
end;

procedure TFrmCadCliente.VerificaBotoes(AOperacao: TOperacao);
begin
  PnlNovo.Enabled := AOperacao in [opInicio, opNavegar];
  PnlAlterar.Enabled := AOperacao in [opInicio, opNavegar];
  PnlExcluir.Enabled := AOperacao in [opInicio, opNavegar];
  PnlExcluir.Enabled := not TblClientes.Eof;
  BtnFechar.Enabled := AOperacao in [opInicio, opNavegar];
  PnlGravar.Enabled := AOperacao in [opNovo, opEditar];
  PnlCancelar.Enabled := AOperacao in [opNovo, opEditar];
  GrbDados.Enabled := AOperacao in [opNovo, opEditar];
  DbGridClientes.Enabled := AOperacao in [opInicio, opNavegar];
  PnlPesquisar.Enabled := AOperacao in [opInicio, opNavegar];

  if AOperacao in [opNovo, opEditar] then
  begin
    PnlNovo.Visible := False;
    PnlGravar.BringToFront;
    PnlCancelar.BringToFront;
  end
  else
  begin
    PnlNovo.Visible := True;
    PnlGravar.SendToBack;
    PnlCancelar.SendToBack;
  end
end;

procedure TFrmCadCliente.MostrarMensagemErro(AErro: TCampoInvalido);
begin
  case AErro of
    ciNome:
    begin
      MessageDlg('O nome do cliente deve ser informado!', mtInformation, [mbOK], 0);
      EdtNome.SetFocus;
    end;

    ciCpfCnpj:
    begin
      MessageDlg('O CPF/CNPJ do cliente deve ser informado corretamente!', mtInformation, [mbOK], 0);
      EdtCpfCnpj.SetFocus;
    end;

    ciCpf:
    begin
      MessageDlg('O CPF informado n�o � um CPF v�lido!', mtInformation, [mbOK], 0);
      EdtCpfCnpj.SetFocus;
    end;

    ciCnpj:
    begin
      MessageDlg('O CNPJ informado n�o � um CNPJ v�lido!', mtInformation, [mbOK], 0);
      EdtCpfCnpj.SetFocus;
    end;

    ciCidade:
    begin
      MessageDlg('A cidade do cliente deve ser informada!', mtInformation, [mbOK], 0);
      EdtCidade.SetFocus;
    end;

    ciUF:
    begin
      MessageDlg('A UF do cliente deve ser informada!', mtInformation, [mbOK], 0);
      EdtUF.SetFocus;
    end;
  end;
end;

procedure TFrmCadCliente.EdtCpfCnpjChange(Sender: TObject);
begin
  inherited;
  Formatar(EdtCpfCnpj, TFormato.CNPJorCPF)
end;

procedure TFrmCadCliente.EdtCpfCnpjKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if not (key in ['0'..'9', #08]) then
    key := #0;
end;

procedure TFrmCadCliente.EdtDataNascimentoChange(Sender: TObject);
begin
  inherited;
  Formatar(EdtDataNascimento, TFormato.Dt );
end;

procedure TFrmCadCliente.EdtDataNascimentoKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if not (key in ['0'..'9', '/', #08]) then
    key := #0;
end;

procedure TFrmCadCliente.EdtCepKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if not (key in ['0'..'9', #08]) then
    key := #0;
end;

procedure TFrmCadCliente.BtnFecharClick(Sender: TObject);
begin
  inherited;
  Close;
end;

end.
