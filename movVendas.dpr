program movVendas;

uses
  Vcl.Forms,
  umain in 'View\umain.pas' {FrmMain},
  ucadastropadrao in 'View\ucadastropadrao.pas' {FrmCadastroPadrao},
  ucadproduto in 'View\ucadproduto.pas' {FrmCadProduto},
  cliente.model in 'Model\cliente.model.pas',
  clienterepository.model in 'Model\clienterepository.model.pas',
  conexao.model in 'Model\conexao.model.pas',
  connection.model in 'Model\connection.model.pas',
  produto.model in 'Model\produto.model.pas',
  produtorepository.model in 'Model\produtorepository.model.pas',
  venda.model in 'Model\venda.model.pas',
  vendaitens.model in 'Model\vendaitens.model.pas',
  vendaitensrepository.model in 'Model\vendaitensrepository.model.pas',
  vendarepository.model in 'Model\vendarepository.model.pas',
  cliente.controller in 'Controller\cliente.controller.pas',
  produto.controller in 'Controller\produto.controller.pas',
  venda.controller in 'Controller\venda.controller.pas',
  vendaitens.controller in 'Controller\vendaitens.controller.pas',
  ucadcliente in 'View\ucadcliente.pas' {FrmCadCliente},
  utemp in 'View\utemp.pas' {FrmTemp},
  ucadvenda in 'View\ucadvenda.pas' {FrmCadVenda},
  upesqvendas in 'View\upesqvendas.pas' {FrmPesquisaVendas},
  untFormat in 'Lib\untFormat.pas',
  cepservice.model in 'Model\cepservice.model.pas',
  Biblioteca in 'Lib\Biblioteca.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TFrmCadVenda, FrmCadVenda);
  Application.CreateForm(TFrmPesquisaVendas, FrmPesquisaVendas);
  Application.Run;
end.
