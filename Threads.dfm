object fThreads: TfThreads
  Left = 0
  Top = 0
  Caption = 'Threads'
  ClientHeight = 153
  ClientWidth = 363
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 73
    Height = 13
    Caption = 'N'#176' de Threads:'
  end
  object Label2: TLabel
    Left = 8
    Top = 54
    Width = 87
    Height = 13
    Caption = 'Tempo de espera:'
  end
  object Label3: TLabel
    Left = 87
    Top = 73
    Width = 13
    Height = 13
    Caption = 'ms'
  end
  object edNThreads: TEdit
    Left = 8
    Top = 27
    Width = 73
    Height = 21
    TabOrder = 0
    Text = '3'
    OnKeyPress = edNThreadsKeyPress
  end
  object edTempoEspera: TEdit
    Left = 8
    Top = 70
    Width = 73
    Height = 21
    TabOrder = 1
    Text = '10'
    OnKeyPress = edNThreadsKeyPress
  end
  object btExecutar: TButton
    Left = 8
    Top = 97
    Width = 75
    Height = 25
    Caption = 'Executar'
    TabOrder = 2
    OnClick = btExecutarClick
  end
  object ProgressBar: TProgressBar
    Left = 8
    Top = 128
    Width = 348
    Height = 17
    TabOrder = 3
  end
  object Memo1: TMemo
    Left = 111
    Top = 8
    Width = 245
    Height = 114
    TabOrder = 4
  end
end
