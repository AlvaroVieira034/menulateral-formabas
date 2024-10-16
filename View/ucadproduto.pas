unit ucadproduto;

interface

{$REGION 'Uses'}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ucadastropadrao, Vcl.StdCtrls,  Vcl.Buttons, Vcl.ExtCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  conexao.model, produto.model, produto.controller, System.UITypes;

{$ENDREGION}

type
  TFrmCadProduto = class(TFrmCadastroPadrao)

{$REGION 'Componentes'}

    Label1: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    EdtPrecoUnitario: TEdit;
    EdtCodProduto: TEdit;
    EdtDescricao: TEdit;
    DBGridProdutos: TDBGrid;
    PnlPesquisar: TPanel;
    Label4: TLabel;
    BtnPesquisar: TSpeedButton;
    EdtPesquisar: TEdit;
    CbxFiltro: TComboBox;

{$ENDREGION}

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CbxFiltroChange(Sender: TObject);
    procedure BtnPesquisarClick(Sender: TObject);
    procedure DBGridProdutosDblClick(Sender: TObject);
    procedure DBGridProdutosKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PnlNovoClick(Sender: TObject);
    procedure PnlAlterarClick(Sender: TObject);
    procedure PnlExcluirClick(Sender: TObject);
    procedure PnlGravarClick(Sender: TObject);
    procedure PnlCancelarClick(Sender: TObject);
    procedure EdtPesquisarChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EdtPesquisarKeyPress(Sender: TObject; var Key: Char);
    procedure EdtPrecoUnitarioExit(Sender: TObject);
    procedure EdtPrecoUnitarioKeyPress(Sender: TObject; var Key: Char);
    procedure BtnFecharClick(Sender: TObject);


  private
    TblProdutos: TFDQuery;
    QryProdutos: TFDQuery;
    QryTemp: TFDQuery;
    DsProdutos: TDataSource;
    TransacaoProdutos: TFDTransaction;
    FProduto: TProduto;
    ProdutoController: TProdutoController;

    procedure CriarTabelas;
    procedure CriarCamposTabelas;
    procedure PreencherGrid;
    procedure CarregarCampos;
    procedure Inserir;
    procedure Alterar;
    procedure Excluir;
    function ValidarDados: Boolean;
    procedure GravarDados;
    procedure LimpaCampos();
    procedure VerificaBotoes(AOperacao: TOperacao);
    procedure MostrarMensagemErro(AErro: TCampoInvalido);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  end;

var
  FrmCadProduto: TFrmCadProduto;

implementation

{$R *.dfm}

{ TFrmCadProduto }


constructor TFrmCadProduto.Create(AOwner: TComponent);
begin
  inherited;
  TransacaoProdutos := TFDTransaction.Create(nil);
  DsProdutos := TDataSource.Create(nil);
  TblProdutos := TFDQuery.Create(nil);
  QryProdutos := TFDQuery.Create(nil);
  QryTemp := TFDQuery.Create(nil);
end;

destructor TFrmCadProduto.Destroy;
begin
  TransacaoProdutos.Free;
  DsProdutos.Free;
  TblProdutos.Free;
  QryProdutos.Free;
  QryTemp.Free;
  inherited;

end;

procedure TFrmCadProduto.FormCreate(Sender: TObject);
begin
  inherited;
  if TConexao.GetInstance.Connection.TestarConexao then
  begin
    TConexao.GetInstance.Connection.InciarTransacao;
    CriarTabelas();
    CriarCamposTabelas();
    FProduto := TProduto.Create;
    ProdutoController := TProdutoController.Create;
    FOperacao := opInicio;
    SetLength(ValoresOriginais, 3);
  end
  else
  begin
    ShowMessage('N�o foi poss�vel conectar ao banco de dados!');
    Close;
  end;
end;

procedure TFrmCadProduto.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_RETURN then
    perform(WM_NEXTDLGCTL,0,0)
end;

procedure TFrmCadProduto.FormShow(Sender: TObject);
begin
  inherited;
  PreencherGrid();
  VerificaBotoes(FOperacao);
  if EdtPesquisar.CanFocus then
    EdtPesquisar.SetFocus;
end;

procedure TFrmCadProduto.CriarTabelas;
begin
  TransacaoProdutos := TConexao.GetInstance.Connection.CriarTransaction;
  TblProdutos := TConexao.GetInstance.Connection.CriarQuery;
  QryProdutos := TConexao.GetInstance.Connection.CriarQuery;
  QryTemp := TConexao.GetInstance.Connection.CriarQuery;
  QryProdutos.Transaction := TransacaoProdutos;
  DsProdutos := TConexao.GetInstance.Connection.CriarDataSource;
  DsProdutos.DataSet := TblProdutos;
  DBGridProdutos.DataSource := DsProdutos;
end;

procedure TFrmCadProduto.CriarCamposTabelas;
var StringField: TStringField;
    IntegerField: TIntegerField;
    FloatField: TFloatField;
begin
  // Criando o campo COD_PRODUTO
  IntegerField := TIntegerField.Create(TblProdutos);
  IntegerField.FieldName := 'COD_PRODUTO';
  IntegerField.DataSet := TblProdutos;
  IntegerField.Name := 'TblProdutosCOD_PRODUTO';

  // Criando o campo NOME_PRODUTO
  StringField := TStringField.Create(TblProdutos);
  StringField.FieldName := 'DES_DESCRICAO';
  StringField.Size := 100;
  StringField.DataSet := TblProdutos;
  StringField.Name := 'TblProdutosDES_DESCRICAO';

  // Criando o campo VAL_PRECO
  FloatField := TFloatField.Create(TblProdutos);
  FloatField.FieldName := 'VAL_PRECO';
  FloatField.DataSet := TblProdutos;
  FloatField.Name := 'TblProdutosVAL_PRECO';
  FloatField.DisplayFormat := '#,###,##0.00';
end;

procedure TFrmCadProduto.PreencherGrid;
begin
  ProdutoController.PreencherGrid(TblProdutos, Trim(EdtPesquisar.Text) + '%', CbxFiltro.Text);
  GrbGrid.Caption:= ' Produtos cadastrados: ' + InttoStr(DsProdutos.DataSet.RecordCount) + ' ';
end;

procedure TFrmCadProduto.CarregarCampos;
begin
  ProdutoController.CarregarCampos(QryProdutos, FProduto, DsProdutos.DataSet.FieldByName('COD_PRODUTO').AsInteger);
  with FProduto do
  begin
    EdtCodProduto.Text := IntToStr(Cod_Produto);
    EdtDescricao.Text := Des_Descricao;
    EdtPrecoUnitario.Text := FormatFloat('######0.00', Val_Preco);
  end;
  ValoresOriginais[0] := EdtCodProduto.Text;
  ValoresOriginais[1] := EdtDescricao.Text;
  ValoresOriginais[2] := EdtPrecoUnitario.Text;
end;

procedure TFrmCadProduto.PnlNovoClick(Sender: TObject);
begin
  inherited;
  FOperacao := opNovo;
  VerificaBotoes(FOperacao);
  LimpaCampos();
  EdtDescricao.SetFocus;
end;

procedure TFrmCadProduto.PnlAlterarClick(Sender: TObject);
begin
  inherited;
  FOperacao := opEditar;
  CarregarCampos;
  VerificaBotoes(FOperacao);
end;

procedure TFrmCadProduto.PnlCancelarClick(Sender: TObject);
begin
  inherited;
  if FOperacao = opNovo then
  begin
    FOperacao := opInicio;
    LimpaCampos();
    EdtPesquisar.Text := EmptyStr;
    VerificaBotoes(FOperacao);
  end;

  if FOperacao = opEditar then
  begin
    FOperacao := opNavegar;
    EdtCodProduto.Text := ValoresOriginais[0];
    EdtDescricao.Text := ValoresOriginais[1];
    EdtPrecoUnitario.Text := ValoresOriginais[2];
    VerificaBotoes(FOperacao);
  end;
  EdtPesquisar.SetFocus;
end;

procedure TFrmCadProduto.PnlExcluirClick(Sender: TObject);
begin
  inherited;
  Excluir();
  DsProdutos.DataSet.Refresh;
  LimpaCampos();
  GrbGrid.Caption:= ' Produtos cadastrados: ' + InttoStr(DsProdutos.DataSet.RecordCount) + ' ';
end;

procedure TFrmCadProduto.PnlGravarClick(Sender: TObject);
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
    LimpaCampos();
    GrbGrid.Caption:= ' Produtos cadastrados: ' + InttoStr(DsProdutos.DataSet.RecordCount) + ' ';
  end;
end;

procedure TFrmCadProduto.VerificaBotoes(AOperacao: TOperacao);
begin
  PnlNovo.Enabled := AOperacao in [opInicio, opNavegar];
  PnlAlterar.Enabled := AOperacao in [opInicio, opNavegar];
  PnlExcluir.Enabled := AOperacao in [opInicio, opNavegar];
  PnlExcluir.Enabled := not TblProdutos.Eof;
  BtnFechar.Enabled := AOperacao in [opInicio, opNavegar];
  PnlGravar.Enabled := AOperacao in [opNovo, opEditar];
  PnlCancelar.Enabled := AOperacao in [opNovo, opEditar];
  GrbDados.Enabled := AOperacao in [opNovo, opEditar];
  DBGridProdutos.Enabled := AOperacao in [opInicio, opNavegar];
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

procedure TFrmCadProduto.Inserir;
var sErro: string;
begin
  with FProduto do
  begin
    Des_Descricao := EdtDescricao.Text;
    Val_Preco := StrToFloat(
    StringReplace(StringReplace(EdtPrecoUnitario.Text, '.', '', [rfReplaceAll]), ',', FormatSettings.DecimalSeparator, [rfReplaceAll]));
  end;

  if ProdutoController.Inserir(QryProdutos, FProduto, TransacaoProdutos, sErro) = false then
    raise Exception.Create(sErro)
  else
    MessageDlg('Produto inclu�do com sucesso!', mtInformation, [mbOk], 0);
end;

procedure TFrmCadProduto.Alterar;
var sErro: String;
begin
  with FProduto do
  begin
    Des_Descricao := EdtDescricao.Text;
    Val_Preco := StrToFloat(
    StringReplace(StringReplace(EdtPrecoUnitario.Text, '.', '', [rfReplaceAll]), ',', FormatSettings.DecimalSeparator, [rfReplaceAll]));
  end;

  if ProdutoController.Alterar(QryProdutos, FProduto, TransacaoProdutos, StrToInt(EdtCodProduto.Text), sErro) = False then
    raise Exception.Create(sErro)
  else
    MessageDlg('Produto alterado com sucesso!', mtInformation, [mbOK], 0);

end;

procedure TFrmCadProduto.Excluir;
var sErro : String;
begin
  if MessageDlg('Deseja realmente excluir o produto selecionado ?',mtConfirmation, [mbYes, mbNo],0) = IDYES then
  begin
    if ProdutoController.VerificaProdutoUtilizado(QryTemp, DsProdutos.DataSet.FieldByName('COD_PRODUTO').AsInteger) = True then
    begin
      MessageDlg('Produto n�o pode ser exclu�do! Existe(m) venda(s) para o produto selecionado.', mtInformation, [mbOK], 0);
      Exit;
    end;

    if ProdutoController.Excluir(QryProdutos, TransacaoProdutos, DsProdutos.DataSet.FieldByName('COD_PRODUTO').AsInteger, sErro) = False then
      raise Exception.Create(sErro)
    else
      MessageDlg('Produto exclu�do com sucesso!', mtInformation, [mbOK], 0);
  end;
end;

procedure TFrmCadProduto.GravarDados;
begin
  case FOperacao of
    opNovo    : Inserir();
    opEditar  : Alterar();
  end;
  DsProdutos.DataSet.Refresh;
  FOperacao := opNavegar
end;

function TFrmCadProduto.ValidarDados: Boolean;
var LErro: TCampoInvalido;
begin
  Result := ProdutoController.ValidarDados(EdtDescricao.Text, EdtPrecoUnitario.Text, LErro);
  if not Result then
  begin
    MostrarMensagemErro(LErro);
    Exit(False);
  end;

  Result := True;
end;

procedure TFrmCadProduto.CbxFiltroChange(Sender: TObject);
begin
  inherited;
  BtnPesquisar.Click;
  EdtPesquisar.SetFocus;
end;

procedure TFrmCadProduto.EdtPesquisarChange(Sender: TObject);
begin
  inherited;
  PreencherGrid();
end;

procedure TFrmCadProduto.EdtPesquisarKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if Key = #13 then
  begin
    CarregarCampos();
    PnlAlterarClick(Sender);
    Key := #0;
  end;
end;

procedure TFrmCadProduto.BtnPesquisarClick(Sender: TObject);
begin
  inherited;
  PreencherGrid();
end;

procedure TFrmCadProduto.DBGridProdutosDblClick(Sender: TObject);
begin
  inherited;
  FOperacao := opNavegar;
  CarregarCampos;
  VerificaBotoes(FOperacao);
end;

procedure TFrmCadProduto.DBGridProdutosKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
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

procedure TFrmCadProduto.MostrarMensagemErro(AErro: TCampoInvalido);
begin
  case AErro of
    ciDescricao:
    begin
      MessageDlg('A descri��o do produto deve ser informada!', mtInformation, [mbOK], 0);
      EdtDescricao.SetFocus;
    end;

    ciPreco, ciPrecoZero:
    begin
      MessageDlg('O pre�o unit�rio deve ser maior que 0!', mtInformation, [mbOK], 0);
      EdtPrecoUnitario.SetFocus;
    end;
  end;
end;

procedure TFrmCadProduto.LimpaCampos();
begin
  EdtCodProduto.Text := '';
  EdtDescricao.Text := '';
  EdtPrecoUnitario.Text := '0.00';
  GrbDados.Enabled := FOperacao in [opNovo, opEditar];
  DBGridProdutos.Enabled := FOperacao in [opInicio, opNavegar];
end;

procedure TFrmCadProduto.EdtPrecoUnitarioExit(Sender: TObject);
var LValor: Double;
begin
  inherited;
  if TryStrToFloat(EdtPrecoUnitario.Text, LValor) then
    EdtPrecoUnitario.Text := FormatFloat('#,###,##0.00', LValor)
end;

procedure TFrmCadProduto.EdtPrecoUnitarioKeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  if not (key in ['0'..'9', ',', #08]) then
    key := #0;
end;

procedure TFrmCadProduto.BtnFecharClick(Sender: TObject);
begin
  inherited;
  Close;
end;


end.
