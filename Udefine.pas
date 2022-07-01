unit Udefine;

interface

uses
  SysUtils,
  Classes;

Type
  PTFileHead=^TFileHead;
  TFileHead =packed Record
    Version : string[10];
    author:string[10];
    CRC32:longword;
    //在文件头可以添加其他有用的信息
    UpdateDate: TDatetime;
  End;
Type
  PTFileData=^TFileData;
  TFileData =packed Record

    dbprovider:string[30];

    //
    section6:integer;
    connectstr6:string[30];
    section1:integer;
    connectstr1:string[30];
    section3:integer;
    connectstr3:string[30];
    section5:integer;
    connectstr5:string[30];
    section2:integer;
    connectstr2:string[30];
    section4:integer;
    connectstr4:string[30];


    //分解
    Pi1:integer;
    Pstr1:string[2];
    Pi2:integer;
    DBserver:string[20];//data head
    Pstr2:string[2];
    Pi3:integer;
    Pstr3:string[2];

    DBuser : string[10];//data head

    Pi4:integer;
    Pstr4:string[2];
    Pi5:integer;
    DBname:string[30];//data head
    Pstr5:string[2];
    Pi6:integer;
    Pstr6:string[2];
    //把数据头的一些信息移到这儿
    password : string[10];//data head
  End;

Var
    FileStream: TFileStream;
    FileHead: TFileHead;
    FileData: TFileData;
    FileName: WideString;
    FileSize: integer;
    connectionstring1:WideString;
    connectionstring2:WideString;
    connectionstring3:WideString;
    connectionstring4:WideString;
    connectionstring5:WideString;
    connectionstring6:WideString;

implementation

end.
