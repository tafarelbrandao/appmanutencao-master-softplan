unit ClienteServidor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Datasnap.DBClient, Data.DB,System.zip,System.Threading,
  Data.FMTBcd, Data.SqlExpr ;

type

  TServidor = class
  private
    NArquivo: Integer;
    FPath: AnsiString;

  public
    constructor Create;
    procedure SalvarArquivos(AData: OleVariant);
    procedure SalvarArquivosParalelo(AData: OleVariant);
    procedure ApagarArquivos;
  end;

  TfClienteServidor = class(TForm)
    ProgressBar: TProgressBar;
    btEnviarSemErros: TButton;
    btEnviarComErros: TButton;
    btEnviarParalelo: TButton;
    SQLTable1: TSQLTable;
    procedure FormCreate(Sender: TObject);
    procedure btEnviarSemErrosClick(Sender: TObject);
    procedure btEnviarComErrosClick(Sender: TObject);
    procedure btEnviarParaleloClick(Sender: TObject);
  private
    FPath: AnsiString;
    FServidor: TServidor;
    QtThreadEnvio: Integer;

    function InitDataset: TClientDataset;

  public
  end;

var
  fClienteServidor: TfClienteServidor;

const
  QTD_ARQUIVOS_ENVIAR = 100;

implementation

uses
  IOUtils;

{$R *.dfm}

procedure TfClienteServidor.btEnviarComErrosClick(Sender: TObject);
var
  cds: TClientDataset;
  i: Integer;
begin
  try
    FServidor.ApagarArquivos;

    with ProgressBar do
    begin
      position:=0;
      max:=QTD_ARQUIVOS_ENVIAR;
      visible:=true;
    end;

    cds := InitDataset;
    for i := 0 to QTD_ARQUIVOS_ENVIAR do
    begin
      ProgressBar.position:=i;
      application.ProcessMessages;

      cds.Append;
      TBlobField(cds.FieldByName('Arquivo')).LoadFromFile(String(FPath));
      cds.Post;

      {$REGION Simulação de erro, não alterar}
      if i = (QTD_ARQUIVOS_ENVIAR/2) then
        FServidor.SalvarArquivos(NULL);
      {$ENDREGION}
    end;

    FServidor.SalvarArquivos(cds.Data);
  except
    FServidor.ApagarArquivos;
  end;
end;

procedure TfClienteServidor.btEnviarParaleloClick(Sender: TObject);
begin
  try
    QtThreadEnvio:=0;
    FServidor.ApagarArquivos;
    with ProgressBar do
    begin
      position:=0;
      max:=QTD_ARQUIVOS_ENVIAR-1;
      visible:=true;
    end;

    TTask.Run(
      procedure
      begin
        TParallel.For(0,QTD_ARQUIVOS_ENVIAR-1,
        procedure (Index: Integer)
        begin
          TThread.Queue(TThread.CurrentThread,
          procedure
          var
              cds: TClientDataset;
          begin
            try
              Inc(fClienteServidor.QtThreadEnvio);
              cds := fClienteServidor.InitDataset;

              fClienteServidor.Progressbar.position:=fClienteServidor.ProgressBar.position+1;

              cds.Append;
              TBlobField(cds.FieldByName('Arquivo')).LoadFromFile(String(FPath));
              cds.Post;

              fClienteServidor.Fservidor.SalvarArquivosParalelo(cds.Data);
              cds.EmptyDataSet;
              cds.close;
              cds.free;
            finally
              Dec(fClienteServidor.QtThreadEnvio);
            end;

          end);
        end);
      end);

  finally

  end;
end;

procedure TfClienteServidor.btEnviarSemErrosClick(Sender: TObject);
var
  cds: TClientDataset;
  i: Integer;
begin
  try
    with ProgressBar do
    begin
      position:=0;
      max:=QTD_ARQUIVOS_ENVIAR-1;
      visible:=true;
    end;

    FServidor.ApagarArquivos;

    cds := InitDataset;
    for i := 0 to QTD_ARQUIVOS_ENVIAR - 1 do
    begin
      ProgressBar.position:=i;
      application.ProcessMessages;

      cds.Append;
      TBlobField(cds.FieldByName('Arquivo')).LoadFromFile(String(FPath));
      cds.Post;

      FServidor.SalvarArquivos(cds.Data);
      cds.EmptyDataSet;
    end;

  finally
    with ProgressBar do
    begin
      visible:=false;
      position:=0;
    end;
  end;
end;

procedure TfClienteServidor.FormCreate(Sender: TObject);
begin
  inherited;

  FPath := AnsiString(ExtractFilePath(ParamStr(0)) + 'pdf.pdf');
  FServidor := TServidor.Create;
  QtThreadEnvio:=0;

end;

function TfClienteServidor.InitDataset: TClientDataset;
begin
  Result := TClientDataset.Create(nil);
  Result.FieldDefs.Add('Arquivo', ftBlob);
  Result.CreateDataSet;
end;


{ TServidor }

procedure TServidor.ApagarArquivos;
var
  i: integer;
  sr: TSearchRec;
begin
  try
    i := FindFirst(string(FPath)+'*.*', faAnyFile, sr);
    while i = 0 do
    begin
      DeleteFile(string(FPath)+sr.name);
      i := Findnext(sr);
    end;
  finally
    NArquivo := 0;
  end;



end;

constructor TServidor.Create;
begin
  FPath := AnsiString(ExtractFilePath(string(ParamStr(0))) + 'Servidor\');
end;


procedure TServidor.SalvarArquivos(AData: OleVariant);
var
  cds: TClientDataSet;
  FileName: string;
begin
  try
    if not DirectoryExists(string(FPath)) then
      if not CreateDir(string(FPath)) then
        ForceDirectories(string(FPath));

    cds := TClientDataset.Create(nil);
    cds.Data := AData;


    {$REGION Simulação de erro, não alterar}
    if cds.RecordCount = 0 then
      Exit;
    {$ENDREGION}

    cds.First;

    while not cds.Eof do
    begin
      inc(NArquivo);
      FileName := string(FPath) + inttostr(NArquivo) + '.pdf';
      if TFile.Exists(FileName) then
        TFile.Delete(FileName);

      TBlobField(cds.FieldByName('Arquivo')).SaveToFile(FileName);
      cds.delete;
    end;

    cds.EmptyDataSet;
    cds.close;
    cds.Free;

  except

    raise;
  end;
end;

procedure TServidor.SalvarArquivosParalelo(AData: OleVariant);
var
  cds: TClientDataSet;
  FileName: string;

begin
  try
    if not DirectoryExists(string(FPath)) then
      if not CreateDir(string(FPath)) then
        ForceDirectories(string(FPath));

    TThread.Queue(TThread.CurrentThread,
    procedure
    var
      NArquivoThread:integer;
    begin

      cds := TClientDataset.Create(nil);
      cds.Data := AData;

      NArquivoThread:=NArquivo;
      NArquivo:=NArquivo+cds.recordcount;

      {$REGION Simulação de erro, não alterar}
      if cds.RecordCount = 0 then
        Exit;
      {$ENDREGION}

      cds.First;

      while not cds.Eof do
      begin
        inc(NArquivoThread);
        FileName := String(FPath) + inttostr(NArquivoThread) + '.pdf';
        if TFile.Exists(String(FileName)) then
          TFile.Delete(String(FileName));


        TBlobField(cds.FieldByName('Arquivo')).SaveToFile(FileName);
        cds.delete;
      end;

      cds.EmptyDataSet;
      cds.close;
    end);
  except

    raise;
  end;
end;

end.
