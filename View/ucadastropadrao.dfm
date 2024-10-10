object FrmCadastroPadrao: TFrmCadastroPadrao
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'FrmCadastroPadrao'
  ClientHeight = 532
  ClientWidth = 767
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object PnlFundo: TPanel
    Left = 0
    Top = 0
    Width = 767
    Height = 532
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object PnlDados: TPanel
      Left = 0
      Top = 24
      Width = 767
      Height = 273
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object PnlCancelar: TPanel
        Left = 667
        Top = 9
        Width = 86
        Height = 29
        Color = clGray
        ParentBackground = False
        TabOrder = 4
        OnMouseEnter = PnlCancelarMouseEnter
        OnMouseLeave = PnlCancelarMouseLeave
      end
      object PnlGravar: TPanel
        Left = 577
        Top = 9
        Width = 86
        Height = 29
        Color = 16750125
        ParentBackground = False
        TabOrder = 5
        OnMouseEnter = PnlGravarMouseEnter
        OnMouseLeave = PnlGravarMouseLeave
      end
      object GrbDados: TGroupBox
        Left = 11
        Top = 44
        Width = 743
        Height = 213
        TabOrder = 0
      end
      object PnlNovo: TPanel
        Left = 487
        Top = 9
        Width = 86
        Height = 29
        Caption = 'Novo'
        Color = clGreen
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 1
        OnMouseEnter = PnlNovoMouseEnter
        OnMouseLeave = PnlNovoMouseLeave
      end
      object PnlAlterar: TPanel
        Left = 577
        Top = 9
        Width = 86
        Height = 29
        Caption = 'Alterar'
        Color = 33023
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 2
        OnMouseEnter = PnlAlterarMouseEnter
        OnMouseLeave = PnlAlterarMouseLeave
      end
      object PnlExcluir: TPanel
        Left = 667
        Top = 9
        Width = 86
        Height = 29
        Caption = 'Excluir'
        Color = clRed
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 3
        OnMouseEnter = PnlExcluirMouseEnter
        OnMouseLeave = PnlExcluirMouseLeave
      end
    end
    object PnlGrid: TPanel
      Left = 0
      Top = 297
      Width = 767
      Height = 235
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object GrbGrid: TGroupBox
        Left = 13
        Top = 0
        Width = 741
        Height = 203
        TabOrder = 0
      end
    end
    object PnlTopo: TPanel
      Left = 0
      Top = 0
      Width = 767
      Height = 24
      Align = alTop
      BevelOuter = bvNone
      Color = clGray
      ParentBackground = False
      TabOrder = 2
      DesignSize = (
        767
        24)
      object BtnFechar: TSpeedButton
        Left = 744
        Top = 0
        Width = 22
        Height = 24
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Anchors = [akTop, akRight]
        Flat = True
        Glyph.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000000000080000
          0098000000F4000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000F40000009800000008000000980000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF00000098000000F40000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000F4000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000F800000079000000EB000000FF000000FF0000
          00EB00000079000000F8000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF00000079000000000000002F000000EB000000EB0000
          002F0000000000000079000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000EB0000002F000000000000002F0000002F0000
          00000000002F000000EB000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000EB0000002F00000000000000000000
          002F000000EB000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000EB0000002F00000000000000000000
          002F000000EB000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000EB0000002F000000000000002F0000002F0000
          00000000002F000000EB000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF00000079000000000000002F000000EB000000EB0000
          002F0000000000000079000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000F800000079000000EB000000FF000000FF0000
          00EB00000079000000F8000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000F40000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF000000F4000000980000
          00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000FF000000FF00000098000000080000
          0098000000F4000000FF000000FF000000FF000000FF000000FF000000FF0000
          00FF000000FF000000FF000000FF000000F40000009800000008}
        Margin = 2
        Spacing = 0
        Transparent = False
        OnClick = BtnFecharClick
        ExplicitLeft = 975
      end
      object Label2: TLabel
        Left = 11
        Top = 4
        Width = 105
        Height = 15
        Caption = 'FrmCadastroPadrao'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
    end
  end
end
