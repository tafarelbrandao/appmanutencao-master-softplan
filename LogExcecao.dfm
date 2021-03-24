object fLogExcecao: TfLogExcecao
  Left = 0
  Top = 0
  Caption = 'fLogExcecao'
  ClientHeight = 299
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
    Left = 0
    Top = 0
    Width = 635
    Height = 265
    Align = alClient
    DataSource = DsLogErro
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'DTINC'
        Title.Caption = 'Data'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'ERRO'
        Title.Caption = 'Exce'#231#227'o'
        Visible = True
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 265
    Width = 635
    Height = 34
    Align = alBottom
    TabOrder = 1
    object Button1: TButton
      Left = 555
      Top = 4
      Width = 75
      Height = 25
      Caption = 'Sair'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object DsLogErro: TDataSource
    DataSet = fMain.CdLogErro
    Left = 350
  end
end
