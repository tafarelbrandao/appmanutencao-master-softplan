object fMain: TfMain
  Left = 0
  Top = 0
  Caption = 'Foo'
  ClientHeight = 186
  ClientWidth = 297
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object btDatasetLoop: TButton
    Left = 64
    Top = 35
    Width = 169
    Height = 25
    Caption = 'Dataset Loop'
    TabOrder = 0
    OnClick = btDatasetLoopClick
  end
  object btThreads: TButton
    Left = 64
    Top = 97
    Width = 169
    Height = 25
    Caption = 'Threads'
    TabOrder = 1
    OnClick = btThreadsClick
  end
  object btStreams: TButton
    Left = 64
    Top = 66
    Width = 169
    Height = 25
    Caption = 'ClienteServidor'
    TabOrder = 2
    OnClick = btStreamsClick
  end
  object Button1: TButton
    Left = 64
    Top = 128
    Width = 169
    Height = 25
    Caption = 'Log de exce'#231#245'es'
    TabOrder = 3
    OnClick = Button1Click
  end
  object ApplicationEvents: TApplicationEvents
    OnException = ApplicationEventsException
    Left = 10
    Top = 60
  end
  object CdLogErro: TClientDataSet
    Aggregates = <>
    Params = <>
    Top = 125
    object CdLogErroERRO: TStringField
      FieldName = 'ERRO'
      Size = 100
    end
    object CdLogErroDTINC: TDateTimeField
      FieldName = 'DTINC'
    end
  end
end
