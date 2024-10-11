unit umain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.ExtCtrls, ucadastropadrao,
  System.ImageList, Vcl.ImgList, Vcl.ComCtrls, Vcl.StdCtrls;

type
  TFrmMain = class(TForm)
    PnlFundo: TPanel;
    PnlLateral: TPanel;
    BtnSair: TSpeedButton;
    BtnRelatorios: TSpeedButton;
    BtnVendas: TSpeedButton;
    BtnProdutos: TSpeedButton;
    BtnClientes: TSpeedButton;
    BtnMenu: TSpeedButton;
    PnlBarra: TPanel;
    ImageList: TImageList;
    PageControlMain: TPageControl;
    PnlTopo: TPanel;
    BtnFechar: TSpeedButton;
    Label2: TLabel;
    BtnMini: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure FormCloseHandler(Sender: TObject; var Action: TCloseAction);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnMenuClick(Sender: TObject);
    procedure BtnClientesClick(Sender: TObject);
    procedure BtnProdutosClick(Sender: TObject);
    procedure BtnVendasClick(Sender: TObject);
    procedure BtnSairClick(Sender: TObject);
    procedure PnlLateralMouseEnter(Sender: TObject);
    procedure PnlLateralMouseLeave(Sender: TObject);
    function MouseStillOverPanel: Boolean;
    procedure BtnMiniClick(Sender: TObject);
    procedure BtnFecharClick(Sender: TObject);

  private
    procedure ExpandirMenu;
    procedure ContrairMenu;
    procedure OpenTab(const AFormClass: TFormClass; const ATabName: string);
    procedure FecharFormulariosAbertos;

  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;
  BExpandido: Boolean;

implementation

uses ucadproduto, ucadcliente, ucadvenda;

{$R *.dfm}

procedure TFrmMain.FormShow(Sender: TObject);
begin
  ContrairMenu();
end;

procedure TFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Fechar todos os formul�rios abertos nas abas
  FecharFormulariosAbertos;

  // Continuar com o fechamento da aplica��o
  Action := caFree;
end;

procedure TFrmMain.FormCloseHandler(Sender: TObject; var Action: TCloseAction);
var i: Integer;
    Form: TForm;
begin
  // Identificar a aba correspondente ao formul�rio fechado
  Form := TForm(Sender);
  for i := 0 to PageControlMain.PageCount - 1 do
  begin
    // Verificar se a aba ainda existe e se est� associada corretamente ao formul�rio
    if Assigned(PageControlMain.Pages[i]) and (PageControlMain.Pages[i].Tag = Integer(Form)) then
    begin
      // Fechar a aba
      PageControlMain.Pages[i].Free;
      Break;
    end;
  end;
end;

function TFrmMain.MouseStillOverPanel: Boolean;
var MousePos: TPoint;
begin
  // Pega a posi��o atual do mouse
  GetCursorPos(MousePos);
  // Converte para as coordenadas relativas ao formul�rio
  MousePos := ScreenToClient(MousePos);

  // Verifica se o mouse ainda est� sobre o painel lateral
  Result := PtInRect(PnlLateral.BoundsRect, MousePos);
end;

procedure TFrmMain.PnlLateralMouseEnter(Sender: TObject);
begin
  ExpandirMenu();
end;

procedure TFrmMain.PnlLateralMouseLeave(Sender: TObject);
begin
  if not BExpandido and not MouseStillOverPanel then
    ContrairMenu();
end;

procedure TFrmMain.BtnMenuClick(Sender: TObject);
begin
  if BExpandido then
    ContrairMenu()
  else
    ExpandirMenu();

  BExpandido := not BExpandido;
end;

procedure TFrmMain.BtnMiniClick(Sender: TObject);
begin
  FrmMain.WindowState := wsMinimized;
end;

procedure TFrmMain.BtnClientesClick(Sender: TObject);
begin
  ContrairMenu();
  OpenTab(TFrmCadCliente, 'Clientes');
end;

procedure TFrmMain.BtnProdutosClick(Sender: TObject);
begin
  ContrairMenu();
  OpenTab(TFrmCadProduto, 'Produtos');
end;

procedure TFrmMain.BtnVendasClick(Sender: TObject);
begin
  ContrairMenu();
  OpenTab(TFrmCadVenda, 'Vendas');

  {if not Assigned(FrmCadVenda) then
    FrmCadVenda := TFrmCadVenda.Create(Self);

  FrmCadVenda.ShowModal;
  FrmCadVenda.Free;
  FrmCadVenda := nil;}
end;

procedure TFrmMain.ContrairMenu;
begin
  PnlLateral.Width := 50;
end;

procedure TFrmMain.ExpandirMenu;
begin
  PnlLateral.Width := 137;
end;

procedure TFrmMain.BtnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.OpenTab(const AFormClass: TFormClass; const ATabName: string);
var
  TabSheet: TTabSheet;
  NewForm: TForm;
  i: Integer;
begin
  // Verificar se a aba j� existe
  for i := 0 to PageControlMain.PageCount - 1 do
  begin
    if PageControlMain.Pages[i].Caption = ATabName then
    begin
      PageControlMain.ActivePage := PageControlMain.Pages[i]; // Focar na aba j� existente
      Exit;
    end;
  end;

  // Criar uma nova aba
  TabSheet := TTabSheet.Create(PageControlMain);
  TabSheet.PageControl := PageControlMain;
  TabSheet.Caption := ATabName;

  // Instanciar o formul�rio e associ�-lo � nova aba
  NewForm := AFormClass.Create(TabSheet);
  NewForm.Parent := TabSheet;
  NewForm.Align := alClient;
  NewForm.BorderStyle := bsNone;
  NewForm.Show;

  // Armazenar o formul�rio no Tag da aba
  TabSheet.Tag := Integer(NewForm); // Guardar a inst�ncia do formul�rio

  // Tornar a aba rec�m-criada ativa
  PageControlMain.ActivePage := TabSheet;
end;

procedure TFrmMain.FecharFormulariosAbertos;
var i: Integer;
    Form: TForm;
    TabSheet: TTabSheet;
begin
  // Fechar as abas de tr�s para frente
  for i := PageControlMain.PageCount - 1 downto 0 do
  begin
    TabSheet := PageControlMain.Pages[i];

    // Verificar se a aba existe
    if Assigned(TabSheet) and (TabSheet.Tag <> 0) then
    begin
      Form := TForm(TabSheet.Tag);  // Obter o formul�rio associado

      // Verificar se o formul�rio ainda est� v�lido
      if Assigned(Form) then
      begin
        // Fechar o formul�rio (sem for�ar a destrui��o)
        if not Form.CloseQuery then
        begin
          Exit; // Se o formul�rio n�o puder ser fechado, interromper o processo
        end;

        Form.Hide;  // Ocultar o formul�rio antes de liberar
        Form.Release;  // Usar Release para liberar o formul�rio de forma segura
      end;

      // Desanexar a aba do controle de abas
      TabSheet.PageControl := nil;
      TabSheet.Free;  // Liberar a aba
    end;
  end;
end;

procedure TFrmMain.BtnSairClick(Sender: TObject);
begin
  FecharFormulariosAbertos;
  Close;
end;

end.
