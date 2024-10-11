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
  FecharFormulariosAbertos;
  Action := caFree;
end;

procedure TFrmMain.FormCloseHandler(Sender: TObject; var Action: TCloseAction);
var
  Form: TForm;
  i: Integer;
begin
  Form := TForm(Sender);

  // Verificar se o formulário é válido
  if not Assigned(Form) then
    Exit;

  // Identificar a aba correspondente ao formulário fechado
  for i := 0 to PageControlMain.PageCount - 1 do
  begin
    if Assigned(PageControlMain.Pages[i]) and (PageControlMain.Pages[i].Tag = Integer(Form)) then
    begin
      PageControlMain.Pages[i].Free; // Liberar a aba
      Break;
    end;
  end;
end;

function TFrmMain.MouseStillOverPanel: Boolean;
var MousePos: TPoint;
begin
  // Pega a posição atual do mouse
  GetCursorPos(MousePos);
  // Converte para as coordenadas relativas ao formulário
  MousePos := ScreenToClient(MousePos);

  // Verifica se o mouse ainda está sobre o painel lateral
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

procedure TFrmMain.ContrairMenu;
begin
  PnlLateral.Width := 50;
end;

procedure TFrmMain.ExpandirMenu;
begin
  PnlLateral.Width := 137;
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
end;

procedure TFrmMain.OpenTab(const AFormClass: TFormClass; const ATabName: string);
var
  TabSheet: TTabSheet;
  NewForm: TForm;
  i: Integer;
begin
  // Verificar se PageControlMain foi inicializado
  if not Assigned(PageControlMain) then
  begin
    ShowMessage('PageControlMain não está inicializado.');
    Exit;
  end;

  // Verificar se a aba já existe
  for i := 0 to PageControlMain.PageCount - 1 do
  begin
    if PageControlMain.Pages[i].Caption = ATabName then
    begin
      PageControlMain.ActivePage := PageControlMain.Pages[i]; // Focar na aba já existente
      Exit;
    end;
  end;

  // Criar uma nova aba
  TabSheet := TTabSheet.Create(PageControlMain);
  try
    TabSheet.PageControl := PageControlMain;
    TabSheet.Caption := ATabName;

    // Instanciar o formulário
    NewForm := AFormClass.Create(TabSheet);
    try
      NewForm.Parent := TabSheet;
      NewForm.Align := alClient;
      NewForm.BorderStyle := bsNone;
      NewForm.Show;

      // Armazenar o formulário no Tag da aba
      TabSheet.Tag := Integer(NewForm);

      // Associar o evento OnClose para remover a aba
      NewForm.OnClose := FormCloseHandler;
    except
      NewForm.Free; // Liberar o formulário se ocorrer um erro
      raise; // Relançar a exceção para controle externo
    end;

    // Tornar a aba recém-criada ativa
    PageControlMain.ActivePage := TabSheet;
  except
    TabSheet.Free; // Liberar a aba se houver erro
    raise; // Relançar a exceção para controle externo
  end;
end;

procedure TFrmMain.FecharFormulariosAbertos;
var
  i: Integer;
  Form: TForm;
  TabSheet: TTabSheet;
begin
  // Fechar as abas de trás para frente
  for i := PageControlMain.PageCount - 1 downto 0 do
  begin
    TabSheet := PageControlMain.Pages[i];

    // Verificar se a aba existe e se há um formulário associado
    if Assigned(TabSheet) and (TabSheet.Tag <> 0) then
    begin
      Form := TForm(TabSheet.Tag);  // Obter o formulário associado

      // Verificar se o formulário ainda está válido
      if Assigned(Form) then
      begin
        // Fechar o formulário e verificar se pode ser fechado
        if not Form.CloseQuery then
          Exit;

        Form.Release;  // Liberar o formulário de forma segura
      end;

      // Remover a aba da visualização
      PageControlMain.Pages[i].Free;
    end;
  end;
end;

procedure TFrmMain.BtnFecharClick(Sender: TObject);
begin
  FecharFormulariosAbertos;
  Close;
end;

procedure TFrmMain.BtnSairClick(Sender: TObject);
begin
  FecharFormulariosAbertos;
  Close;
end;

end.
