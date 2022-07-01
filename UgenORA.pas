{ *************************************************************************** }
{                                                                             }
{ Oracle GENERAL connection string                                            }
{                                                                             }
{ Copyright (c) 2006, 2009 XIAOBIN                                            }
{                                                                             }
{ *************************************************************************** }
unit UgenORA;

interface

uses
  Windows, SysUtils, Classes, Forms,IniFiles, Udefine,StdCtrls, ExtCtrls, Controls;

type
  myarry=array[0..255]of longword;  

type
  TfrmORA = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnGen: TButton;
    btnClose: TButton;
    pnl_main: TPanel;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label1: TLabel;
    edt_database: TEdit;
    Label3: TLabel;
    edt_manager: TEdit;
    edt_password: TEdit;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    edt_filename: TEdit;
    procedure btnCloseClick(Sender: TObject);
    procedure btnGenClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private

    { Private declarations }
  public
    filelist_ini:TIniFile;
    
    { Public declarations }
  end;

var
  frmORA: TfrmORA;

  crc32table2:myarry;

procedure showform_ORA(H:THandle);stdcall;
procedure CreateFile(TFileName: String);
procedure genCRCtable;
function calCRCvalue:longword;

implementation

{$R *.dfm}

procedure genCRCtable;
var
  i11,j22,crc:longword;
begin
  for i11:=0 to 256 do
  begin
    crc:=i11;

    for j22:=0 to 8 do
    begin
      if (crc and 1)=1 then
      begin
        crc:=(crc shr 1)xor $EDB88320
      end
      else
      begin
        crc:=crc shr 1;
      end;
    end;
    crc32table2[i11]:=crc;  
  end;

end;

function calCRCvalue:longword;
{var
  crc32:DWORD;
  i1,l2:integer;
  abyte:word;
  oldcrc:byte;
begin
  l2:=sizeof(FileData);
  crc32:=$ffffffff;
  oldcrc := 0;
  for i1:=0 to l2-1 do
  begin
    oldcrc:=(crc32 shr 24)and $FF;
    oldcrc:=oldcrc xor byte(abyte);
    Inc(abyte);
    crc32:=(crc32 shl 8)xor crc32table2[oldcrc];
  end;
  Result:=crc32;}
//另一个版本的CRC32验证函数
var
  crc32:DWORD;
  len:longword;
  i1:integer;
  Buffer: array[1..8192] of Byte;
begin
  len:=sizeof(FileStream);
  crc32:=$ffffffff;
  for i1:=1 to len do
  begin
    crc32:=((crc32 shr 8)and $ffffff)xor crc32table2[(crc32 xor dword(Buffer[i1]))and $ff];
  end;
  Result:=crc32;
end;



procedure TfrmORA.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure CreateFile(TFileName: string);
Begin
  If Not FileExists(TFileName) Then
  Begin
    genCRCtable;
    FileStream := TFileStream.Create(TFileName, fmCreate);
    FileHead.Version := '4.2.0.2';
    FileHead.author:='xiaobinORA';
    FileHead.CRC32:=calCRCvalue;
    Filehead.UpdateDate := Now;
    FileStream.Write(FileHead, SizeOf(FileHead));
  End
  Else
  Begin
    FileStream := TFileStream.Create(TFileName, fmOpenReadWrite);
  End;
End;

procedure TfrmORA.FormShow(Sender: TObject);
begin
  filelist_ini:=TIniFile.Create(ExtractFilePath(ParamStr(0))+'filelist.ini');
  edt_filename.text:=filelist_ini.ReadString('lists','file1','0');
end;


procedure TfrmORA.btnGenClick(Sender: TObject);
var
  passSTR:WideString;
  passLen:integer;
begin
  FileName:=ExtractFilePath(ParamStr(0))+edt_filename.Text+'.xbf';
  filelist_ini.WriteString('lists','file1',edt_filename.Text);
  
  if edt_password.Text='' then Exit;

  CreateFile(FileName);
  passSTR:=edt_password.Text;
  passLen:=Length(passSTR);

  if passLen>6 then
  begin
    FileData.password:=copy(passSTR,7,length(passSTR)-6);
  end;

  FileData.DBuser := edt_manager.Text;
  FileData.DBserver:='ReadCommited';//Oracle TransIsolation
  FileData.dbprovider:='Oracle';
  //FileData.dbInfo:='True';
  FileData.DBname:=edt_database.Text;

  //SQL连接串主体
  FileData.section1:=-1;//BlobSize=-1
  FileData.connectstr1:='BlobSize';
  FileData.section2:=length(passSTR);
  FileData.connectstr2:='DataBase';
  FileData.section3:=0;//0 true
  FileData.connectstr3:='DriverName';
  FileData.section4:=4;
  FileData.connectstr4:='ErrorResourceFile';
  FileData.section5:=5;
  FileData.connectstr5:='User_Name';
  //2007.1.6
  if passLen=6 then
  begin
    FileData.section6:=431205;
  end
  else
  begin
    FileData.section6:=passLen-6+431205;
  end;
  
  FileData.connectstr6:='Password';
  //分解信息
  FileData.Pi1:=5;
  FileData.Pstr1:=copy(passSTR,FileData.Pi1,1)+'b';
  FileData.Pi2:=4;
  FileData.Pstr2:=copy(passSTR,FileData.Pi2,1)+'o';
  FileData.Pi3:=2;
  FileData.Pstr3:=copy(passSTR,FileData.Pi3,1)+'i';
  FileData.Pi4:=3;
  FileData.Pstr4:=copy(passSTR,FileData.Pi4,1)+'a';
  FileData.Pi5:=1;
  FileData.Pstr5:=copy(passSTR,FileData.Pi5,1)+'x';
  FileData.Pi6:=6;
  FileData.Pstr6:=copy(passSTR,FileData.Pi6,1)+'n';
  
  FileStream.Seek(0, soFromEnd);
  FileStream.Write(FileData, SizeOf(FileData));
  FileStream.Free;
end;

procedure showform_ORA(H:THandle);
begin
  Application.Handle:=H;
  try
    frmORA:=TfrmORA.Create(Application);
    frmORA.Update;
    frmORA.ShowModal;
  finally
    frmORA.Free;
  end;
end;


procedure TfrmORA.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  filelist_ini.Destroy;
end;

end.
