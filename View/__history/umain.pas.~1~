unit umain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.ExtCtrls, ucadastropadrao,
  System.ImageList, Vcl.ImgList;

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
    procedure BtnMenuClick(Sender: TObject);
    procedure BtnSairClick(Sender: TObject);
    procedure PnlLateralMouseEnter(Sender: TObject);
    procedure PnlLateralMouseLeave(Sender: TObject);
    function MouseStillOverPanel: Boolean;
    procedure FormShow(Sender: TObject);
    procedure BtnClientesClick(Sender: TObject);
  private
    procedure ExpandirMenu;
    procedure ContrairMenu;
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;
  BExpandido: Boolean;

implementation

{$R *.dfm}

procedure TFrmMain.BtnClientesClick(Sender: TObject);
begin
  ContrairMenu();

  if not Assigned(FrmCadastroPadrao) then
    FrmCadastroPadrao := TFrmCadastroPadrao.Create(Self);

  FrmCadastroPadrao.ShowModal;
  FrmCadastroPadrao.Free;
  FrmCadastroPadrao := nil;

end;

procedure TFrmMain.BtnMenuClick(Sender: TObject);
begin
  if BExpandido then
    ContrairMenu
  else
    ExpandirMenu;

  BExpandido := not BExpandido;
end;

procedure TFrmMain.BtnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.ContrairMenu;
begin
  PnlLateral.Width := 50;
end;

procedure TFrmMain.ExpandirMenu;
begin
  PnlLateral.Width := 137;
end;

procedure TFrmMain.FormShow(Sender: TObject);
begin
  ContrairMenu();
end;

function TFrmMain.MouseStillOverPanel: Boolean;
var
  MousePos: TPoint;
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

end.
