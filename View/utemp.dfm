object FrmTemp: TFrmTemp
  Left = 0
  Top = 0
  Caption = 'FrmTemp'
  ClientHeight = 422
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 40
    Top = 144
    Width = 577
    Height = 209
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'cod_cliente'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'des_nomecliente'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'des_cidade'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'des_uf'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'des_cep'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'des_endereco'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'des_complemento'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'des_bairro'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'dta_nascimento'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'des_cpfcnpj'
        Visible = True
      end>
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=testewk'
      'User_Name=sa'
      'Password=info'
      'Server=NOTEBOOKALVARO\SQLEXPRESS'
      'DriverID=MSSQL')
    Connected = True
    LoginPrompt = False
    Left = 160
    Top = 72
  end
  object DataSource1: TDataSource
    DataSet = FDQuery1
    Left = 256
    Top = 72
  end
  object FDQuery1: TFDQuery
    Active = True
    Connection = FDConnection1
    SQL.Strings = (
      'select * from tab_cliente')
    Left = 328
    Top = 72
  end
end
