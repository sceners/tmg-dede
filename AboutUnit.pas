unit AboutUnit;
    
interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, jpeg;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    Version: TLabel;
    Copyright: TLabel;
    Comments: TLabel;
    OKButton: TButton;
    Label6: TLabel;
    lg: TImage;
    Label9: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label7: TLabel;
    Label8: TLabel;
    BuildLbl: TLabel;
    procedure CommentsClick(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation

{$R *.DFM}

uses shellapi;

function Get_Lang_CPg:String;
//var lng_id:LangId; pg_id:UINT;
begin
{lng_id:=GetSystemDefaultLangID;
  pg_id:=GetACP;
  result:=inttohex(lng_id,4)+inttohex(pg_id,4);}
  //041904E3
  Result := '040904E4'; //Fixed during compilation!!!
end;

function GetVersionBuild(InfoName: string = ''):String;

{type _VS_FIXEDFILEINFO = record  // vsffi
      dwSignature          : DWORD;
      dwStrucVersion       : DWORD;
      dwFileVersionMS      : DWORD;
      dwFileVersionLS      : DWORD;
      dwProductVersionMS   : DWORD;
      dwProductVersionLS   : DWORD;
      dwFileFlagsMask      : DWORD;
      dwFileFlags          : DWORD;
      dwFileOS             : DWORD;
      dwFileType           : DWORD;
      dwFileSubtype        : DWORD;
      dwFileDateMS         : DWORD;
      dwFileDateLS         : DWORD;
  end;

Type P_VS_FIXEDFILEINFO = ^ _VS_FIXEDFILEINFO;}

var
  len_info:DWORD;
  tmp:DWORD;
  buffer_info:PCHAR;
  str:pointer;
  fxd : VS_FIXEDFILEINFO;
  len_par:DWORD;
  ps : Integer;
begin
  if InfoName = '' then
    InfoName := 'FileVersion';
  tmp:=0;
  len_info:=GetFileVersionInfoSize(pChar(Application.ExeName),tmp);
  if len_info=0 then
    result:='cant retreive'
  else
   begin
    GetMem(buffer_info,len_info);
    if not GetFileVersionInfo(pChar(Application.ExeName),tmp,len_info,
                              buffer_info) then
      result:='cant retreive'
    else
     begin
      //len_par:=SizeOf(VS_FIXEDFILEINFO);
      //GetMem(fxd,len_par);
      //VerQueryValue(buffer_info,PChar('\'),fxd,len_par);
      //MessageBox(0,PChar(IntToHex(P_VS_FIXEDFILEINFO(fxd)^.dwFileFlags,8)),'',0);
      //FreeMem(fxd);

      len_par:=0;
      if not VerQueryValue(buffer_info,PChar(
        '\StringFileInfo\'+Get_Lang_CPg+'\'+InfoName)
        ,str,len_par)
      then
        result:='cant retreive'
      else begin
        result:=StrPas(PChar(str));
        ps:=Pos('.',result);
        while ps<>0 do
          begin
            result:=Copy(result,ps+1,length(result)-ps);
            ps:=Pos('.',result);
          end;
      end;
     end;
    FreeMem(buffer_info,len_info);
  end;  
end;

procedure TAboutBox.CommentsClick(Sender: TObject);
begin
  ShellExecute(HInstance, 'Open',PChar('mailto:DaFixer@hotmail.com?subject=DeDe'),nil,nil,SW_Normal);
end;

procedure TAboutBox.Label2Click(Sender: TObject);
begin
  ShellExecute(HInstance, 'Open',PChar('www.balbaro.com'),nil,nil,SW_Normal);
end;

procedure TAboutBox.FormActivate(Sender: TObject);
begin
  BuildLbl.Caption:='Build '+GetVersionBuild;
end;

end.

