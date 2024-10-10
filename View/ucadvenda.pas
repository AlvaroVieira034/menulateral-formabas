unit ucadvenda;

interface

{$REGION 'Uses'}

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ucadastropadrao, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls,
  Vcl.DBCtrls, Vcl.Buttons, Vcl.ExtCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, conexao.model, produto.model, produto.controller, cliente.model, cliente.controller,
  venda.model, vendaitens.model, venda.controller, vendaitens.controller, untFormat, upesqvendas;

{$ENDREGION}

type
  TOperacao = (opInicio, opNovo, opEditar, opNavegar, opErro);
  TFrmCadVenda = class(TFrmCadastroPadrao)

{$REGION 'Componentes'}
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    BtnLimpaCampos: TSpeedButton;
    BtnPesquisar: TSpeedButton;
    EdtCodVenda: TEdit;
    EdtDataVenda: TEdit;
    EdtTotalVenda: TEdit;
    EdtCodCliente: TEdit;
    LcbxNomeCliente: TDBLookupComboBox;
    BtnInserirItens: TButton;
    Label10: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    EdtQuantidade: TEdit;
    EdtPrecoUnit: TEdit;
    EdtPrecoTotal: TEdit;
    LCbxProdutos: TDBLookupComboBox;
    BtnAddItemGrid: TButton;
    BtnDelItemGrid: TButton;
    DbGridItensPedido: TDBGrid;
    procedure BtnPesquisarClick(Sender: TObject);
    procedure PnlAlterarClick(Sender: TObject);

{$ENDREGION}

  private
    TblProdutos: TFDQuery;
    TblClientes: TFDQuery;
    TblVendas: TFDQuery;
    TblVendaItens: TFDQuery;
    QryVendas: TFDQuery;
    QryVendaItens: TFDQuery;
    QryTemp: TFDQuery;
    DsProdutos: TDataSource;
    DsClientes: TDataSource;
    DsVendas: TDataSource;
    TransacaoVendas: TFDTransaction;
    FProduto: TProduto;
    ProdutoController: TProdutoController;
    FCliente: TCliente;
    ClienteController: TClienteController;
    FVenda: TVenda;
    VendaController: TVendaController;
    FVendaItens: TVendaItens;
    VendaItensController: TVendaItensController;

    procedure CarregarVendas(ACodVenda: Integer);
    procedure Inserir;
    procedure InserirVendas;
    procedure InserirVendaItens;
    procedure Alterar;
    procedure AlterarVendas;
    procedure AlterarVendaItens;
    procedure ExcluirVendas;
    function ValidarDados(ATipoDados: string): Boolean;
    procedure LimpaCamposPedido;
    procedure LimpaCamposItens;
    procedure PreencheCdsVendaItem;
    procedure VerificaBotoes(AOperacao: TOperacao);
    procedure HabilitarBotaoIncluirItens;

  public
    FOperacao: TOperacao;
    pesqVenda: Boolean;
    codigoVenda: Integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  end;

var
  FrmCadVenda: TFrmCadVenda;
  totVenda, totVendaAnt: Double;
  idItem: Integer;
  alterouGrid: Boolean;

implementation

{$R *.dfm}

{ TFrmCadVenda }

constructor TFrmCadVenda.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TFrmCadVenda.Destroy;
begin

  inherited;
end;

procedure TFrmCadVenda.CarregarVendas(ACodVenda: Integer);
begin

end;

procedure TFrmCadVenda.Inserir;
begin

end;

procedure TFrmCadVenda.InserirVendas;
begin

end;

procedure TFrmCadVenda.InserirVendaItens;
begin

end;

procedure TFrmCadVenda.Alterar;
begin

end;

procedure TFrmCadVenda.AlterarVendas;
begin

end;

procedure TFrmCadVenda.BtnPesquisarClick(Sender: TObject);
var LCodvenda: Integer;
begin
  inherited;
  pesqVenda := False;

  if TryStrToInt(EdtCodVenda.Text, LCodvenda) then
    LCodvenda := StrToInt(EdtCodVenda.Text)
  else
    LCodvenda := 0;

  if EdtCodVenda.Text = EmptyStr then // Pesquisa atrav�s da janela de pesquisa.
  begin
    if not Assigned(FrmPesquisaVendas) then
      FrmPesquisaVendas := TFrmPesquisaVendas.Create(Self);

    FrmPesquisaVendas.ShowModal;
    FrmPesquisaVendas.Free;
    FrmPesquisaVendas := nil;

    if pesqVenda then
    begin
      CarregarVendas(0);
      ValoresOriginais[0] := EdtCodVenda.Text;
      ValoresOriginais[1] := EdtDataVenda.Text;
      ValoresOriginais[2] := EdtCodCliente.Text;
      ValoresOriginais[3] := EdtTotalVenda.Text;
      //EdtCodClienteExit(Sender);

      if FOperacao = opEditar then
        PnlAlterarClick(Sender);

      VerificaBotoes(FOperacao);
    end;
  end;

  if LCodvenda > 0 then  // Pesquisa informando o codigo da venda.
  begin
    CarregarVendas(LCodvenda);
    //EdtCodClienteExit(Sender);
    FOperacao := opNavegar;
    VerificaBotoes(FOperacao);
  end;

end;

procedure TFrmCadVenda.AlterarVendaItens;
begin

end;

procedure TFrmCadVenda.ExcluirVendas;
begin

end;

procedure TFrmCadVenda.HabilitarBotaoIncluirItens;
begin

end;

procedure TFrmCadVenda.LimpaCamposPedido;
begin

end;

procedure TFrmCadVenda.LimpaCamposItens;
begin

end;

procedure TFrmCadVenda.PnlAlterarClick(Sender: TObject);
begin
  inherited;
  //
end;

procedure TFrmCadVenda.PreencheCdsVendaItem;
begin

end;

function TFrmCadVenda.ValidarDados(ATipoDados: string): Boolean;
begin

end;

procedure TFrmCadVenda.VerificaBotoes(AOperacao: TOperacao);
begin

end;

end.
