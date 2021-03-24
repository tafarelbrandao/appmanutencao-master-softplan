unit Threads;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, System.Threading ;

type
  TThreadProcessamento = class(TThread)
  private
    TempoMaximoEspera: integer;
  protected
    procedure Execute; override;
  public
    constructor Create(_TempoMaximoEspera:integer);
  end;

  TfThreads = class(TForm)
    edNThreads: TEdit;
    edTempoEspera: TEdit;
    btExecutar: TButton;
    ProgressBar: TProgressBar;
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure edNThreadsKeyPress(Sender: TObject; var Key: Char);
    procedure btExecutarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fThreads: TfThreads;

implementation

{$R *.dfm}

procedure TfThreads.btExecutarClick(Sender: TObject);
var
  TempoMaximoEspera:Integer;
begin
  if trim(edNThreads.text)='' then edNThreads.text:='1';
  if trim(edTempoEspera.text)='' then edTempoEspera.text:='0';

  ProgressBar.max:=101*strtoint(edNThreads.text)-1;
  ProgressBar.position:=0;

  if edNThreads.text='0' then
  begin
    ShowMessage('Não é possível processar com 0 Threads !');
    exit;
  end;

  TempoMaximoEspera := strtoint(edTempoEspera.text);

  Memo1.Lines.Clear;



  TTask.Run(
    procedure
    begin
      TParallel.For(0,strtoint(edNThreads.text)-1,
      procedure (Index: Integer)
      begin
          TThreadProcessamento.Create(TempoMaximoEspera);
      end);
    end);
end;

procedure TfThreads.edNThreadsKeyPress(Sender: TObject; var Key: Char);
begin
  if (not (CharInSet(Key,['0'..'9',#8]))  and (word(key) <> vk_back)) then
    key := #0;
end;

{ TThreadProcessamento }

constructor TThreadProcessamento.Create(_TempoMaximoEspera:integer);
begin
  inherited create(false);
  TempoMaximoEspera := _TempoMaximoEspera;
  FreeOnTerminate := true;
end;

procedure TThreadProcessamento.Execute;
var
  i:integer;
begin
  inherited;

  fThreads.Memo1.Lines.Add(IntToStr(TThreadProcessamento.CurrentThread.ThreadID)+' - Iniciando processamento');

  for i := 0 to 100 do
  begin
    TThread.Sleep(Random(Self.TempoMaximoEspera));
    TThread.Synchronize(TThread.CurrentThread,
        procedure
        begin
          fThreads.ProgressBar.position := fThreads.ProgressBar.position + 1;
        end);
    Application.ProcessMessages;
  end;

  fThreads.Memo1.Lines.Add(IntToStr(TThreadProcessamento.CurrentThread.ThreadID)+' - Processamento finalizado');


end;

end.
