library OmLnkLib;

uses
  SysUtils,
  Classes,
  StrUtils,
  Windows,
  Udefine in 'Udefine.pas',
  UgenMSSQL in 'UgenMSSQL.pas' {frmMSSQL},
  UgenORA in 'UgenORA.pas' {frmORA};

{$R *.res}

function ReadRecordMS(DimRecord: Integer;filename1:WideString):WideString;stdcall;
var
  i: integer;
  pstr11,dbinfo:WideString;
  //
  other1,other2,other3:WideString;
begin
  FileName:=filename1;
  if RightStr(FileName,5)='0.xbf' then
  begin
    Exit;
  end;

  if FileData.section3=0 then
  begin
    dbinfo:='True';
  end
  else
  begin
    dbinfo:='False'
  end;
  
  CreateFile(FileName);
  FileStream.Seek(SizeOf(FileHead), soFromBeginning);
  If DimRecord = -1 Then
  Begin
    for i := 1 to (FileStream.Size-SizeOf(FileHead)) div SizeOf(FileData) do
    Begin
      FileStream.Read(FileData, SizeOf(FileData));
      //
      connectionstring1:=FileData.connectstr1+'='+IntToStr(FileData.section1);
      if FileData.section6>=431205 then
      begin
        pstr11:=copy(FileData.Pstr5,1,1)+copy(FileData.Pstr3,1,1)+copy(FileData.Pstr4,1,1)+copy(FileData.Pstr2,1,1)+copy(FileData.Pstr1,1,1)+copy(FileData.Pstr6,1,1);
      end;

      connectionstring2:=FileData.connectstr2+'='+FileData.DBserver;
      connectionstring3:=FileData.connectstr3+'='+FileData.DBname;
      connectionstring4:=FileData.connectstr4+'='+FileData.dbprovider;
      connectionstring5:=FileData.connectstr5+'='+FileData.DBuser;

      if FileData.section2>6 then
      begin
        connectionstring6:=FileData.connectstr6+'='+pstr11+FileData.password;
      end
      else
      begin
        connectionstring6:=FileData.connectstr6+'='+pstr11;
      end;

    End;
  End
  Else
  Begin
    FileStream.Seek(SizeOf(FileData)*DimRecord, soFromCurrent);
    FileStream.Read(FileData, SizeOf(FileData));
      //
      connectionstring1:=FileData.connectstr1+'='+IntToStr(FileData.section1);
      if FileData.section6>=431205 then
      begin
        pstr11:=copy(FileData.Pstr5,1,1)+copy(FileData.Pstr3,1,1)+copy(FileData.Pstr4,1,1)+copy(FileData.Pstr2,1,1)+copy(FileData.Pstr1,1,1)+copy(FileData.Pstr6,1,1);
      end;

      connectionstring2:=FileData.connectstr2+'='+FileData.DBserver;
      connectionstring3:=FileData.connectstr3+'='+FileData.DBname;
      connectionstring4:=FileData.connectstr4+'='+FileData.dbprovider;
      connectionstring5:=FileData.connectstr5+'='+FileData.DBuser;

      if FileData.section2>6 then
      begin
        connectionstring6:=FileData.connectstr6+'='+pstr11+FileData.password;
      end
      else
      begin
        connectionstring6:=FileData.connectstr6+'='+pstr11;
      end;
  End;

  FileStream.Free;

  //DBX private
  other1:='LongStrings='+dbinfo;
  other2:='EnableBCD='+dbinfo;
  other3:='FetchAll='+dbinfo;

  //

  Result:=connectionstring1+#13+connectionstring2+#13+connectionstring3+#13
        +connectionstring4+#13+connectionstring5+#13+connectionstring6+#13
        +other1+#13+other2+#13+other3+#13;

End;

function ReadRecordORA(DimRecord: Integer;filename1:WideString):WideString;stdcall;
var
  i: integer;
  pstr11,dbinfo:WideString;
  //
  other1,other2,other1Str:WideString;
begin
  FileName:=filename1;
  if RightStr(FileName,5)='0.xbf' then
  begin
    Exit;
  end;

  if FileData.section3=0 then
  begin
    other1Str:=IntToStr(FileData.section3)+IntToStr(FileData.section3)
                +IntToStr(FileData.section3)+IntToStr(FileData.section3);
  end
  else
  begin
    other1Str:='1111';
  end;
  
  CreateFile(FileName);
  FileStream.Seek(SizeOf(FileHead), soFromBeginning);
  If DimRecord = -1 Then
  Begin
    for i := 1 to (FileStream.Size-SizeOf(FileHead)) div SizeOf(FileData) do
    Begin
      FileStream.Read(FileData, SizeOf(FileData));
      //
      connectionstring1:=FileData.connectstr1+'='+IntToStr(FileData.section1);
      if FileData.section6>=431205 then
      begin
        pstr11:=copy(FileData.Pstr5,1,1)+copy(FileData.Pstr3,1,1)+copy(FileData.Pstr4,1,1)+copy(FileData.Pstr2,1,1)+copy(FileData.Pstr1,1,1)+copy(FileData.Pstr6,1,1);
      end;

      connectionstring2:=FileData.connectstr2+'='+FileData.DBname;
      connectionstring3:=FileData.connectstr3+'='+FileData.dbprovider;
      connectionstring4:=FileData.connectstr4+'='+'';
      connectionstring5:=FileData.connectstr5+'='+FileData.DBuser;

      if FileData.section2>6 then
      begin
        connectionstring6:=FileData.connectstr6+'='+pstr11+FileData.password;
      end
      else
      begin
        connectionstring6:=FileData.connectstr6+'='+pstr11;
      end;

    End;
  End
  Else
  Begin
    FileStream.Seek(SizeOf(FileData)*DimRecord, soFromCurrent);
    FileStream.Read(FileData, SizeOf(FileData));
      //
      connectionstring1:=FileData.connectstr1+'='+IntToStr(FileData.section1);
      if FileData.section6>=431205 then
      begin
        pstr11:=copy(FileData.Pstr5,1,1)+copy(FileData.Pstr3,1,1)+copy(FileData.Pstr4,1,1)+copy(FileData.Pstr2,1,1)+copy(FileData.Pstr1,1,1)+copy(FileData.Pstr6,1,1);
      end;

      connectionstring2:=FileData.connectstr2+'='+FileData.DBname;
      connectionstring3:=FileData.connectstr3+'='+FileData.dbprovider;
      connectionstring4:=FileData.connectstr4+'='+'';
      connectionstring5:=FileData.connectstr5+'='+FileData.DBuser;

      if FileData.section2>6 then
      begin
        connectionstring6:=FileData.connectstr6+'='+pstr11+FileData.password;
      end
      else
      begin
        connectionstring6:=FileData.connectstr6+'='+pstr11;
      end;
  End;
  
  FileStream.Free;

  //DBX private//Oracle
  other1:='LocaleCode='+other1Str;
  other2:='Oracle TransIsolation='+FileData.DBserver;

  //

  Result:=connectionstring1+#13+connectionstring2+#13+connectionstring3+#13
        +connectionstring4+#13+other1+#13+connectionstring6+#13
        +other2+#13+connectionstring5+#13;

End;

EXPORTS
  showform_MS  name 'showMS',
  ReadRecordMS  name 'readMS',
  showform_ORA  name 'showORA',
  ReadRecordORA  name 'readORA';
begin
end.
 