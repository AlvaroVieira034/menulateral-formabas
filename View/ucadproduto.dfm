inherited FrmCadProduto: TFrmCadProduto
  Caption = 'FrmCadProduto'
  ClientHeight = 631
  ClientWidth = 674
  KeyPreview = True
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  ExplicitWidth = 674
  ExplicitHeight = 631
  PixelsPerInch = 96
  TextHeight = 15
  inherited PnlFundo: TPanel
    Width = 674
    Height = 631
    ExplicitWidth = 674
    ExplicitHeight = 631
    inherited PnlDados: TPanel
      Width = 674
      Height = 193
      ExplicitWidth = 674
      ExplicitHeight = 193
      inherited PnlCancelar: TPanel
        Left = 577
        Caption = 'Cancelar'
        Font.Color = clWhite
        Font.Height = -13
        ParentFont = False
        OnClick = PnlCancelarClick
        ExplicitLeft = 577
      end
      inherited PnlGravar: TPanel
        Left = 487
        Caption = 'Gravar'
        Font.Color = clWhite
        Font.Height = -13
        ParentFont = False
        OnClick = PnlGravarClick
        ExplicitLeft = 487
      end
      inherited GrbDados: TGroupBox
        Top = 40
        Width = 652
        Height = 151
        Caption = ' Dados do produto '
        ExplicitTop = 40
        ExplicitWidth = 652
        ExplicitHeight = 151
        object Label1: TLabel
          Left = 69
          Top = 42
          Width = 42
          Height = 15
          Caption = '&C'#243'digo:'
        end
        object Label3: TLabel
          Left = 35
          Top = 99
          Width = 78
          Height = 15
          Caption = '&Pre'#231'o Unit'#225'rio:'
        end
        object Label6: TLabel
          Left = 56
          Top = 71
          Width = 54
          Height = 15
          Caption = '&Descri'#231#227'o:'
        end
        object EdtPrecoUnitario: TEdit
          Left = 121
          Top = 96
          Width = 76
          Height = 23
          Alignment = taRightJustify
          CharCase = ecUpperCase
          MaxLength = 12
          TabOrder = 2
          Text = '0.00'
          OnExit = EdtPrecoUnitarioExit
          OnKeyPress = EdtPrecoUnitarioKeyPress
        end
        object EdtCodProduto: TEdit
          Left = 121
          Top = 39
          Width = 76
          Height = 23
          Enabled = False
          TabOrder = 0
        end
        object EdtDescricao: TEdit
          Left = 121
          Top = 67
          Width = 331
          Height = 23
          CharCase = ecUpperCase
          MaxLength = 100
          TabOrder = 1
        end
      end
      inherited PnlNovo: TPanel
        Left = 397
        OnClick = PnlNovoClick
        ExplicitLeft = 397
      end
      inherited PnlAlterar: TPanel
        Left = 487
        OnClick = PnlAlterarClick
        ExplicitLeft = 487
      end
      inherited PnlExcluir: TPanel
        Left = 577
        OnClick = PnlExcluirClick
        ExplicitLeft = 577
      end
    end
    inherited PnlGrid: TPanel
      Top = 217
      Width = 674
      Height = 414
      ExplicitTop = 217
      ExplicitWidth = 674
      ExplicitHeight = 414
      inherited GrbGrid: TGroupBox
        Left = 11
        Top = 1
        Width = 652
        Height = 359
        Caption = ' Produtos cadastrados '
        ExplicitLeft = 11
        ExplicitTop = 1
        ExplicitWidth = 652
        ExplicitHeight = 359
        object DBGridProdutos: TDBGrid
          Left = 9
          Top = 19
          Width = 634
          Height = 329
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = '\'
          Font.Style = []
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgTitleHotTrack]
          ParentFont = False
          TabOrder = 0
          TitleFont.Charset = ANSI_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
          OnDblClick = DBGridProdutosDblClick
          OnKeyDown = DBGridProdutosKeyDown
          Columns = <
            item
              Expanded = False
              FieldName = 'cod_produto'
              Title.Alignment = taCenter
              Title.Caption = 'C'#243'digo'
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'des_descricao'
              Title.Caption = 'Descri'#231#227'o do Produto'
              Width = 292
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'val_preco'
              Title.Alignment = taCenter
              Title.Caption = 'Valor Unit'#225'rio'
              Width = 95
              Visible = True
            end>
        end
      end
      object PnlPesquisar: TPanel
        Left = 0
        Top = 371
        Width = 674
        Height = 43
        Align = alBottom
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 1
        object Label4: TLabel
          Left = 14
          Top = 12
          Width = 43
          Height = 11
          Caption = 'Filtrar por:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -9
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object BtnPesquisar: TSpeedButton
          Left = 563
          Top = 4
          Width = 86
          Height = 27
          Caption = '&Pesquisar'
          Glyph.Data = {
            36030000424D3603000000000000360000002800000010000000100000000100
            18000000000000030000C40E0000C40E00000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFCCCCCCCCCCCCF5F5F5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFCCCCCC497FAA4980ACB1BDC6CFCFCFCCCCCC
            CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC407F
            AF1EAAFF5AC8FF4593C7BB8825B67E0EB57B09B67E0DB88113BB8211B6831B90
            7E5B7A7A7C7B79787B79788F816B72A1C558C8FFBAF2FF4193CCB67E0EFFFFFF
            FFFFFFFFFFFFB47800F0EEF481848DB6B9BEE4E8ECE2E5EAE4E6EAB8B7B7827A
            76CFE3ED3290D4FFFFFFB47B09FFFFFFFFFFFFFFFFFFC99A3B928267B9BBBFE8
            DDCEEEC57DF6D789FCE49AECE7D8BBBABC9B9084FFFFFFFFFFFFB47A07FFFFFF
            FFFFFFFFFFFFFFFFFF7B7A7CF0F3F8E7B572F0CF92F6DC94FFEFA4FBE499F0F2
            F8818288FFFFFFFFFFFFB47A08FFFFFFFFFFFFFFFFFFE1CAB07F7F81F5F9FEEB
            C696F5E1BEF3DAA0F6DB94F4D587F5F9FF868587FFFFFFFFFFFFB47B08FFFFFF
            D5BB9DDAC3A8B65A0084888CFEFFFFE3B076FAF2E4F4E1BDEFCE91ECC37CFEFF
            FF8A898BFFFFFFFFFFFFB47B08FFFFFFFFFFF7FFFFFFB65E06A9A39BCED2D5F6
            E3CFE2B074E9C494E5B571F8EBD7CFD1D79C8A67FFFFFFFFFFFFB47B09FFFFFF
            D6B892DBC1A1B5600ACBA2748F9093D3D7DCFFFFFFFFFFFFFFFFFFD1D3D79293
            9CB7821AFFFFFFFFFFFFB47B08FFFFFFFFFBE4FFFFF2B5600BE2B580D7AC7A9F
            8A7491959B9194988F9195B5B1ABFFFFFFB87E09FFFFFFFFFFFFB57B08FFFFFF
            DDB382E1BB8EB95D04BD6108BE6106BD6106C06003C06001BB5B00E2BA8BFFFF
            FFB67C09FFFFFFFFFFFFB57C09FFFFFF44C4FF46C8FFE5BB8649CEFF4ACFFFE7
            BD894ACFFF4ACEFFE5BA8542C7FFFFFFFFB67C09FFFFFFFFFFFFB67E0EFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFB67E0EFFFFFFFFFFFFBD8C27B67E0EB67C09B67B08B57B08B67B08B67B08B5
            7B08B67B08B67B08B57B08B67C09B67E0EBD8C27FFFFFFFFFFFF}
          OnClick = BtnPesquisarClick
        end
        object EdtPesquisar: TEdit
          Left = 149
          Top = 7
          Width = 409
          Height = 23
          CharCase = ecUpperCase
          TabOrder = 1
          OnChange = EdtPesquisarChange
          OnKeyPress = EdtPesquisarKeyPress
        end
        object CbxFiltro: TComboBox
          Left = 62
          Top = 7
          Width = 84
          Height = 23
          ItemIndex = 1
          TabOrder = 0
          Text = 'Descri'#231#227'o'
          OnChange = CbxFiltroChange
          Items.Strings = (
            'C'#243'digo'
            'Descri'#231#227'o')
        end
      end
    end
    inherited PnlTopo: TPanel
      Width = 674
      Font.Name = #39#39#39
      ParentFont = False
      ExplicitWidth = 674
      inherited BtnFechar: TSpeedButton
        Left = 651
        Transparent = True
        ExplicitLeft = 651
      end
      inherited Label2: TLabel
        Width = 114
        Caption = 'Cadastro de Produtos'
        ExplicitWidth = 114
      end
    end
  end
end
