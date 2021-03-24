unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.AppEvnts,
  Data.DB, Datasnap.DBClient;

type
  TfMain = class(TForm)
    btDatasetLoop: TButton;
    btThreads: TButton;
    btStreams: TButton;
    ApplicationEvents: TApplicationEvents;
    CdLogErro: TClientDataSet;
    CdLogErroERRO: TStringField;
    CdLogErroDTINC: TDateTimeField;
    Button1: TButton;
    procedure btDatasetLoopClick(Sender: TObject);
    procedure btStreamsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ApplicationEventsException(Sender: TObject; E: Exception);
    procedure Button1Click(Sender: TObject);
    procedure btThreadsClick(Sender: TObject);
  private
  public
  end;

var
  fMain: TfMain;

implementation

uses
  DatasetLoop, ClienteServidor, LogExcecao, Threads;

{$R *.dfm}

procedure TfMain.ApplicationEventsException(Sender: TObject;
  E: Exception);
begin
     with CdLogErro do
     begin
          append;
          CdLogErro['erro']:=e.message;
          CdLogErro['dtinc']:=now;
          post;
     end;

end;

procedure TfMain.btDatasetLoopClick(Sender: TObject);
begin
  fDatasetLoop.Show;
end;

procedure TfMain.btStreamsClick(Sender: TObject);
begin
  fClienteServidor.Show;
end;

procedure TfMain.btThreadsClick(Sender: TObject);
begin
  fThreads.show;
end;

procedure TfMain.Button1Click(Sender: TObject);
begin
  fLogExcecao.show;
end;

procedure TfMain.FormCreate(Sender: TObject);
begin
     with CdLogErro do
     begin
          if active then close;
          createdataset;
     end;
end;

end.
