unit ucadastropadrao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TOperacao = (opInicio, opNovo, opEditar, opNavegar, opErro);
  TFrmCadastroPadrao = class(TForm)
    PnlFundo: TPanel;
    PnlDados: TPanel;
    GrbDados: TGroupBox;
    PnlGrid: TPanel;
    GrbGrid: TGroupBox;
    PnlTopo: TPanel;
    BtnFechar: TSpeedButton;
    PnlNovo: TPanel;
    PnlAlterar: TPanel;
    PnlExcluir: TPanel;
    PnlCancelar: TPanel;
    PnlGravar: TPanel;
    Label2: TLabel;
    procedure BtnFecharClick(Sender: TObject);
    procedure BtnSairClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PnlNovoMouseEnter(Sender: TObject);
    procedure PnlNovoMouseLeave(Sender: TObject);
    procedure PnlAlterarMouseEnter(Sender: TObject);
    procedure PnlAlterarMouseLeave(Sender: TObject);
    procedure PnlExcluirMouseEnter(Sender: TObject);
    procedure PnlExcluirMouseLeave(Sender: TObject);
    procedure PnlGravarMouseEnter(Sender: TObject);
    procedure PnlGravarMouseLeave(Sender: TObject);
    procedure PnlCancelarMouseEnter(Sender: TObject);
    procedure PnlCancelarMouseLeave(Sender: TObject);

  private
    procedure EditEnter(Sender: TObject);
    procedure EditExit(Sender: TObject);
    procedure ApplyEditFocusEvents;

  public
    ValoresOriginais: array of string;
    FOperacao: TOperacao;

  end;

var
  FrmCadastroPadrao: TFrmCadastroPadrao;
  LCorInicial : TColor;

implementation

{$R *.dfm}


procedure TFrmCadastroPadrao.FormCreate(Sender: TObject);
begin
  ApplyEditFocusEvents;  // Aplica eventos para todos os TEdits
end;

procedure TFrmCadastroPadrao.PnlNovoMouseEnter(Sender: TObject);
begin
  LCorInicial := PnlNovo.Color;
  PnlNovo.Color := $00005500;
end;

procedure TFrmCadastroPadrao.PnlNovoMouseLeave(Sender: TObject);
begin
  PnlNovo.Color := clGreen;
end;

procedure TFrmCadastroPadrao.PnlAlterarMouseEnter(Sender: TObject);
begin
  LCorInicial := PnlAlterar.Color;
  PnlAlterar.Color := $000066CC;
end;

procedure TFrmCadastroPadrao.PnlAlterarMouseLeave(Sender: TObject);
begin
  PnlAlterar.Color := $000080FF;
end;

procedure TFrmCadastroPadrao.PnlExcluirMouseEnter(Sender: TObject);
begin
  LCorInicial := PnlExcluir.Color;
  PnlExcluir.Color := $000000B3;
end;

procedure TFrmCadastroPadrao.PnlExcluirMouseLeave(Sender: TObject);
begin
  PnlExcluir.Color := clRed;
end;

procedure TFrmCadastroPadrao.PnlGravarMouseEnter(Sender: TObject);
begin
  LCorInicial := PnlGravar.Color;
  PnlGravar.Color := $00D56A00;
end;

procedure TFrmCadastroPadrao.PnlGravarMouseLeave(Sender: TObject);
begin
  PnlGravar.Color := $00FF962D;
end;

procedure TFrmCadastroPadrao.PnlCancelarMouseEnter(Sender: TObject);
begin
  LCorInicial := PnlCancelar.Color;
  PnlCancelar.Color := $00606060;
end;

procedure TFrmCadastroPadrao.PnlCancelarMouseLeave(Sender: TObject);
begin
  PnlCancelar.Color := clGray;
end;

procedure TFrmCadastroPadrao.EditEnter(Sender: TObject);
begin
  (Sender as TEdit).Color := $00D2FFFF;
end;

procedure TFrmCadastroPadrao.EditExit(Sender: TObject);
begin
  (Sender as TEdit).Color := clWindow;
end;

procedure TFrmCadastroPadrao.ApplyEditFocusEvents;
var i: Integer;
begin
  // Itera por todos os componentes do formul�rio
  for i := 0 to Self.ComponentCount - 1 do
  begin
    // Verifica se o componente � um TEdit
    if (Components[i] is TEdit) then
    begin
      // Associa dinamicamente os eventos OnEnter e OnExit
      (Components[i] as TEdit).OnEnter := EditEnter;
      (Components[i] as TEdit).OnExit := EditExit;
    end;
  end;
end;

procedure TFrmCadastroPadrao.BtnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmCadastroPadrao.BtnSairClick(Sender: TObject);
begin
  Close;
end;

end.
