unit MainUnit;
//////////////////////////
// Last Change: 09.II.2001
//////////////////////////

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Mask, ToolEdit, StdCtrls, ComCtrls, Animate, GIFCtrl, ExtCtrls, Menus,
  Buttons, RXCtrls, jpeg, RxGrdCpt, ImgList, DeDeClasses, DeDeBSS, DeDe_SDK, DisAsm,
  Placemnt{, ShareMem};

type TFileType = (ftEXE, ftBPL, ftDCU);


Type TPackageInfoTable = class (TObject)
       public
          dwUnitCount : DWORD;
          dwPhysOffs  : DWORD;
          UnitsStartPtrs   : Array of DWORD;
          UnitsInitPtrs   : Array of DWORD;
          UnitsFInitPtrs  : Array of DWORD;
          UnitsNames      : TStringList;
          ClassesList : TList;

          constructor Create;
          destructor Destroy; override;
          procedure SetUnitCount(z : DWORD);
          procedure IdentUnitNames(Sender : TObject);
        end;

Type TClassDumper = Class
       protected
        IsInDataSection : Boolean;
        Procedure CalculatePositions;
        Procedure DumpFields;
        Function GetDFMOffset(AsClassName : String) : DWORD;
        Function InCodeSection(RVA : DWORD) : Boolean;
        Function InDataSection(RVA : DWORD) : Boolean;
        Function IsInData(RVA : DWORD) : Boolean;
       public
        //PEHeader : TPEHeader;
        DELTA_PHYS : DWORD;
        FdwBSSOffset, FdwHeapPtr, FdwDATAPrt : TList;
        FdwSelfPrt, FdwSelfPrtPos : DWORD;
        FsClassName : String;
        FsUnitName : String;
        FbClassFlag : Byte;
        FdwVMTPtr, FdwVMTPos : DWORD;
        FdwVMTPtr2 : DWORD;
        FdwInterfaceTlbPtr : DWORD;
        FdwAutomationTlbPtr : DWORD;
        FdwInitializationTlbPtr : DWORD;
        FdwInformationTlbPtr : DWORD;
        FdwFieldDefTlbPtr : DWORD;
        FdwMethodDefTlbPtr : DWORD;
        FdwDynMethodsTlbPtr : DWORD;
        FdwInterfaceTlbPos : DWORD;
        FdwAutomationTlbPos : DWORD;
        FdwInitializationTlbPos : DWORD;
        FdwInformationTlbPos : DWORD;
        FdwFieldDefTlbPos : DWORD;
        FdwMethodDefTlbPos : DWORD;
        FdwDynMethodsTlbPos : DWORD;
        FdwClassNamePos : DWORD;
        FdwClassNamePtr : DWORD;
        FdwClassSize : DWORD;
        FdwAncestorPtrPtr : DWORD;
        FdwSafecallExceptionMethodPtr : DWORD;
        FdwDefaultHandlerMethodPtr : DWORD;
        FdwNewInstanceMethodPtr : DWORD;
        FdwFreeInstanceMethodPtr : DWORD;
        FdwDestroyDestructorPtr : DWORD;
        FieldData : TFieldData;
        MethodData : TMethodData;
        FdwDFMOffset : DWORD;
        FdwFirstProcRVA : DWORD;
        Constructor Create;
        Destructor Destroy; override;
        Procedure Dump(dwSelfPtrPos : DWORD);
        Procedure DumpObject(dwSelfPtrPos : DWORD);
        Procedure DumpObjectEx(dwSelfPtrPos: DWORD; btType : Byte);
        Procedure DumpMethods(dwEndRVA : DWORD; bDumpAdditional : Boolean  = False);
        Function GetMethodRVA(sMethName : String) : DWORD;
        Function IsBSSDATAClass(Index : Integer) : Boolean;
     End;

Type TClassesDumper = Class
      protected
        DFMTXTDATA_Names : Array of String;
        DFMTXTDATA : TList;
        FiZeroCount : Integer;
        Procedure AddClass(dwSelfPtrPos : DWORD);
        Procedure AddClass_D2(dwSelfPtrPos : DWORD);
        Procedure AddObject(dwSelfPtrPos : DWORD);
        Procedure AddObjectEx(dwSelfPtrPos: DWORD; btType : Byte);
        function ClassExists(sClassName : string) : Boolean;
        function GetClassByName(sClassName : String) : TClassDumper;
        procedure EnumDFMOffsets;
        procedure LoadDFMTXTDATA;
      public
        Classes : TList;
        DFMOffsets : TStringList;
        BSS : TBSS;
        PackageInfoTable : TPackageInfoTable;
        Constructor Create;
        Destructor Destroy; override;
        Procedure ClearClasses;
        Procedure ClearDFMTXTDATA;
        Procedure Dump;
        Procedure FinilizeDump;
        Function GetDFMTXTDATA(sClassName : String) : TStringList;
        Function GetClass(sClassName : String) : TClassDumper;
        Function GetClassWMethods(sClassName : String) : TClassDumper;
        Function GetClassWFields(sClassName: String): TClassDumper;
        Procedure GetBufferForDPJSave(var buff : Array of byte; var size : Integer);
     End;

type
  TDeDeMainForm = class(TForm)
    Pnl: TPanel;
    StsBar: TStatusBar;
    DFMListPopUp: TPopupMenu;
    puViewastext: TMenuItem;
    puSep: TMenuItem;
    puSaveasDFM: TMenuItem;
    puSaveasRC: TMenuItem;
    tppnl: TPanel;
    FileEdit: TFilenameEdit;
    DumpStatusLbl: TLabel;
    ProjectNameLbl: TLabel;
    DumpAnimation: TRxGIFAnimator;
    rvapu: TPopupMenu;
    puCopyRVAtoclipboard: TMenuItem;
    puSaveasTXT: TMenuItem;
    svrvspu: TPopupMenu;
    puSaveeventsRVAsastext: TMenuItem;
    mpc: TPageControl;
    uts: TTabSheet;
    fmts: TTabSheet;
    DFMList: TListView;
    DFMMemo: TMemo;
    dts: TTabSheet;
    DCULV: TListView;
    dcupnl: TPanel;
    clspnl: TPanel;
    ClassLbl: TLabel;
    fts: TTabSheet;
    N1: TMenuItem;
    Showmoredata1: TMenuItem;
    Panel1: TPanel;
    CustomPB: TProgressBar;
    N4: TMenuItem;
    Disassemble1: TMenuItem;
    DeDeOpenDlg: TOpenDialog;
    SaveDlg: TSaveDialog;
    PageControl2: TPageControl;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    EventLV: TListView;
    ControlsLV: TListView;
    FE: TEdit;
    RecentFileEdit: TComboBox;
    RxGradientCaption1: TRxGradientCaption;
    ImageList1: TImageList;
    MMenu: TMainMenu;
    File1: TMenuItem;
    Process1: TMenuItem;
    N3: TMenuItem;
    Exit1: TMenuItem;
    Tools1: TMenuItem;
    RVAconverter1: TMenuItem;
    ASM1: TMenuItem;
    View1: TMenuItem;
    Preferences1: TMenuItem;
    About1: TMenuItem;
    OpenDlg: TOpenDialog;
    Dumpers1: TMenuItem;
    BPLDumper2: TMenuItem;
    DCUDumper2: TMenuItem;
    MorePEInfo1: TMenuItem;
    N5: TMenuItem;
    Symbols1: TMenuItem;
    LoadSymbolFile1: TMenuItem;
    N8: TMenuItem;
    ClearTimer: TTimer;
    OpenSymDlg: TOpenDialog;
    cbDFM: TCheckBox;
    cbPAS: TCheckBox;
    cbDPR: TCheckBox;
    cbTXT: TCheckBox;
    crtBtn: TButton;
    DirEdit: TDirectoryEdit;
    Label1: TLabel;
    SavePB: TProgressBar;
    ClassesLV: TListView;
    PrcsBtn: TButton;
    ImageList2: TImageList;
    Label2: TLabel;
    DAP: TMenuItem;
    TabSheet1: TTabSheet;
    Label3: TLabel;
    EPB: TProgressBar;
    Button1: TButton;
    Label4: TLabel;
    ExportFileName: TFilenameEdit;
    IDAMAP: TRadioButton;
    RVACB: TCheckBox;
    ControlCB: TCheckBox;
    REF: TRadioButton;
    MakePEHeader1: TMenuItem;
    SpeedButton2: TSpeedButton;
    SpeedButton1: TSpeedButton;
    AllCallsCB: TCheckBox;
    AllStrCB: TCheckBox;
    ExportDetailsLbl: TLabel;
    CustomCB: TCheckBox;
    N6: TMenuItem;
    N7: TMenuItem;
    DSFSpy1: TMenuItem;
    Panel3: TPanel;
    Panel2: TPanel;
    VersionLbl: TLabel;
    Panel4: TPanel;
    Panel5: TPanel;
    PIUL: TListBox;
    Label5: TLabel;
    N9: TMenuItem;
    Analizethisclass1: TMenuItem;
    DeleteTimer: TTimer;
    De1: TMenuItem;
    N2: TMenuItem;
    SaveProjectFile1: TMenuItem;
    LoadProjectFile1: TMenuItem;
    SaveProjectFileAs1: TMenuItem;
    TabSheet2: TTabSheet;
    UnitsDataClassesLV: TListView;
    UnitDataLV: TListView;
    publh: TPopupMenu;
    Saveunitdataasbinaryfile1: TMenuItem;
    N10: TMenuItem;
    Fullparse1: TMenuItem;
    DoItTimer: TTimer;
    DeDeProjectSaveDialog: TSaveDialog;
    DeDeProjectOpenDialog: TOpenDialog;
    OpenDOIDlg: TOpenDialog;
    LanguagesMI: TMenuItem;
    ENGLISH1: TMenuItem;
    currUnitLbll: TLabel;
    FP: TFormPlacement;
    Procedure DCULVClick(Sender: TObject);
    Procedure PreBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DCULVDblClick(Sender: TObject);
    procedure puCopyRVAtoclipboardClick(Sender: TObject);
    procedure puSaveasDFMClick(Sender: TObject);
    procedure puSaveasRCClick(Sender: TObject);
    procedure puOpenwithnotepadClick(Sender: TObject);
    procedure puViewastextClick(Sender: TObject);
    procedure puSaveasTXTClick(Sender: TObject);
    procedure DFMListChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure Showmoredata1Click(Sender: TObject);
    procedure crtBtnClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure RVAconverter1Click(Sender: TObject);
    procedure puSaveeventsRVAsastextClick(Sender: TObject);
    procedure ASM1Click(Sender: TObject);
    procedure MorePEinfo1Click(Sender: TObject);
    procedure Disassemble1Click(Sender: TObject);
    procedure DisassembleProc1Click(Sender: TObject);
    procedure Preferences1Click(Sender: TObject);
    procedure PrcsBtnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure APIHooker1Click(Sender: TObject);
    procedure SaveProject1Click(Sender: TObject);
    procedure BPLDumper1Click(Sender: TObject);
    procedure RecentFileEditChange(Sender: TObject);
    procedure FileEditChange(Sender: TObject);
    procedure DirEditBeforeDialog(Sender: TObject; var Name: String;
      var Action: Boolean);
    procedure SaveDlgShow(Sender: TObject);
    procedure DeDeOpenDlgShow(Sender: TObject);
    procedure DCUDumper1Click(Sender: TObject);
    procedure DFMListEnter(Sender: TObject);
    procedure ClearTimerTimer(Sender: TObject);
    procedure DCULVEnter(Sender: TObject);
    procedure ControlsLVEnter(Sender: TObject);
    procedure DCULVExit(Sender: TObject);
    procedure DFMListExit(Sender: TObject);
    procedure LoadSymbolFile1Click(Sender: TObject);
    procedure Symbols1Click(Sender: TObject);
    procedure ClassesLVDblClick(Sender: TObject);
    procedure Panel2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure DPR1Click(Sender: TObject);
    procedure DAPClick(Sender: TObject);
    procedure DFMListColumnClick(Sender: TObject; Column: TListColumn);
    procedure DFMListCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure IDAMAPClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ExportFileNameBeforeDialog(Sender: TObject; var Name: String;
      var Action: Boolean);
    procedure FEChange(Sender: TObject);
    procedure MakePEHeader1Click(Sender: TObject);
    procedure doibClick(Sender: TObject);
    procedure PIULDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ExportFileNameAfterDialog(Sender: TObject; var Name: String;
      var Action: Boolean);
    procedure CustomCBClick(Sender: TObject);
    procedure DSFSpy1Click(Sender: TObject);
    procedure DCULVChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure crtBtnMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Analizethisclass1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure DeleteTimerTimer(Sender: TObject);
    procedure De1Click(Sender: TObject);
    procedure UnitDataLVChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure Saveunitdataasbinaryfile1Click(Sender: TObject);
    procedure DoItTimerTimer(Sender: TObject);
    procedure SaveProjectFile1Click(Sender: TObject);
    procedure LoadProjectFile1Click(Sender: TObject);
    procedure SaveProjectFileAs1Click(Sender: TObject);
    procedure ChangeLanguage(Sender: TObject);
    procedure FEKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FbSavedProject : Boolean;
    FbHiddenStuff, FbLoadDFMInMemo : Boolean;
    StandartDCUList : TStringList;
    function IdentCompiler(var AsOffset: String): String;
    procedure ClearDeDeLists;
    procedure FreeOpCodes;
    function GetLVFromClassName : String;
    procedure SaveEventHanlderDataInFile(FsFileName : String);
    procedure AssignDeDeDisAsms;
    {procedure ShowAPISPY; TO BE USED IN FUTURE !!!}
    Procedure FreeSymbolList;
    Procedure FreePlugIns;
    Procedure LoadDeDeRES;
    procedure CompileToSymAndLoadInSice(sMAPFilePath, sSicePath : String);
    procedure LoadLangMenuItems;
  public
    { Public declarations }
    sDelphiVersion : String;
    FsVersionHash : String;
    DFMFormList, UnitList : TStringlist;
    DFMNameList, PASNameList, CurrControlList,
    CurrNames, CurrIDs, SymbolsPath : TStringList;
    PEFile : ThePEFile;
    FbMemFump : Boolean;
//    FOpCodeList, FControlList : TList;
    FbProcessed, FbFailed, FbCutSelfPtr : Boolean;
    FFileType : TFileType;
    FsFileName : String;
    FsProjectName : String;
    DeDeProjectFileName : String;
    SymbolsList : TList;
    LoadedDOIList : TStringList;
    SymbolsToLoad : TStringList;
    ClassesDumper : TClassesDumper;
//    PEHeader : TPEHeader;
    FsLoadedDOIFile : String;
    ClassInfoList : TStringList;
    bShowLicense : Boolean;
    procedure DumpDFMNames;
    function IsDelphiApp : Boolean;
    //procedure ShowPEData;
    procedure PrepareProject(ssFN : String);
    Procedure CheckFolders;
    Procedure AppHint(AsHint : String);
    Procedure UnloadDSFSymbol(i : Integer);
    Procedure LoadSymbolFiles;
    Procedure LoadOffsetInfo;
    Procedure LoadDSFForDelphiTargetVersion;
    Procedure SetExitCtrls(bEnabled : Boolean);
    function PrepareDFM : TMemoryStream;
    function PrepareDFMByIndex(AiIndex : Integer; bIncludeDFMHeader : Boolean = True) : TMemoryStream;
    function ClassRefInCode(Offs : DWORD; var s : String) : Boolean;
    Procedure NewTimerTimer(Sender : TObject);
  end;

var
  DeDeMainForm: TDeDeMainForm;
  DelphiVestionCompability : Byte;
  //mPEHeader : TPEHeader;

  PlugIn_DASM : TDisAsm;
  bPlugInsFixRelative : Boolean;
  DebugLogList : TStringList;

Procedure PlugIn_AddressRefProc(Param: Pointer; ValueAddress, RefAddress: PChar; var Result: string);
procedure DebugLog(sMessage : String);

//////////////////////////////////////////////////////
//// PLUGINS INTERFACE ///////////////////////////////
////
//////////////////////////////////////////////////////

function GetByte(dwVirtOffset : DWORD) : Byte;
function GetWord(dwVirtOffset : DWORD) : Word;
function GetDWORD(dwVirtOffset : DWORD) : DWORD;
function GetPascalString(dwVirtOffset : DWORD) : String;
procedure GetBinaryData(var buffer : Array of Byte; size : Integer; dwVirtOffset : DWORD);

Function Disassemble(dwVirtOffset : DWORD; var sInstr : String; var size : Integer) : Boolean;

Function GetCallReference(dwVirtOffset : DWORD; var sReference : String; var btRefType : Byte; btMode : Byte = 0) : Boolean;
Function GetObjectName(dwVirtOffset : DWORD; var sObjName : String) : Boolean;
Function GetFieldReference(dwVirtOffset : DWORD; var sReference : String) : Boolean;

const MAX_LOADED_PLUGINS = 16;

Function GetDeDe_FunctionsList : TFunctionPointerListArray;
Function LoadPlugInsFromDLL(ADllName : String) : Boolean;
procedure UnloadPluginDll(idx : integer);

Type TPlugInData = record
                     Handle : HMODULE;  // [ LC ]
                     DLL_NAME : String;
                     InternalIndex : Integer;
                     StartPlugInProc : TStartPlugInProc;
                     PlugInType : TPlugFlags;
                     sPlugInName : String;
                     sPlugInVersion : String;
                   end;

var DeDePlugins_PluginsArray : Array [1..MAX_LOADED_PLUGINS] of TPlugInData;
    DeDePlugins_Count : Byte = 0;
    GlobClassesCount : Integer;

//////////////////////////////////////////////////////

implementation

{$R *.DFM}

Uses DeDeConstants, HEXTools, DeDePAS, FMXUtils, Clipbrd,
  AboutUnit, ConverterUnit, ASMConvertUnit, ShowPEUnit, DeDeDisAsm, ASMShow,
  PreferencesUnit, DeDeReg, {ASMainUnit,} {DeDe_Projects,} BPLUnit, DCUUnit, DeDeSym,
  SymbolsUnit, ClassInfoUnit, DeDeHidden, SelProcessUnit, DeDeMemDumps,
  MakePEHUnit, DeDeClassEmulator, DOIBUnit, DeDeWpjAlf, custsetunit,
  SpyDebugUnit, DeDeRes, AnalizUnit, DeDeOffsInf, StatsUnit, IniFiles,
  DeDeDPJEng, Asm2Pas, DeDeELFClasses, DeDeZAUnit, Registry, LAUnit;


var TmpArr : Array of String;

function ExtractFileNameWOext( const Path : String ) : String;
begin
  Result := ExtractFileName( Path );
  Result := Copy( Result, 1, Length( Result ) - Length( ExtractFileExt( Result ) ) );
end;

function IsInCodeSection(RVA: DWORD): Boolean;
var idx : Integer;
    DELTA_PHYS : DWORD;
begin
  idx:=PEHeader.GetSectionIndexEx('CODE');
  DELTA_PHYS:=  PEHeader.IMAGE_BASE
               +PEHeader.Objects[idx].RVA
               -PEHeader.Objects[idx].PHYSICAL_OFFSET;
  Result:=((RVA-DELTA_PHYS)>=PEHeader.Objects[idx].PHYSICAL_OFFSET)
      and ((RVA-DELTA_PHYS)<=PEHeader.Objects[idx].PHYSICAL_OFFSET+PEHeader.Objects[idx].PHYSICAL_SIZE)
end;


{ TPackageInfoTable }

constructor TPackageInfoTable.Create;
begin
  Inherited Create;

  UnitsNames:=TStringList.Create;
  ClassesList:=TList.Create;
end;


destructor TPackageInfoTable.Destroy;
var i : Integer;
begin
  For i:=ClassesList.Count-1 downto 0  do TStringList(ClassesList[i]).Free;
  ClassesList.Free;
  UnitsNames.Free;

  Inherited Destroy;
end;

procedure TPackageInfoTable.IdentUnitNames(Sender: TObject);
var Dumper : TClassesDumper;
    ClassDmp,ClassDmp1  : TClassDumper;
    i, j, k : Integer;
    bFound : Boolean;
begin
  Dumper:=TClassesDumper(Sender);

  ////////////////////////////////////////////////
  // Enorder Units Data
  ////////////////////////////////////////////////
  Repeat
    k:=0; j:=0;
    Repeat
      if UnitsFInitPtrs[j]>UnitsFInitPtrs[j+1] then
         begin
           i:=UnitsInitPtrs[j];
           UnitsInitPtrs[j]:=UnitsInitPtrs[j+1];
           UnitsInitPtrs[j+1]:=i;
           i:=UnitsFInitPtrs[j];
           UnitsFInitPtrs[j]:=UnitsFInitPtrs[j+1];
           UnitsFInitPtrs[j+1]:=i;
           Inc(k);
         end;
       Inc(j)
     Until j>dwUnitCount-2;
  Until k=0;

  // The last unit is the project itself. The initialization pointer
  // is the program entry point and finalization is normaly null
  //
  // It is important to have repeat..until loop because the order is mportant
  j:=0;
  Repeat
    UnitsStartPtrs[j+1]:=GetNextProcRVA(UnitsInitPtrs[j],bFound,False);
    UnitsNames[j+1]:='Unit_'+DWORD2HEX(UnitsStartPtrs[j+1]);
    Inc(j);
  Until j>=dwUnitCount-1;

  // The first unit is ALWAYS system.dcu and ALWAYS starts
  // at the beginning of CODE section
  UnitsStartPtrs[0]:=PEHeader.BaseOfCode+PEHeader.IMAGE_BASE;
  UnitsNames[0]:='System';

  // The second unit is ALWAYS sysinit.pas
  UnitsNames[1]:='SysInit';

  // The last unit is ALWAYS the project
  UnitsNames[dwUnitCount-1]:=DeDeMainForm.ProjectNameLbl.Caption;

  ///////////////////////////////////////////////////
  // The same about Classes data
  ///////////////////////////////////////////////////
  Repeat
    k:=0;
    For j:=0 to dwUnitCount-2 do
     begin
      if j+1>=Dumper.Classes.Count then break;
      ClassDmp:=TClassDumper(Dumper.Classes[j]);
      ClassDmp1:=TClassDumper(Dumper.Classes[j+1]);
      if ClassDmp.FdwSelfPrt>ClassDmp1.FdwSelfPrt then
         begin
           Dumper.Classes.Exchange(j,j+1);
         end;
     end;
  Until k=0;


  ///////////////////////////////////////////////////////////////
  // Do the recognition
  ///////////////////////////////////////////////////////////////
  // Loop among all the units
  For i:=0 to Dumper.Classes.Count-1 do
    begin
      ClassDmp:=TClassDumper(Dumper.Classes[i]);

      For j:=0 to dwUnitCount-2 do
        if    (ClassDmp.FdwSelfPrt>UnitsStartPtrs[j])
          and (ClassDmp.FdwSelfPrt<UnitsStartPtrs[j+1])
          then begin
            TStringList(ClassesList[j]).Add(ClassDmp.FsClassName);
            if ClassDmp.FsUnitName<>'' then UnitsNames[j]:=ClassDmp.FsUnitName;
          end;
    end;
end;

procedure TPackageInfoTable.SetUnitCount(z: DWORD);
var i : Integer;
begin
  dwUnitCount:=z;
  SetLength(UnitsInitPtrs,z);
  SetLength(UnitsFInitPtrs,z);
  SetLength(UnitsStartPtrs,z);
  UnitsNames.Clear;
  For i:=1 to dwUnitCount do
    begin
      UnitsNames.Add('');
      ClassesList.Add(TStringList.Create);
    end;
end;

{ TClassDumper }

procedure TClassDumper.CalculatePositions;
begin
   If FdwInterfaceTlbPtr<>0 Then
      FdwInterfaceTlbPos:=FdwInterfaceTlbPtr-DELTA_PHYS;
   If FdwAutomationTlbPtr<>0 Then
    FdwAutomationTlbPos:=FdwAutomationTlbPtr-DELTA_PHYS;
   If FdwInitializationTlbPtr<>0 Then
    FdwInitializationTlbPos:=FdwInitializationTlbPtr-DELTA_PHYS;
   If FdwInformationTlbPtr<>0 Then
    FdwInformationTlbPos:=FdwInformationTlbPtr-DELTA_PHYS;
   If FdwFieldDefTlbPtr<>0 Then
    FdwFieldDefTlbPos:=FdwFieldDefTlbPtr-DELTA_PHYS;
   If FdwMethodDefTlbPtr<>0 Then
    FdwMethodDefTlbPos:=FdwMethodDefTlbPtr-DELTA_PHYS;
   If FdwDynMethodsTlbPtr<>0 Then
    FdwDynMethodsTlbPos:=FdwDynMethodsTlbPtr-DELTA_PHYS;
   If FdwClassNamePtr<>0 Then
    FdwClassNamePos:=FdwClassNamePtr-DELTA_PHYS;
end;

constructor TClassDumper.Create;
begin
  Inherited Create;

  FieldData:=TFieldData.Create;
  MethodData:=TMethodData.Create;

  FdwBSSOffset:=TList.Create;
  FdwBSSOffset.Add(nil);
  FdwHeapPtr:=TList.Create;
  FdwHeapPtr.Add(nil);
  FdwDATAPrt:=TList.Create;
  FdwDATAPrt.Add(nil);
end;

destructor TClassDumper.Destroy;
begin
  FieldData.Free;
  MethodData.Free;
  FdwBSSOffset.Free;
  FdwHeapPtr.Free;
  FdwDATAPrt.Free;

  Inherited Destroy;
end;

procedure TClassDumper.Dump(dwSelfPtrPos: DWORD);
var b  : Byte;
    dw : DWORD;
    w : Word;
    DELTA_TBL : Byte;
begin
  FdwSelfPrtPos:=dwSelfPtrPos;

  {BOZA DeDeClasses.}PEStream.Seek(dwSelfPtrPos,soFromBeginning);

  // Reads SelfPtr
  {BOZA DeDeClasses.}PEStream.ReadBuffer(FdwSelfPrt,4);

  // No selfpointers in Delphi 2
  If GlobDelphi2 then FdwSelfPrt:=0;

  // Reads ClassFlag
  {BOZA DeDeClasses.}PEStream.ReadBuffer(FbClassFlag,1);

  If FbClassFlag<16 Then
   Begin
    // Reads ClassName length
    {BOZA DeDeClasses.}PEStream.ReadBuffer(b,1);
    SetLength(FsClassName,b);

    // Reads ClassName
    {BOZA DeDeClasses.}PEStream.ReadBuffer(FsClassName[1],b);
   End;

  // Reads VMT RVA
  {BOZA DeDeClasses.}PEStream.ReadBuffer(FdwVMTPtr,4);
  IsInDataSection:=IsInData(FdwVMTPtr);

  {BOZA DeDeClasses.}PEStream.ReadBuffer(dw,4);

  // Reads Flag
  {BOZA DeDeClasses.}PEStream.ReadBuffer(w,2);

  ///////////////////////////////////////////
  // Support for other units and classes
  // 7 should be a class that has DFM resources
  if FbClassFlag<>7 Then Exit;
  ///////////////////////////////////////////

  // Reads UnitName length
  {BOZA DeDeClasses.}PEStream.ReadBuffer(b,1);
  SetLength(FsUnitName,b);

  // Reads UnitName
  {BOZA DeDeClasses.}PEStream.ReadBuffer(FsUnitName[1],b);

  // Additive constant to RVA-Phys conversion for CODE section
  if IsInDataSection then
      DELTA_PHYS:=  PEHeader.IMAGE_BASE
                   +PEHeader.Objects[2].RVA
                   -PEHeader.Objects[2].PHYSICAL_OFFSET
  else
      DELTA_PHYS:=  PEHeader.IMAGE_BASE
                   +PEHeader.Objects[1].RVA
                   -PEHeader.Objects[1].PHYSICAL_OFFSET;

  // Gets The First Procedure RVA
  Repeat
    {BOZA DeDeClasses.}PEStream.ReadBuffer(b,1)
  Until not (b in [$00,$90,$8D,$40,$8B,$C0]);
  FdwFirstProcRVA:={BOZA DeDeClasses.}PEStream.Position+DELTA_PHYS;

  // Calculates VMT Position in executable
  FdwVMTPos:=FdwVMTPtr-DELTA_PHYS;

  // Moves to the beginning of the Class VMT
  DELTA_TBL:=76;
  If DelphiVersion='D3' Then DELTA_TBL:=64;
  If DelphiVersion='D2' Then DELTA_TBL:=44; {Offset to FielsDefTblPrtPos-4}
  {BOZA DeDeClasses.}PEStream.Seek(FdwVMTPos-DELTA_TBL,soFromBeginning);

  // Reads ClassInformation Data
  {BOZA DeDeClasses.}PEStream.ReadBuffer(FdwVMTPtr2,4);
  if GlobCBuilder or GlobDelphi2 then FdwVMTPtr2:=FdwVMTPtr;
  If FdwVMTPtr<>FdwVMTPtr2 Then Exit;

  if not GlobDelphi2 then
    begin
      {BOZA DeDeClasses.}PEStream.ReadBuffer(FdwInterfaceTlbPtr,4);
      {BOZA DeDeClasses.}PEStream.ReadBuffer(FdwAutomationTlbPtr,4);
      {BOZA DeDeClasses.}PEStream.ReadBuffer(FdwInitializationTlbPtr,4);
      {BOZA DeDeClasses.}PEStream.ReadBuffer(FdwInformationTlbPtr,4);
    end;

  {BOZA DeDeClasses.}PEStream.ReadBuffer(FdwFieldDefTlbPtr,4);
  {BOZA DeDeClasses.}PEStream.ReadBuffer(FdwMethodDefTlbPtr,4);

  if not GlobDelphi2 then
      {BOZA DeDeClasses.}PEStream.ReadBuffer(FdwDynMethodsTlbPtr,4);

  {BOZA DeDeClasses.}PEStream.ReadBuffer(FdwClassNamePtr,4);
  {BOZA DeDeClasses.}PEStream.ReadBuffer(FdwClassSize,4);
  {BOZA DeDeClasses.}PEStream.ReadBuffer(FdwAncestorPtrPtr,4);
  {BOZA DeDeClasses.}PEStream.ReadBuffer(FdwSafecallExceptionMethodPtr,4);
  {BOZA DeDeClasses.}PEStream.ReadBuffer(FdwDefaultHandlerMethodPtr,4);
  {BOZA DeDeClasses.}PEStream.ReadBuffer(FdwNewInstanceMethodPtr,4);
  {BOZA DeDeClasses.}PEStream.ReadBuffer(FdwFreeInstanceMethodPtr,4);
  {BOZA DeDeClasses.}PEStream.ReadBuffer(FdwDestroyDestructorPtr,4);


  CalculatePositions;
  DumpFields;
  // Get DFM Offsets
  If DeDeMainForm.DFMFormList.IndexOf(FsClassName)<>-1
     Then FdwDFMOffset:=GetDFMOffset(FsClassName);

  // This should be called after all classes has been dumped
  // DumpMethods;
end;


procedure TClassDumper.DumpFields;
var  dw,i : DWORD;
     b : Byte;
     sName : String;
     w : Word;
begin
  If FdwFieldDefTlbPtr=0 Then Exit;
  If Not bELF then
  if Not IsInDataSection
     Then Begin If Not InCodeSection(FdwFieldDefTlbPtr) Then Exit End
     Else If Not InDataSection(FdwFieldDefTlbPtr) Then Exit;
     
  Try
  {BOZA DeDeClasses.}PEStream.Seek(FdwFieldDefTlbPos,soFromBeginning);
  {BOZA DeDeClasses.}PEStream.ReadBuffer(FieldData.Count,2);
  //If FieldData.Count>100 Then Exit;
  {BOZA DeDeClasses.}PEStream.ReadBuffer(FieldData.Ptr,4);

    For i:=0 To FieldData.Count-1 Do
      Begin
       {BOZA DeDeClasses.}PEStream.ReadBuffer(dw,4);
       {BOZA DeDeClasses.}PEStream.ReadBuffer(w,2);
       {BOZA DeDeClasses.}PEStream.ReadBuffer(b,1);
       SetLength(sName,b);
       {BOZA DeDeClasses.}PEStream.ReadBuffer(sName[1],b);
       FieldData.AddField(sName, dw, w);
    End;
  Except
    ShowMessageFmt(err_classdump,[FsClassName,FdwFieldDefTlbPos]);
  End;
end;

procedure TClassDumper.DumpMethods(dwEndRVA : DWORD; bDumpAdditional : Boolean = False);
var  dw,i, MinRVA, MaxRVA, dwLastPublishedMeth : DWORD;
     b : Byte;
     sName : String;
     w : Word;
     idx : Integer;
     bFound : Boolean;
     BegArr, EndArr : Array of DWORD;
begin
  //Get DFM Offset
  //ClassDumper.

  if not bDumpAdditional then
    begin
        If FdwMethodDefTlbPtr=0 Then Exit;
        If Not bELF then
        If Not IsInDataSection
           Then Begin If Not InCodeSection(FdwMethodDefTlbPtr) Then Exit End
           Else If Not InDataSection(FdwMethodDefTlbPtr) Then Exit;

        {BOZA DeDeClasses.}PEStream.Seek(FdwMethodDefTlbPos,soFromBeginning);
        {BOZA DeDeClasses.}PEStream.ReadBuffer(MethodData.Count,2);

        For i:=1 To MethodData.Count Do
         Begin
            {BOZA DeDeClasses.}PEStream.ReadBuffer(w,2);
            {BOZA DeDeClasses.}PEStream.ReadBuffer(dw,4);
            {BOZA DeDeClasses.}PEStream.ReadBuffer(b,1);
            SetLength(sName,b);
            {BOZA DeDeClasses.}PEStream.ReadBuffer(sName[1],b);
            ProcRefOffsets.Add(IntToHex(dw,8));
            ProcRefNames.Add(FsClassName+'.'+sName);
            MethodData.AddMethod(sName, dw, w);
         End;

        {BOZA DeDeClasses.}PEStream.Seek(FdwVMTPos,soFromBeginning);
        Repeat
            {BOZA DeDeClasses.}PEStream.ReadBuffer(dw,4);
            If MethodData.MethodIndexByRVA(dw)=-1
              Then Begin
                ProcRefOffsets.Add(IntToHex(dw,8));
                If not InCodeSection(dw) then break;
                ProcRefNames.Add('virt proc '+FsUnitName+'.VIRT_PROC_'+IntToHex(dw,8));
              End;
        Until {BOZA DeDeClasses.}PEStream.Position>=FdwFieldDefTlbPos;

        // Only The 'Good' Classes should continue down
        If FieldData.Count=0 Then Exit;
        If FdwDFMOffset=0 Then Exit;
        If not bUserProcs Then Exit;
     end
     else begin
        // Gets User Defines Procedures
        DeDeDisASM.PEStream:={BOZA DeDeClasses.}PEStream;
        //DeDeDisASM.PEHeader:=DeDeClasses.PEHEader;
        DeDeDisASM.RVAConverter.ImageBase:=DeDeClasses.PEHEader.IMAGE_BASE;
        DeDeDisASM.RVAConverter.CodeRVA:=DeDeClasses.PEHEader.Objects[1].RVA;
        DeDeDisASM.RVAConverter.PhysOffset:=DeDeClasses.PEHEader.Objects[1].PHYSICAL_OFFSET;

        //Find last published method RVA
        dwLastPublishedMeth:=0;
        for idx:=0 to MethodData.Methods.Count-1 do
          if dwLastPublishedMeth<TMethodRec(MethodData.Methods[idx]).dwRVA
             then dwLastPublishedMeth:=TMethodRec(MethodData.Methods[idx]).dwRVA;

        //Prepare Begin and End rva arrays for knows published methods
        SetLength(BegArr,MethodData.Methods.Count);
        SetLength(EndArr,MethodData.Methods.Count);
        for idx:=0 to MethodData.Methods.Count-1 do
          begin
            dw:=TMethodRec(MethodData.Methods[idx]).dwRVA;
            BegArr[idx]:=dw;
            dw:=DeDeDisASM.GetNextProcRVA(dw, bFound, False);
            EndArr[idx]:=dw;
          end;

        //The real recognition follows here
        dw:=FdwFirstProcRVA;
        Repeat
          MinRVA:=DeDeDisASM.GetNextProcRVA(dw, bFound, False);
          DebugLog(DWORD2HEX(MinRVA));
          dw:=MinRVA;

          if dw>=dwEndRVA then break;

          if (not bFound) then
                if (dw>dwLastPublishedMeth) or (dw=0)
                     then break
                     else continue;
           
           
          if dw=0 then break;

          //Here can check if the found RVA is not in the other method RVA space
          //if so /wrong recognition/ then change next rva to the end of this method rva
          for idx:=Low(BegArr) to High(BegArr) do
            if (dw>BegArr[idx]) and (dw<EndArr[idx]) then
               begin
                 dw:=EndArr[idx];
                 continue;
               end;
          
          //If method is not in the method list then add it
          idx:=MethodData.MethodIndexByRVA(dw);
          If idx=-1 Then
             Begin
               Application.ProcessMessages;
               MethodData.AddMethod('_PROC_'+DWORD2HEX(dw),dw,$FFFF);
               Inc(MethodData.Count);
             End;
        Until False;
     end;
end;

procedure TClassDumper.DumpObject(dwSelfPtrPos: DWORD);
var b  : Byte;
    dw : DWORD;
begin
  FdwSelfPrtPos:=dwSelfPtrPos;

  {BOZA DeDeClasses.}PEStream.Seek(dwSelfPtrPos,soFromBeginning);

  // Reads SelfPtr
  {BOZA DeDeClasses.}PEStream.ReadBuffer(FdwSelfPrt,4);

  // Reads ClassFlag
  {BOZA DeDeClasses.}PEStream.ReadBuffer(FbClassFlag,1);

  If FbClassFlag=$0E Then
   Begin
    // Reads ClassName length
    {BOZA DeDeClasses.}PEStream.ReadBuffer(b,1);
    SetLength(FsClassName,b);

    // Reads ClassName
    {BOZA DeDeClasses.}PEStream.ReadBuffer(FsClassName[1],b);
   End;
end;

procedure TClassDumper.DumpObjectEx(dwSelfPtrPos: DWORD; btType : Byte);
var b  : Byte;
    dw : DWORD;
begin
  if btType<>0 Then
    Begin
      FdwSelfPrtPos:=dwSelfPtrPos;

      {BOZA DeDeClasses.}PEStream.Seek(dwSelfPtrPos,soFromBeginning);

      // Reads SelfPtr
      {BOZA DeDeClasses.}PEStream.ReadBuffer(FdwSelfPrt,4);

      // Reads ClassFlag
      {BOZA DeDeClasses.}PEStream.ReadBuffer(FbClassFlag,1);

      // Reads ClassName length
      {BOZA DeDeClasses.}PEStream.ReadBuffer(b,1);
      SetLength(FsClassName,b);

      // Reads ClassName
      {BOZA DeDeClasses.}PEStream.ReadBuffer(FsClassName[1],b);

      Case btType Of
        $01,$02 :
           begin
             {.. Type: 01 or 02 (Integer, Byte, Char etc.)

              DWORD	SelfPointer
              BYTE	Type = 01 or 02
              STRPAS	ClassName
              BYTE	Size (in bytes)
              DWORD     Min Value
              DWORD	Max Value
             }
           end;

        $03     :
           begin
             { Enumeration Type 03

              DWORD	SelfPointer
              BYTE	Type = 03
              STRPAS	ClassName
              BYTE      ??
              DWORD     ??
              DWORD     Number of elements minus one
              DWORD     with value SelfPointer-4 is reached
              STRPAS	EnumName1
              STRPAS	EnumName2
             }

           end;

        $06     :
           begin
             {Set Type 06 (set of TBlahBlah)

              DWORD	SelfPointer
              BYTE	Type = 06
              BYTE	?? (Count)
              DWORD	Elements type: Pointer to (SelfPointer-4)
              }

           end;

        $08     :
           begin
              {Event Type 08

                DWORD	SelfPointer
                BYTE	Type = 08
                STRPAS	ClassName
                BYTE	Event type /00 = procedure, 01 = function/
                BYTE	Param count

                PARAM_DATA
                        BYTE	Prefix     /00 - normal, 01 - *VAR*, 08 - class instance, 10 - Record/
                        STRPAS	Param Name
                        STRPAS	Param Type

                RESULT_DATA (if function)
                        STRPAS	Result Type
              }
           end;

        $0A     :
           begin
             {String Type 0A}
           end;

        $0E     :
           begin
              {Record - Type 0E

                DWORD	SelfPointer
                BYTE	Type 0E - Record
                STRPAS	ClassName
                DWORD	field_1 type
                DWORD   field_2 type
                ..........
                       / note: If the type is class then the dword is the (SelfPointer-4)
              }
           end;

        $0F     :
           begin
              (*
                Interface (0F)

                DWORD	SelfPointer
                BYTE	Type (0E)
                PASSTR	InterfaceName
                DWORD   ParentPtr
                BYTE    ?? (GUID Count)
                GUID    {00000000-0000-0000-C000-000000000046}
                STRPAS	UnitName

              *)

              
           end;

      End;
    End
    Else Begin
      // Directly Inherited from TObject Class
      FbClassFlag:=btType;


      // Additive constant to RVA-Phys conversion for CODE section
      DELTA_PHYS:=  PEHeader.IMAGE_BASE
                   +PEHeader.Objects[1].RVA
                   -PEHeader.Objects[1].PHYSICAL_OFFSET;

      FdwSelfPrt:=({BOZA DeDeClasses.}PEStream.Position+DELTA_PHYS)-8*4;

      {BOZA DeDeClasses.}PEStream.Seek(dwSelfPtrPos-DELTA_PHYS,soFromBeginning);
      // Reads ClassName length
      Try
       {BOZA DeDeClasses.}PEStream.ReadBuffer(b,1);
      except
       exit;
      end;
      if b=0 then exit;
      SetLength(FsClassName,b);
      {BOZA DeDeClasses.}PEStream.ReadBuffer(FsClassName[1],b);

      {BOZA DeDeClasses.}PEStream.Seek(FdwSelfPrt-DELTA_PHYS,soFromBeginning);
      {BOZA DeDeClasses.}PEStream.ReadBuffer(FdwVMTPtr,4);
    End;
end;

function TClassDumper.GetDFMOffset(AsClassName: String): DWORD;
var i: Integer;
begin
  Result:=0;
  i:=DeDeMainForm.DFMFormList.IndexOf(AsClassName);
  if i=-1 Then Exit;
  Result:=DWORD(DeDeMainForm.DFMFormList.Objects[i]);
end;

function TClassDumper.GetMethodRVA(sMethName: String): DWORD;
var i : Integer;
begin
  Result:=0;
  For i:=0 To MethodData.Methods.Count-1 Do
    If TMethodRec(MethodData.Methods[i]).sName=sMethName Then
       Begin
         Result:=TMethodRec(MethodData.Methods[i]).dwRVA;
         Exit;
       End;
end;

function TClassDumper.InCodeSection(RVA: DWORD): Boolean;
var idx : Integer;
begin
  idx:=PEHeader.GetSectionIndexEx('CODE');
  Result:=((RVA-DELTA_PHYS)>=PEHeader.Objects[idx].PHYSICAL_OFFSET)
      and ((RVA-DELTA_PHYS)<=PEHeader.Objects[idx].PHYSICAL_OFFSET+PEHeader.Objects[idx].PHYSICAL_SIZE)
end;

function TClassDumper.InDataSection(RVA: DWORD): Boolean;
var idx : Integer;
begin
  idx:=PEHeader.GetSectionIndexEx('DATA');
  Result:=((RVA-DELTA_PHYS)>=PEHeader.Objects[idx].PHYSICAL_OFFSET)
      and ((RVA-DELTA_PHYS)<=PEHeader.Objects[idx].PHYSICAL_OFFSET+PEHeader.Objects[idx].PHYSICAL_SIZE)
end;

function TClassDumper.IsBSSDATAClass(Index: Integer): Boolean;
begin
  IF Index>FdwDATAPrt.Count
    then result:=false
    else Result:=
           ((FdwDATAPrt[Index]<>nil) or (FdwDFMOffset<>0))
       and (FdwBSSOffset[Index]<>nil)
       and (FdwHeapPtr[Index]<>nil);
end;

Function TClassDumper.IsInData(RVA : DWORD) : Boolean;
var idx : Integer;
begin
  idx:=PEHeader.GetSectionIndexEx('DATA');
  Result:=((RVA-PEHeader.IMAGE_BASE)>=PEHeader.Objects[idx].RVA)
      and ((RVA-PEHeader.IMAGE_BASE)<=PEHeader.Objects[idx].RVA+PEHeader.Objects[idx].VIRTUAL_SIZE);
End;


{ TClassesDumper }

procedure TClassesDumper.AddClass(dwSelfPtrPos: DWORD);
var inst, inst1 : TClassDumper;
    b : Byte;
    s : String;
begin
  PEFile.PEStream.Seek(dwSelfPtrPos+5,soFromBeginning);
  PEFile.PEStream.ReadBuffer(b,1);
  SetLength(s,b);
  PEFile.PEStream.ReadBuffer(s[1],b);
  DeDeMainForm.DumpStatusLbl.Caption:=msg_processing+s+'...';
  Application.ProcessMessages;
  inst:=TClassDumper.Create;
  //inst.PEHeader:=PEHeader;
  Try
    inst.Dump(dwSelfPtrPos);
  Except
    Exit;
  End;

  // Add unit name in Unit list in the case of Delphi2 and CBuilder
  If (GlobCBuilder) or (GlobDelphi2) then
     if DeDeMainForm.UnitList.IndexOf(inst.FsUnitName)=-1 then DeDeMainForm.UnitList.Add(inst.FsUnitName);

  If ClassExists(inst.FsClassName) Then
   begin
     inst1:=GetClassByName(inst.FsClassName);
     If (inst1.FdwDFMOffset<>0) and (inst.FdwDFMOffset<>0)
       then
         Case MessageDlg(
             Format(err_classes_same_name
             ,[inst.FsClassName,inst1.FsUnitName,inst.FsUnitName]),
             mtWarning,[mbOK,mbCancel],0) of
           mrOK     : begin
                        inst1.FdwDFMOffset:=0;
                      end;
           mrCancel : begin
                        inst.FdwDFMOffset:=0;
                      end;
         End
       else begin
          inst1.FieldData.Count:=0;
          inst1.MethodData.Count:=0;

          // Remove duplicates
          if inst.FbClassFlag=$07 then
            begin
              Classes.Remove(inst1);
              inst1.Free;
            end;
       end;
   end;
   Classes.Add(inst);
   DeDeMainForm.CustomPB.Position:=300+Trunc(700*(Classes.IndexOf(inst)-FiZeroCount)/GlobClassesCount);
   Application.ProcessMessages;
end;

procedure TClassesDumper.AddClass_D2(dwSelfPtrPos: DWORD);
var inst, inst1 : TClassDumper;
    b : Byte;
    s : String;
begin
  PEFile.PEStream.Seek(dwSelfPtrPos+5,soFromBeginning);
  PEFile.PEStream.ReadBuffer(b,1);
  SetLength(s,b);
  PEFile.PEStream.ReadBuffer(s[1],b);
  DeDeMainForm.DumpStatusLbl.Caption:=msg_processing+s+'...';
  Application.ProcessMessages;
  inst:=TClassDumper.Create;
  //inst.PEHeader:=PEHeader;
  Try
    inst.Dump(dwSelfPtrPos);

    // Init FdwBSSOffset for non class objects not in [$07,$0E]
    // with its selfpointer. This trick is neseccary for approprite
    // emulation when custom register value is specified
    inst.FdwBSSOffset.Add(Pointer(dwSelfPtrPos));
    inst.FdwDATAPrt.Add(Pointer(dwSelfPtrPos));
    inst.FdwHeapPtr.Add(Pointer(dwSelfPtrPos));
  Except
    Exit;
  End;

  // Add unit name in Unit list in the case of Delphi2 and CBuilder
  If DeDeMainForm.UnitList.IndexOf(inst.FsUnitName)=-1 then DeDeMainForm.UnitList.Add(inst.FsUnitName);

  Classes.Add(inst);
  DeDeMainForm.CustomPB.Position:=300+Trunc(700*(Classes.IndexOf(inst)-FiZeroCount)/GlobClassesCount);
  Application.ProcessMessages;
end;

procedure TClassesDumper.AddObject(dwSelfPtrPos: DWORD);
var inst : TClassDumper;
    b : Byte;
    s : String;
begin
  PEFile.PEStream.Seek(dwSelfPtrPos+5,soFromBeginning);
  PEFile.PEStream.ReadBuffer(b,1);
  SetLength(s,b);
  PEFile.PEStream.ReadBuffer(s[1],b);
  DeDeMainForm.DumpStatusLbl.Caption:=msg_processing+s+'...';
  Application.ProcessMessages;
  inst:=TClassDumper.Create;
  //inst.PEHeader:=PEHeader;
  inst.DumpObject(dwSelfPtrPos);
  if Not ClassExists(inst.FsClassName) then
    begin
      Classes.Add(inst);
      DeDeMainForm.CustomPB.Position:=300+Trunc(700*(Classes.IndexOf(inst)-FiZeroCount)/GlobClassesCount);
      Application.ProcessMessages;
    end
    else inst.Free;      
end;

procedure TClassesDumper.AddObjectEx(dwSelfPtrPos: DWORD; btType : Byte);
var inst : TClassDumper;
    b : Byte;
    s : String;
begin
  if btType<>0 then
    begin
      PEFile.PEStream.Seek(dwSelfPtrPos+5,soFromBeginning);
      PEFile.PEStream.ReadBuffer(b,1);
      SetLength(s,b);
      PEFile.PEStream.ReadBuffer(s[1],b);
    end
    else s:='unknown type';     
  DeDeMainForm.DumpStatusLbl.Caption:=msg_processing+s+'...';
  Application.ProcessMessages;
  inst:=TClassDumper.Create;
  //inst.PEHeader:=PEHeader;
  try
   inst.DumpObjectEx(dwSelfPtrPos,btType);

   // Init FdwBSSOffset for non class objects not in [$07,$0E]
   // with its selfpointer. This trick is neseccary for approprite
   // emulation when custom register value is specified
   inst.FdwBSSOffset.Add(Pointer(dwSelfPtrPos));
   inst.FdwDATAPrt.Add(Pointer(dwSelfPtrPos));
   inst.FdwHeapPtr.Add(Pointer(dwSelfPtrPos));
  except
   exit;
  end;

  // Must add if class with such name is still
  // not added
  if GetClassByName(inst.FsClassName)=nil then
  //if Not ClassExists(inst.FsClassName) then
    begin
      Classes.Add(inst);
      if btType=0
        then Inc(FiZeroCount)
        else DeDeMainForm.CustomPB.Position:=300+Trunc(700*(Classes.IndexOf(inst)-FiZeroCount)/GlobClassesCount);
      Application.ProcessMessages;
   end
   else inst.Free;
end;

procedure TClassesDumper.LoadDFMTXTDATA;
var i, len : Integer;
    inst : TStringList;
    Input : TMemoryStream;
begin
  ClearDFMTXTDATA;
  len:=DeDeMainForm.DFMList.Items.Count;
  if len=0 then exit;

  SetLength(DFMTXTDATA_Names,len);
  For i:=0 To len-1 Do
    Begin
        DeDeMainForm.FbLoadDFMInMemo:=False;
        Try
          DeDeMainForm.DFMList.Selected:=DeDeMainForm.DFMList.Items[i];
        Finally
          DeDeMainForm.FbLoadDFMInMemo:=True;
        End;

        Input:=DeDeMainForm.PrepareDFM;
        try
          try
           DeDePAS.Convert(Input,'');
          except
            inst:=TStringList.Create;
            DFMTXTDATA_Names[i]:=DeDeMainForm.DFMList.Items[i].Caption;
            DFMTXTDATA.Add(inst);
            Input.SaveToFile(ExtractFileDir(Application.ExeName)+'\debug.dat');
            continue;
          end;
          inst:=TStringList.Create;
          inst.LoadFromFile(FsTEMPDir+'dfm.$$$');
          DeleteFile(FsTEMPDir+'dfm.$$$');
          DFMTXTDATA_Names[i]:=DeDeMainForm.DFMList.Items[i].Caption;
          DFMTXTDATA.Add(inst);
          Application.ProcessMessages;
        finally
         If Input<>nil Then Input.Free;
         DeDeMainForm.FbLoadDFMInMemo:=True;
        end;
    End;

  If FileExists(FsTEMPDir+'dfm.$$$') then DeleteFile(FsTEMPDir+'dfm.$$$');
end;



procedure TClassesDumper.ClearClasses;
var i : Integer;
begin
  For i:=Classes.Count-1 DownTo 0 Do
    TClassDumper(Classes[i]).Free;
end;

procedure TClassesDumper.ClearDFMTXTDATA;
var i : Integer;
begin
  For i:=DFMTXTDATA.Count-1 DownTo 0 Do
    TStringList(DFMTXTDATA[i]).Free;
end;

constructor TClassesDumper.Create;
begin
  Inherited Create;

  Classes:=TList.Create;
  DFMTXTDATA:=TList.Create;
  DFMOffsets:=TStringList.Create;
  BSS:=TBSS.Create;
  PackageInfoTable:=TPackageInfoTable.Create;
end;

destructor TClassesDumper.Destroy;
var i : Integer;
begin
  PackageInfoTable.Free;
  BSS.Free;
  DFMOffsets.Free;

  // Removing custom DOI form data
  For i:=0 To Classes.Count-1 Do
    If (TClassDumper(Classes[i]).FdwDFMOffset<>0)
      Then DeDeClassEmulator.OffsInfArchive.RemoveOffsInfo(TClassDumper(Classes[i]).FsClassName);

  ClearClasses;
  Classes.Free;
  ClearDFMTXTDATA;
  DFMTXTDATA.Free;

  Inherited Destroy;
end;

procedure TClassesDumper.Dump;
var dw, dw1, dw2, code_size,delta,bkup, EndSerchFuncOffs : DWORD;
    b, len : byte;
    i, j, k{, D2_idx} : Integer;
    buff, patt : Array of Byte;
    s : String;
    bFound : Boolean;

    Procedure DumpD2;
    var D2_idx, j : Integer;
        _code_size : dword;
        _bt : Byte;
    begin
      With DeDeMainForm Do
        begin
          GlobClassesCount:=DFMFormList.Count;
          CustomPB.Position:=300;

          // Copy the class name list because of delphi compiler bug !!!
          SetLength(TmpArr,DFMFormList.Count);
          For D2_idx:=0 to DFMFormList.Count-1 do TmpArr[d2_idx]:=DFMFormList[d2_idx];
        end;

      _code_size:=PEHeader.Objects[1].PHYSICAL_OFFSET+PEHeader.Objects[1].PHYSICAL_SIZE;
      // Search for $07+FormNameAsPascalString got from DFM resource list
      // patt[] is the array containing what is going to be serached
      For D2_idx:=0 to High(TmpArr) do
        Begin
          s:=TmpArr[d2_idx];
          len:=Length(s);
          SetLength(patt,len);
          patt[0]:=$07; patt[1]:=len;
          for j:=1 to len do patt[j+1]:=ORD(s[j]);

          {BOZA DeDeClasses.}PEStream.Seek(PEHeader.Objects[1].PHYSICAL_OFFSET,soFromBeginning);
          bFound:=False;

          // Read byte if it equals $07 then reads buff[] and
          // compares with patt[] else move one byte forward
          Repeat
            bkup:={BOZA DeDeClasses.}PEStream.Position;

            {BOZA DeDeClasses.}PEStream.ReadBuffer(_bt,1);
            if _bt=$07 then
              begin
                SetLength(buff,len);
                {BOZA DeDeClasses.}PEStream.ReadBuffer(buff[0],len);

                // Doesn't compare buff[0] with patt[0] because patt[0]=$07
                if CompareMem(@buff[0],@patt[1],len) then
                  begin
                    AddClass_D2(bkup-4);
                    bFound:=True;
                  end;

                {BOZA DeDeClasses.}PEStream.Seek(bkup+1,soFromBeginning);
              end;

            If {BOZA DeDeClasses.}PEStream.Position mod 200 = 0 then Application.ProcessMessages;

          Until (bFound) or ({BOZA DeDeClasses.}PEStream.Position>=_code_size);
        End;
    end; {DumpD2}

begin
  // No BSS dump if BCB
  if GlobCBuilder then  bBSS:=False;

  // If BSS option is enabled dump the BSS section
  if bBSS Then
   begin
      DeDeMainForm.DumpStatusLbl.Caption:=msg_loadingtarget;
      DeDeMainForm.DumpStatusLbl.Update;
      If FileExists(DeDeMainForm.FsFileName)
        then begin
          BSS.Free;
          BSS:=TBSS.Create;
          BSS.Dump(DeDeMainForm.FsFileName);
        end;
   end;

  // Dump DFM Offsets
  DeDeMainForm.DumpStatusLbl.Caption:=msg_dumpingdsfdata;
  DeDeMainForm.DumpStatusLbl.Update;

  Application.ProcessMessages;
  DeDeMainForm.DumpDFMNames;

  delta:=PEHeader.IMAGE_BASE+(PEHeader.Objects[1].RVA)-PEHeader.Objects[1].PHYSICAL_OFFSET;
  code_size:=PEHeader.Objects[1].PHYSICAL_OFFSET+PEHeader.Objects[1].PHYSICAL_SIZE;

  // Dump Classes
  DeDeMainForm.DumpStatusLbl.Caption:=msg_dumpingclasses;
  DeDeMainForm.DumpStatusLbl.Update;

  GlobClassesCount:=0;
  {BOZA DeDeClasses.}PEStream.Seek(PEHeader.Objects[1].PHYSICAL_OFFSET,soFromBeginning);
  ///////////////////////////////////////
  // Find and Dump Classes Self Pointers
  //      <> Delphi 2 (no self pointers)
  ///////////////////////////////////////
  If not GlobDelphi2 then
    Begin
      Repeat
        {BOZA DeDeClasses.}PEStream.ReadBuffer(dw,4);
        // If a self-pointer is found
        If dw-delta={BOZA DeDeClasses.}PEStream.Position Then
          Begin
            bkup:={BOZA DeDeClasses.}PEStream.Position;
            {BOZA DeDeClasses.}PEStream.ReadBuffer(b,1);
            if b<$11 Then Inc(GlobClassesCount);
            {BOZA DeDeClasses.}PEStream.Seek(bkup,soFromBeginning);
          End;

        If {BOZA DeDeClasses.}PEStream.Position mod 200 =0 then
         begin
           DeDeMainForm.CustomPB.Position:=200+Trunc(100*({BOZA DeDeClasses.}PEStream.Position)/code_size);
           Application.ProcessMessages;
         end;
      Until ({BOZA DeDeClasses.}PEStream.Position>=code_size);


      DeDeMainForm.CustomPB.Position:=300;
      If GlobClassesCount=0 Then Exit;
      FiZeroCount:=0;
      {BOZA DeDeClasses.}PEStream.Seek(PEHeader.Objects[1].PHYSICAL_OFFSET,soFromBeginning);

      Repeat
        {BOZA DeDeClasses.}PEStream.ReadBuffer(dw,4);
        bkup:={BOZA DeDeClasses.}PEStream.Position;

        // If a self-pointer is found
        If dw-delta={BOZA DeDeClasses.}PEStream.Position Then
          Begin
            {BOZA DeDeClasses.}PEStream.ReadBuffer(b,1);
            case b of
               $00     : ;// Nothing
               $07     : // Classes with specified UnitName
                         AddClass(bkup-4);

               else If (b<=$11) Then AddObjectEx(bkup-4,b);
            end;

            {BOZA DeDeClasses.}PEStream.Seek(bkup,soFromBeginning);
          End;


          // Check for Classes directly inherited from TObject
          {BOZA DeDeClasses.}PEStream.ReadBuffer(dw1,4);
          dw2:=PEStream.Position-10*4;
          {BOZA DeDeClasses.}PEStream.Seek(dw2,soFromBeginning);
          {BOZA DeDeClasses.}PEStream.ReadBuffer(dw2,4);
          {BOZA DeDeClasses.}PEStream.Seek(bkup+4,soFromBeginning);

          if ((dw-dw1*4+12)=({BOZA DeDeClasses.}PEStream.Position+delta))
                 then if (IsInCodeSection(dw)) then AddObjectEx(dw,0)
                                               else
             else if
               (IsInCodeSection(dw))
               and (IsInCodeSection(dw2))
               and (dw-dw2>0)
               and (dw-dw2<$100)then
                begin
                  {BOZA DeDeClasses.}PEStream.Seek(dw-delta,soFromBeginning);
                  {BOZA DeDeClasses.}PEStream.Read(b,1);
                  if (b>0) then
                    begin
                      dw1:=b;
                      repeat
                        {BOZA DeDeClasses.}PEStream.Read(b,1);
                        if not (CHR(b) in ['A'..'Z','a'..'z','0'..'9','_']) then break;
                        Dec(dw1);
                      until dw1=0;
                      {BOZA DeDeClasses.}PEStream.Seek(bkup+4,soFromBeginning);
                      if dw1=0
                         then AddObjectEx(dw,0);
                    end;
                end;

          {BOZA DeDeClasses.}PEStream.Seek(bkup,soFromBeginning);

      Until ({BOZA DeDeClasses.}PEStream.Position>=code_size);


    End {sDelphiVersion<>'D2'}



    ///////////////////////////////////////
    // Delphi 2 Class Finder
    //
    ///////////////////////////////////////
    Else begin
      DumpD2;
    end;

  ///////////////////////////////////////////////////////////////////////////////////////
  // Dumping classes methods (published)
  //////////////////////////////////////////////////////////////////////////////////////
  DeDeMainForm.CustomPB.Position:=1000;
  DeDeMainForm.CustomPB.Update;
  DeDeMainForm.DumpStatusLbl.Caption:=msg_dumpingprocs;
  DeDeMainForm.DumpStatusLbl.Update;
  Try
    // Dump Methods
    For i:=0 To Classes.Count-2 Do
      begin
       TClassDumper(Classes[i]).DumpMethods(0);
       DeDeMainForm.CustomPB.Position:=1000+Trunc(50*(i)/Classes.Count);
       Application.ProcessMessages;
      end;

    TClassDumper(Classes[Classes.Count-1]).DumpMethods(0);

  Except
   on e:Exception Do ShowMessage(e.Message);
  End;


  DeDeDisASM.RVAConverter.ImageBase:=PEHeader.IMAGE_BASE;
  DeDeDisASM.RVAConverter.PhysOffset:=PEHeader.Objects[1].PHYSICAL_OFFSET;
  DeDeDisASM.RVAConverter.CodeRVA:=PEHeader.Objects[1].RVA;
    
  /////////////////////////////////////////////////////////////////////////////////////////
  // Dump units data from  PackageInfoTable and seek/dump additional procedures
  /////////////////////////////////////////////////////////////////////////////////////////
  if bBSS Then
    begin
      DeDeMainForm.DumpStatusLbl.Caption:=msg_read_package_info;
      DeDeMainForm.DumpStatusLbl.Update;
      DeDeMainForm.CustomPB.Position:=1050;
      DeDeMainForm.CustomPB.Update;
      Application.ProcessMessages;

      //Find the physical offset of System..InitUnits() function
      dw:=GetInitUnitsProcRVA;
      if dw<>0 then
        begin
          Case ReducedDelphiVersion of
            dvD2 : j:=InitContextOffset2;
            dvD3, dvBCB3 : j:=InitContextOffset3;
            dvD4, dvBCB4, dvD5, dvBCB5, dvD6 : j:=InitContextOffset4;
            else j:=InitContextOffset4;
          end;
          //Goes there and reads the InitContext.PackageInfo member
          PEFile.PEStream.Seek(dw+j, soFromBeginning);
          PEFile.PEStream.ReadBuffer(dw1,4);

          // Check is it CODE offset
          If OffsetInSegment(dw1,'BSS') then
            begin
              // Gets the real data pointer in the file as physical offset
              dw:=BSS.GetPointer(dw1)-PEHeader.IMAGE_BASE
                                     -PEHeader.Objects[1].RVA
                                     +PEHeader.Objects[1].PHYSICAL_OFFSET;

              //Goes there
              PEFile.PEStream.Seek(dw, soFromBeginning);
              PEFile.PEStream.ReadBuffer(dw1,4);

              if dw1<>0 then
                With PackageInfoTable Do
                  Begin
                    dwPhysOffs:=dw+8;
                    SetUnitCount(dw1);

                    For i:=0 to dw1-1 do
                      begin
                        //Reads Units data
                        PEFile.PEStream.Seek(dwPhysOffs+8*i, soFromBeginning);
                        PEFile.PEStream.ReadBuffer(dw,4);
                        UnitsInitPtrs[i]:=dw;
                        PEFile.PEStream.ReadBuffer(dw,4);
                        UnitsFInitPtrs[i]:=dw;
                      end;

                    IdentUnitNames(Self);
                  End;
            end;
        end;
    end;

  //////////////////////////////////////////////////////////////
  // Dumping additional procs - finding their addresses
  //////////////////////////////////////////////////////////////
  DeDeMainForm.CustomPB.Position:=1050;
  DeDeMainForm.CustomPB.Update;
  DeDeMainForm.DumpStatusLbl.Caption:=msg_dumpingprocs;
  DeDeMainForm.DumpStatusLbl.Update;
  Try
    // Dump Methods
    For i:=0 To Classes.Count-2 Do
      begin
       //Find the end of seek offset
       EndSerchFuncOffs:=TClassDumper(Classes[i+1]).FdwSelfPrt;
       for k:=0 to PackageInfoTable.dwUnitCount-1 do
         if PackageInfoTable.UnitsStartPtrs[k]>TClassDumper(Classes[i]).FdwFirstProcRVA then
           begin
              if  PackageInfoTable.UnitsStartPtrs[k]<EndSerchFuncOffs
                 then EndSerchFuncOffs:=PackageInfoTable.UnitsStartPtrs[k];
              break;
           end;

       //DebugLog(TClassDumper(Classes[i]).FsClassName+' ->'+DWORD2HEX(TClassDumper(Classes[i]).FdwFirstProcRVA)+'  ->'+DWORD2HEX(EndSerchFuncOffs));
       TClassDumper(Classes[i]).DumpMethods(EndSerchFuncOffs,True);
       DeDeMainForm.CustomPB.Position:=1050+Trunc(50*(i)/Classes.Count);
       Application.ProcessMessages;
      end;

     //Find the end of seek offset
     EndSerchFuncOffs:=PEHeader.RVA_ENTRYPOINT;
     for k:=0 to PackageInfoTable.dwUnitCount-1 do
       if PackageInfoTable.UnitsStartPtrs[k]>TClassDumper(Classes[Classes.Count-1]).FdwFirstProcRVA then
         begin
            if  PackageInfoTable.UnitsStartPtrs[k]<EndSerchFuncOffs
               then EndSerchFuncOffs:=PackageInfoTable.UnitsStartPtrs[k];
            break;
         end;
    TClassDumper(Classes[Classes.Count-1]).DumpMethods(EndSerchFuncOffs,True);

  Except
   on e:Exception Do ShowMessage(e.Message);
  End;


  /////////////////////////////////////////////////////////////////////////////////////////
  // Building BSS/DATA pointers list
  /////////////////////////////////////////////////////////////////////////////////////////
  if bBSS Then
   begin
      DeDeMainForm.DumpStatusLbl.Caption:=msg_initpointers;
      DeDeMainForm.DumpStatusLbl.Update;
      DeDeMainForm.CustomPB.Position:=1100;
      DeDeMainForm.CustomPB.Update;
      for j:=0 to self.Classes.Count-1 do
       begin
          DeDeMainForm.CustomPB.Position:=1100+Trunc(200*(j)/self.Classes.Count);
          Application.ProcessMessages;

          // skip the non classes and objects
          if not (TClassDumper(self.Classes[j]).FbClassFlag in [$07,$0E]) then continue;

          // Class Self Pointer
          dw1:=TClassDumper(self.Classes[j]).FdwVMTPtr;
          // Do not process bullshits
          if dw1=0 then continue;

          i:=BSS.dwStartRVA;

          while i<(BSS.dwStartRVA+BSS.dwSize) do
            begin
              if (i mod 160) = 0 then Application.ProcessMessages;
              if BSS.GetValue(i)=dw1 then
                 begin
                   TClassDumper(self.Classes[j]).FdwBSSOffset.Add(Pointer(i));
                   TClassDumper(self.Classes[j]).FdwHeapPtr.Add(Pointer(BSS.GetPointer(i)));
                   TClassDumper(self.Classes[j]).FdwDATAPrt.Add(Pointer(BSS.GetDataPrtOfBSSData(i)));
                 end;
              Inc(i,4);
            end;
       end;
   end;

  DeDeMainForm.CustomPB.Position:=1300;
  DeDeMainForm.CustomPB.Update;
  DeDeMainForm.DumpStatusLbl.Caption:=msg_done;
  DeDeMainForm.DumpStatusLbl.Update;
end;

procedure TClassesDumper.FinilizeDump;
var Cstm, tfrm : TOffsInfStruct;
    i : Integer;
begin
  // Loads DFMTXTData
  LoadDFMTXTDATA;

  // Load DOI definitions for dumped forms
  tfrm:=DeDeClassEmulator.OffsInfArchive.GetOffsInfoByClassName('TForm');
  if tfrm=nil then Exit;
  
  For i:=0 To Classes.Count-1 Do
    If (TClassDumper(Classes[i]).FdwDFMOffset<>0)
      Then Begin
        Cstm:=TOffsInfStruct.Create;
        Cstm.Assign(tfrm);
        Cstm.FsClassName:=TClassDumper(Classes[i]).FsClassName;
        Cstm.FHierarchyList.Add('TForm');
        DeDeClassEmulator.OffsInfArchive.AddOffsInfo(Cstm);
      End;
end;


Function CheckFile(AsFile : String) : Boolean;
Begin
  Result:=True;
  If Not bWARN_ON_FILE_OVERWRITE Then Exit;
  If FileExists(AsFile) Then
     Result:=MessageDlg(Format(wrn_fileexists,[AsFile]),mtConfirmation,[mbYes,mbNo],0)=mrYes;
End;

Procedure TruncAll(Var s : String);
Begin
  While Copy(s,1,1)=' ' Do s:=Copy(s,2,Length(s)-1);
  While Copy(s,Length(s),1)=' ' Do s:=Copy(s,1,Length(s)-1);
End;

procedure TDeDeMainForm.CompileToSymAndLoadInSice(sMAPFilePath, sSicePath : String);
begin
 With StatsForm Do
   Begin
     FsSiceDir:=sSicePath;
     FsTarget:=sMAPFilePath;
     ShowModal;
   End;
end;

procedure TDeDeMainForm.PreBtnClick(Sender: TObject);
var //PE : TDelphi4PE;
    ProjHeader : TDFMProjectHeader;
    sCompilerOffset : String;
    sCompilerComment : String;
    dwProjectHeaderOffset : DWORD;
    i,idx : Integer;
    ListItem : TListItem;
    tick1,tick2 : Cardinal;
    iIDX : Byte;
    bNoChanges : Boolean;
begin
  GlobCBuilder:=False;
  tick1:=GetTickCount;
  tick2:=tick1;

  bUserProcs:=DeDeReg.bDumpAll;
  bBSS:=DeDeReg.bObjPropRef;
  DeDeProjectFileName := ExtractFileNameWOExt(FsFileName) + '.dpj';
  If not FbMemFump then
   begin
      // Some checks for the file name
      If FileEdit.FileName='' Then FileEdit.FileName:=FE.Text;
      If FileEdit.FileName='' Then Raise Exception.Create(err_specifyfilename);
      If Not FileExists(FileEdit.FileName) Then Raise Exception.Create(err_filenotfound);

      If RecentFileEdit.Items.IndexOf(FE.Text)=-1
         Then RecentFileEdit.Items.Insert(0,FE.Text)
         Else Begin
            RecentFileEdit.Items.Delete(RecentFileEdit.Items.IndexOf(FE.Text));
            RecentFileEdit.Items.Insert(0,FE.Text);
         End;
      If RecentFileEdit.Items.Count>10 Then RecentFileEdit.Items.Delete(RecentFileEdit.Items.Count-1);
      GlobGetImports:=True;

      // This creates the new PEFile, dumps the PEHeader and
      // assigns it to DeDeClasses.PEHeader and DeDeDisASM.PEHeader
      // plus some more stuff
      PrepareProject(FileEdit.FileName);

      ProjHeader:=nil;
    End
    Else Begin
      GlobGetImports:=False;
    End;

  ProjectNameLbl.Caption:='';
  DumpStatusLbl.Caption:='';
  PrcsBtn.Enabled:=False;
  Process1.Enabled:=False;
  ClearDeDeLists;
//  FOpCodeList.Clear;
//  FControlList.Clear;

  // Determine Compiler
  FFileType:=ftEXE;
//  PE:=TDelphi4PE.Create;
  SetExitCtrls(False);
  Try
//    PE.FMemFile:=PEFile.PEStream;
//    PE.SetOffsets(PEHeader.IMAGE_BASE,PEHeader.BaseOfCode,PEHeader.Objects[1].RVA,PEHeader.Objects[1].VIRTUAL_SIZE,PEHeader.Objects[1].PHYSICAL_OFFSET,PEHeader.RVA_ENTRYPOINT);

    CustomPB.Min:=0;
    CustomPB.Max:=1300;
    CustomPB.Position:=0;
    DumpStatusLbl.Caption:=msg_analizefile;
    DumpAnimation.Visible:=True;
    DumpAnimation.Animate:=True;
    DumpAnimation.Update;

    /////////////////////////////////////////////////////////////
    // Needed for UnlinkCalls
    DeDeSym.FirstCodeRVA:=PEHeader.BaseOfCode+PEHeader.IMAGE_BASE;

//////////////////////////////////////////////////////////////////////
///// ------------ 'BOOLEAN' CHECK ---------------------------------//
//////////////////////////////////////////////////////////////////////
    ProjHeader:=nil;
    GlobDelphi2:=False;
    sDelphiVersion:='';
    If Not IsDelphiApp
      Then Begin
       If FbCutSelfPtr
          // Self Ptr is Cut! And 'Boolean' is found -> Delphi 2
          Then  Begin
            ShowMessage(wrn_d2_app);
            GlobDelphi2:=True;
            sDelphiVersion:='D2';
          End
          // Self Ptr Is not Cut. CODE section is crypted
          Else
            Begin
              //If MessageDlg(err_might_not_delphi_app,mtWarning,[mbAbort,mbIgnore],0)=mrAbort Then Exit;

              iIDX:=PEHeader.GetSectionIndex('.idata');
              if iIDX=255 then iIDX:=PEHeader.GetSectionIndexByRVA(PEHEader.IMPORT_TABLE_RVA);
              sDelphiVersion:=GetDelphiVersionFromImports(FsFileName,
                  PEHeader.Objects[iIDX].PHYSICAL_OFFSET,
                  PEHeader.Objects[iIDX].RVA);

              If (sDelphiVersion='Console')
                 then MessageDlg(wrn_not_using_vcl,mtInformation,[mbOk],0)
                 else begin
                    if sDelphiVersion='<unknown>'
                      then begin
                         ShowMessage(err_not_delphi_app);
                         exit;
                      end
                      else begin
                        sCompilerComment:=IdentCompiler(sCompilerOffset);
                        if UnitList.IndexOf('kol')<>-1
                          then MessageDlg(wrn_KOL_found,mtInformation,[mbOk],0)
                          else ShowMessage(sDelphiVersion+wrn_runtime_pkcg);
                      end;
                    if Copy(sDelphiVersion,1,3)='BCB' then GlobCBuilder:=True;
                 end;
            End;
     End
     Else sDelphiVersion:='';
/////////////////////////////////////////////////////////////////////
///// END OF 'BOOLEAN' CHECK
/////////////////////////////////////////////////////////////////////

    sCompilerComment:=IdentCompiler(sCompilerOffset);
    dwProjectHeaderOffset:=HEX2DWORD(sCompilerOffset);

    FsProjectName:=AnsiLowerCase(ChangeFileExt(sCompilerComment,''));
    If sCompilerComment='' Then
     Begin
       ShowMessage(err_not_delphi_app);
       Exit;
     End
     else ProjectNameLbl.Caption:=sCompilerComment;

//////////////////////////////////////////////////////////////////////
///// ------------ NEW DUMP ENGINE ---------------------------------//
//////////////////////////////////////////////////////////////////////

    If sDelphiVersion='' Then sDelphiVersion:=GetDelphiVersion(PEFile);

    If (sDelphiVersion='Console')
       then VersionLbl.Caption:=txt_delphi_version+'N/A'
       else VersionLbl.Caption:=txt_delphi_version+sDelphiVersion;

    // Set the Version Bit Flag used in DSF references
    while Length(sDelphiVersion)<2 do sDelphiVersion:=sDelphiVersion+' ';
    // The default value is to use all DFSs
    DelphiVestionCompability:=$0E;
    Case sDelphiVersion[2] of
      '2' : DelphiVestionCompability:=$8;
      '3' : DelphiVestionCompability:=$1;
      '4' : DelphiVestionCompability:=$2;
      '5' : DelphiVestionCompability:=$4;
      '6' : DelphiVestionCompability:=$10;
      'C' : Case sDelphiVersion[4] of {CBuilder !!! or DConsole}
              '3' : DelphiVestionCompability:=$1;
              '4' : DelphiVestionCompability:=$2;
              '5' : DelphiVestionCompability:=$4;
              'n' : DelphiVestionCompability:=$0E; {console application.
                                            could not determine Delphi version.
                                            use all dsfs}
            end;
       'y' : case sDelphiVersion[6] of {Kylix ELF file}
              '1' : DelphiVestionCompability:=$10;
              '2' : DelphiVestionCompability:=$10;
            end;
       else DelphiVestionCompability:=$0E;
     end;

    // One more time the same check for ReducedDelphiVersion
    Case sDelphiVersion[2] of
      '2' : ReducedDelphiVersion:=dvD2;
      '3' : ReducedDelphiVersion:=dvD3;
      '4' : ReducedDelphiVersion:=dvD4;
      '5' : ReducedDelphiVersion:=dvD5;
      '6' : ReducedDelphiVersion:=dvD6;
      'C' : Case sDelphiVersion[4] of {CBuilder !!! or DConsole}
              '3' : ReducedDelphiVersion:=dvBCB3;
              '4' : ReducedDelphiVersion:=dvBCB4;
              '5' : ReducedDelphiVersion:=dvBCB5;
              'n' : ReducedDelphiVersion:=dvConsole;
            end;
       'y' : ReducedDelphiVersion:=dvKylix;
       else ReducedDelphiVersion:=dvNone;
    End;    

    ProjHeader:=TDFMProjectHeader.Create;
    Try
      CustomPB.Position:=200;
      DumpStatusLbl.Caption:=msg_dumping_unit_data;
      Try
      //////////////////////////////////////////////////////////
      //  !!!!!This must be used for Delphi2 executables !!!!!
      //  ProjHeader.Dump(PEFile.PEStream,dwProjectHeaderOffset);
      Except
       On E: Exception Do ProjHeader.ProjectName:='NoName';
      End;
      //ProjectNameLbl.Caption:=ProjHeader.ProjectName;
   Finally
   End;    

    PEStream:=PEFile.PEStream;
    //No need
    //DumpDFMNames;
    If ClassesDumper<>nil Then
      Begin
        ClassesDumper.Free;
        ClassesDumper:=TClassesDumper.Create;
      End;
    {BOZA DeDeClasses.}PEStream:=PEFile.PEStream;
    DeDeClasses.PEHeader:=PEHeader;
    //ClassesDumper.PEHeader:=PEHeader;
    DelphiVersion:=sDelphiVersion;

      With ClassesDumper Do
       Begin
        ClassesDumper.ClearClasses;
        Dump;
        ClassesLV.Items.BeginUpdate;
        ClassesLV.Items.Clear;
        Try
          For idx:=0 To ClassesDumper.Classes.Count-1 Do
            Begin
              ListItem:=ClassesLV.Items.Add;
              ListItem.Caption:=TClassDumper(ClassesDumper.Classes[idx]).FsClassName;
              ListItem.Data:=TClassDumper(ClassesDumper.Classes[idx]);
              ListItem.SubItems.Add(TClassDumper(ClassesDumper.Classes[idx]).FsUnitName);
              ListItem.SubItems.Add(IntToHex(TClassDumper(ClassesDumper.Classes[idx]).FdwSelfPrt,8));
              ListItem.SubItems.Add(IntToHex(TClassDumper(ClassesDumper.Classes[idx]).FdwDFMOffset,8));
              If TClassDumper(ClassesDumper.Classes[idx]).FdwDFMOffset<>0
                 Then ListItem.ImageIndex:=1
                 Else
                   Case TClassDumper(ClassesDumper.Classes[idx]).FbClassFlag of
                      //3,6 : ListItem.ImageIndex:=5;
                      $07 : ListItem.ImageIndex:=0;
                      $08 : ListItem.ImageIndex:=3;
                      $0E : ListItem.ImageIndex:=2;
                      $0F : ListItem.ImageIndex:=4;
                   End;
            End;
        Finally
          ClassesLV.Items.EndUpdate;
        End;
      End;

      // Adding Forms Data
      DFMList.Items.BeginUpdate;
      DFMList.Items.Clear;
      Try
        For idx:=0 To ClassesDumper.Classes.Count-1 Do
           If TClassDumper(ClassesDumper.Classes[idx]).FdwDFMOffset<>0 Then
             Begin
               ListItem:=DFMList.Items.Add;
               ListItem.Caption:=TClassDumper(ClassesDumper.Classes[idx]).FsClassName;
               ListItem.SubItems.Add(IntToHex(TClassDumper(ClassesDumper.Classes[idx]).FdwDFMOffset,8));
               ListItem.Data:=TClassDumper(ClassesDumper.Classes[idx]);
             End;

{        Repeat
          bNoChanges:=True;
          For idx:=0 to DFMList.Items.Count-2 do
            begin
              if HEX2DWORD(DFMList.Items[idx].SubItems[0])<HEX2DWORD(DFMList.Items[idx+1].SubItems[0]) then
                begin
                  DFMList.Items.
                  bNoChanges:=False;
                end;
            end;
        Until bNoChanges; }
         DFMList.SortType:=stData;
         DFMList.AlphaSort;
      Finally
        DFMList.Items.EndUpdate;
      End;

      // Adding PackageInfo unit names
      PIUL.Clear;
      For idx:=0 To UnitList.Count-1 Do
       Begin
         if UnitList[idx]<>'' then PIUL.Items.add(UnitList[idx]);
       end;

      // Adding Units Data
      DCULV.Items.BeginUpdate;
      DCULV.Items.Clear;
      UnitList.Clear;
      DFMNameList.Clear;
      Try
        For idx:=0 To ClassesDumper.Classes.Count-1 Do
           If TClassDumper(ClassesDumper.Classes[idx]).FdwDFMOffset<>0 Then
             Begin
               ListItem:=DCULV.Items.Add;
               ListItem.Caption:=TClassDumper(ClassesDumper.Classes[idx]).FsUnitName;
               ListItem.SubItems.Add(TClassDumper(ClassesDumper.Classes[idx]).FsClassName);
               ListItem.Data:=TClassDumper(ClassesDumper.Classes[idx]);
               // Adding UnitList and DFMNameList data
               // This Data are used in the project space save process
               UnitList.Add(ListItem.Caption);
               DFMNameList.Add(ListItem.SubItems[0]);
             End;
      Finally
        DCULV.Items.EndUpdate;
      End;


     UnitDataLV.Items.BeginUpdate;
     Try
       // Adding PackageInfoTable Data
       For idx:=0 To ClassesDumper.PackageInfoTable.dwUnitCount-1 do
         begin
          ListItem:=UnitDataLV.Items.Add;
          ListItem.Caption:=ClassesDumper.PackageInfoTable.UnitsNames[idx];
          ListItem.SubItems.Add(DWORD2HEX(ClassesDumper.PackageInfoTable.UnitsStartPtrs[idx]));
          ListItem.SubItems.Add(DWORD2HEX(ClassesDumper.PackageInfoTable.UnitsInitPtrs[idx]));
          ListItem.SubItems.Add(DWORD2HEX(ClassesDumper.PackageInfoTable.UnitsFInitPtrs[idx]));
          ListItem.Data:=ClassesDumper.PackageInfoTable.ClassesList[idx];
          ListItem.ImageIndex:=8;
          if Copy(ListItem.Caption,1,5)='Unit_' then ListItem.ImageIndex:=6;
          if ClassesDumper.PackageInfoTable.UnitsFInitPtrs[idx]=
             ClassesDumper.PackageInfoTable.UnitsStartPtrs[idx]
             then ListItem.ImageIndex:=7;
          if ClassesDumper.PackageInfoTable.UnitsInitPtrs[idx]=0
             then ListItem.ImageIndex:=9;
         end;
     Finally
       UnitDataLV.Items.EndUpdate;
     End;

     PIUL.Repaint;

     tick2:=GetTickCount;

     //Load DSF files
     LoadDSFForDelphiTargetVersion;
     
     //Loads Offset Info Data
     LoadOffsetInfo;

     //Loads DFMTXTDATA
     DumpstatusLbl.Caption:=msg_finalclassdmp;
     DumpstatusLbl.Update;
     
     ClassesDumper.FinilizeDump;

     
     ShowMessage(msg_dump_success);
     FbSavedProject:=False;
     FbFailed:=False;
 Finally
   SetExitCtrls(True);
//   PE.Free;
   DumpAnimation.Animate:=False;
   DumpAnimation.Visible:=False;
   If ProjHeader<>nil Then ProjHeader.Free;
   DumpstatusLbl.Caption:='';
   CustomPB.Position:=0;
   PrcsBtn.Enabled:=True;
   Process1.Enabled:=True;
   StsBar.Panels[1].Text:=Format(msg_ready_secs,[IntToStr(Trunc((tick2-tick1)/1000))]);
   FbProcessed:=True;
   FbMemFump:=False;
 End;

  DeDeDisAsm.bErrorsAsFile:=True;
  AssignDeDeDisAsms;

  if bDebug then DebugLogList.SaveTofile(ChangeFileExt(Application.ExeName,'.dbg.txt'));

end;

function TDeDeMainForm.IdentCompiler(var AsOffset: String): String;
const constSysInit = 'SysInit';
      constSystem  = 'System';
Var i, iSizeBack : Integer;
    w : WORD;
    b : Byte;
    hM : HINST;
    hr : HRSRC;
    hres : Cardinal;
    sz, dwPOS : Cardinal;
    resRVA, resPhys, imgbase : DWORD;
    pRes : Pointer;
    s : String;
begin
  if (GlobCBuilder) or (GlobDelphi2) or (bELF) then
     begin
       Result:=ExtractFileName(FsFileName);
       Exit;
     end;

  // Seeking DFM Project Header
  i:=PEHEader.GetSectionIndexEx('.rsrc');
  If i=-1 Then i:=PEHEader.GetSectionIndexByRVA(PEHeader.RESOURCE_TABLE_RVA);

  resPhys:=PEHeader.Objects[i].PHYSICAL_OFFSET;
  resRVA:=PEHeader.Objects[i].RVA;
  imgbase:=PEHeader.IMAGE_BASE;


/////////////////////////////////////////////////////
///// NEW PROJECT HEADER DUMP ENGINE
/////////////////////////////////////////////////////

  // no PACKAGEINFO RCDATA in Delphi2 executable, so exit
  if GlobDelphi2 Then Exit;

  // If Memory dump then exit
  if FbMemFump Then
    begin
       Result:='UnKnown';
       Exit;
    end;

  // Getting Pointer to
  hm:=LoadLibrary(PChar(FsFileName));// ,0, LOAD_LIBRARY_AS_DATAFILE);
  if hm=0 then begin
    ShowMessageFmt(err_cantload,[FsFileName]);
    Result:='UnKnown';
    exit;
  end;
  Try
    hr:=FindResource(hm,PChar('PACKAGEINFO'),RT_RCDATA);
    hres:=LoadResource(hm,hr);
    pres:=LockResource(hres);
    sz:=SizeofResource(hm,hr);
  finally
    FreeLibrary(hm);
  end;

   Result:=ExtractFileName(FsFileName);//'UnKnown';
   If pres=nil Then Exit;

   // Result is Project Name
   Result:='';
   dwPos:=DWORD(pRes)-hm-resRVA+resPhys;

   // AsOffset : is Project Header offset
   AsOffset:=DWORD2HEX(DWORD(pRes)-hm+imgbase);

   //ShowMessage(Format('%s  %s  %s %s',[IntToHex(hm,8), IntToHex(DWORD(pRes),8),IntToHex(dwPos,8), AsOffset]));
   PEFile.PEStream.Seek(dwPos+iPACKAGEINFO_APP_OFFSET,soFromBeginning);
   Repeat
    PEFile.PEStream.ReadBuffer(b,1);
    if b<>0 then Result:=Result+CHR(b);
   Until b=0;

   // Read Unit List
   UnitList.Clear;
   Repeat
     //////////////////////////////////////////////////////////////
     // This shit code is to avoid 'TPF0' crap in unit list only !
     if PEFile.PEStream.Position mod 2 = 1 then
       begin
         PEFile.PEStream.ReadBuffer(w,1);
         iSizeBack:=5;
       end
       else begin
         //PEFile.PEStream.ReadBuffer(w,2);
         iSizeBack:=4;
       end;

     SetLength(s,4);
     PEFile.PEStream.ReadBuffer(s[1],4);
     PEFile.PEStream.Seek(-iSizeBack,soFromCurrent);
     if s=sDFM_Magic_Stirng
        then break;
     //
     ///////////////////////////////////////////////////////////////

     PEFile.PEStream.ReadBuffer(w,2);
     s:='';
     Repeat
       PEFile.PEStream.ReadBuffer(b,1);
       if b<>0 then s:=s+CHR(b);
     Until b=0;
     UnitList.Add(s);
   Until PEFile.PEStream.Position>=DWORD(pRes)-hm-resRVA+resPhys+sz;

   If Copy(UnitList[UnitList.Count-1],1,4)=sDFM_Magic_Stirng
      then UnitList.Delete(UnitList.Count-1);
/////////////////////////////////////////////////////
///// NEW PROJECT HEADER DUMP ENGINE
/////////////////////////////////////////////////////
end;

procedure TDeDeMainForm.ClearDeDeLists;
begin
   DCULV.Items.BeginUpdate;
   DFMList.Items.BeginUpdate;
   EventLV.Items.BeginUpdate;
   ClassesLV.Items.BeginUpdate;
   UnitDataLV.Items.BeginUpdate;
   UnitsDataClassesLV.Items.BeginUpdate;
   DCULV.Items.Clear;
   DFMList.Items.Clear;
   DFMMemo.Clear;
   ClassesLV.Items.Clear;
   EventLV.Items.Clear;
   DFMNameList.Clear;
   PASNameList.Clear;
   PIUL.Clear;
   UnitDataLV.Items.Clear;
   UnitsDataClassesLV.Items.Clear;
   DCULV.Items.EndUpdate;
   DFMList.Items.EndUpdate;
   EventLV.Items.EndUpdate;
   ClassesLV.Items.EndUpdate;
   UnitDataLV.Items.EndUpdate;
   UnitsDataClassesLV.Items.EndUpdate;


   DCULV.Repaint;
   DFMList.Repaint;
   EventLV.Repaint;
   ClassesLV.Repaint;

   ClassLbl.Caption:='';
   ProjectNameLbl.Caption:='';
   DumpStatusLbl.Caption:='';
   VersionLbl.Caption:='';
   FreeOpCodes;

   mpc.ActivePage:=uts;
   Self.Repaint;
end;

procedure TDeDeMainForm.FreeOpCodes;
var i : Integer;
    inst : TStringList;
begin
{  For i:=0 To FOpCodeList.Count-1 Do
    Begin
      inst:=TStringList(FOpCodeList[i]);
      inst.Free;
    End;

  For i:=0 To FControlList.Count-1 Do
    Begin
      inst:=TStringList(FControlList[i]);
      inst.Free;
    End;}
end;


Function GetVersionHash : String; Forward;

Procedure TDeDeMainForm.NewTimerTimer(Sender : TObject);
var LSForm : TLSForm;
    bMR : Longint;
begin
 (Sender as TTimer).Enabled:=False;

  LSForm:=TLSForm.Create(nil);
  Try
    LSForm.ShowModal;
    bMR:=LSForm.ModalResult;
  Finally
    LSForm.Free;
  end;

  if bMR=mrOK then
    begin
     sVersionHash:=FsVersionHash;
     DeDeReg.SaveRegistryData(nil,True);
    end
    else Application.Terminate;
end;

procedure TDeDeMainForm.FormCreate(Sender: TObject);
var RecFile : String;
    f : System.Text;
    ver  : DWORD;
    verMj, verMn : Byte;
    NewTimer : TTimer;
begin
  GlobDeDeINIFileName:=ChangeFileExt(Application.ExeName,'.ini');
  FP.IniFileName:=GlobDeDeINIFileName;
  GlobalDeDeFileName:=Application.ExeName;

  SymbolsToLoad:=TStringList.Create;
  LoadRegistryData(SymbolsToLoad, True);
  LoadResourcesFromIniFile(ExtractFileDir(Application.ExeName)+'\LANGRES\'+sLanguageFile);
  LoadDeDeRES;
  LoadLangMenuItems;

  ClassInfoList:=TStringList.Create;
  RecFile:=ExtractFileDir(Application.ExeName)+'\classes.lst';
  if FileExists(RecFile) then ClassInfoList.LoadFromFile(RecFile);

  FsLoadedDOIFile:='';

  ver:=GetVersion;
  verMj:=(ver and $80000000) shr 32;
  verMn:=(ver and $0000000F);
  if // Windows 2000 or later
     ((verMj<>0) and ((verMn)>4))
     or
     // Windows 98 or later
     (((verMj)=0) and ((verMn)>3)) Then
      begin
        RxGradientCaption1.Active:=False;
      end;


  UnitList:=TStringList.Create;
  StandartDCUList:=TStringList.Create;
  RecFile:=ExtractFileDir(Application.ExeName)+'\su.lst';
  If FileExists(RecFile) then StandartDCUList.LoadFromFile(RecFile);
  DelphiVestionCompability:=0;

  FbLoadDFMInMemo:=True;
  FbMemFump:=False;
  ClassesDumper:=TClassesDumper.Create;
  If ParamCount<>0 Then
     If ParamStr(1)='more' then
         begin
          ClassesLV.OnDblClick:=ClassesLVDblClick;
          DAP.Visible:=True;
          GlobMORE:=True;
          UnitDataLV.PopupMenu:=publh;
         end;
  CheckFolders;

//  FOpCodeList:=TList.Create;
//  FControlList:=TList.Create;
  DFMFormList:=TStringlist.Create;
  DFMNameList:=TStringList.Create;
  PASNameList:=TStringList.Create;
  CurrNames:=TStringList.Create;
  CurrIDs:=TStringList.Create;
  SymbolsPath:=TStringList.Create;

  PEFile:=nil;
  ClearDeDeLists;
  FbProcessed:=False;

  RecFile:=ChangeFileExt(Application.ExeName,'.fls');
  If Not FileExists(RecFile) Then
     Begin
       System.Assign(f,RecFile);
       System.Rewrite(f);
       System.Close(f);
     End;


  RecentFileEdit.Items.LoadFromFile(RecFile);

  LoadedDOIList:=TStringList.Create;
  SymbolsList:=TList.Create;
  Screen.Cursor:=crHourGlass;
  Try
    LoadSymbolFiles;
  Finally
    Screen.Cursor:=crDefault;
  End;

  /////////////////////////////////////
  ///Check For First Time Run
  ///
  FsVersionHash:=GetVersionHash;
  bShowLicense:=FsVersionHash<>sVersionHash;
  if bShowLicense then
    begin
      NewTimer:=TTimer.Create(DeDeMainForm);
      NewTimer.Interval:=3000;
      NewTimer.OnTimer:=NewTimerTimer;
      NewTimer.Enabled:=True;
    end;
  /////////////////////////////////////

  
  ClearTimer.Interval:=5000;
  ClearTimer.Enabled:=False;

  DeDePlugins_Count:=0;
  PlugIn_DASM:=TDisASM.Create;
end;

procedure TDeDeMainForm.FormDestroy(Sender: TObject);
var s : String;
begin
  FreePlugIns;
  PlugIn_DASM.Free;
  ClassInfoList.Free;
  
  ClassesDumper.Free;
  UnitList.Free;
  StandartDCUList.Free;
  If PEFile<>nil Then PEFile.Free;

  FreeOpCodes;
//  FOpCodeList.Free;
//  FControlList.Free;
  DFMFormList.Free;

  DFMNameList.Free;
  PASNameList.Free;
  CurrNames.Free;
  CurrIDs.Free;

  RecentFileEdit.Items.SaveToFile(ChangeFileExt(Application.ExeName,'.fls'));

  FreeSymbolList;
  SymbolsList.Free;
  LoadedDOIList.Free;
  SymbolsToLoad.Free;
  SymbolsPath.Free;

  s:=ExtractFileDir(Application.ExeName)+'\dfm.$$$';
  if FileExists(s) then DeleteFile(s);

  s:=ExtractFileDir(FileEdit.FileName)+'\dfm.$$$';
  if FileExists(s) then DeleteFile(s);
end;


function TDeDeMainForm.PrepareDFM: TMemoryStream;
Var Input  : TMemoryStream;
    beg,en : DWORD;
    b,b2,b1 : Byte;
    i,n : Integer;
begin
  beg:=HEX2DWORD(DFMList.Selected.Subitems[0]);
  If DFMList.Items.IndexOf(DFMList.Selected)=DFMList.Items.Count-1
    Then Begin
      i:=PEHeader.GetSectionIndex('.rsrc');
      if i=-1 Then i:=PEHeader.GetSectionIndexByRVA(PEHeader.RESOURCE_TABLE_RVA);
      {Raise Exception.
           Create('               Unable to show data.'#13+
                  'Original application might have been crypted/packed'#13+
                  'and decrypter/dumper has not changed section names.');}
      en:=PEHeader.Objects[i].PHYSICAL_OFFSET+PEHeader.Objects[i].PHYSICAL_SIZE;
    End
    Else Begin
      i:=DFMList.Items.IndexOf(DFMList.Selected)+1;
      en:=HEX2DWORD(DFMList.Items[i].Subitems[0]);
    End;
  Input:=TMemoryStream.Create;
  b:=$FF;Input.WriteBuffer(b,1);
  b:=$0A;Input.WriteBuffer(b,1);
  b:=$00;Input.WriteBuffer(b,1);
  For i:=1 To Length(DFMList.Selected.Caption) Do
    Begin
      b:=ORD((ANSIUpperCase(DFMList.Selected.Caption)[i]));
      Input.WriteBuffer(b,1);
      n:=i;
    End;
  // Changed because of a Warning
  b:=$00;Input.WriteBuffer(b,1);
  b:=$30;Input.WriteBuffer(b,1);
  b:=$10;Input.WriteBuffer(b,1);
  // Changed because of a Warning
  // Original was:
  //b1:=Lo(en-beg-Length(DFMList.Selected.Caption[i]));
  b1:=Lo(en-beg-Length(DFMList.Selected.Caption[n]));
  Input.WriteBuffer(b1,1);
  // Changed because of a Warning
  // Original was:
  //b1:=Lo(en-beg-Length(DFMList.Selected.Caption[i]));
  b2:=Hi(en-beg-Length(DFMList.Selected.Caption[n]));
  Input.WriteBuffer(b2,1);
  b:=$00;Input.WriteBuffer(b,1);
  b:=$00;Input.WriteBuffer(b,1);
  PEFile.PEStream.Seek(beg,soFromBeginning);
  For i:=beg to en-1 Do
    Begin
      PEFile.PEStream.ReadBuffer(b,1);
      Input.WriteBuffer(b,1);
    End;
  b:=$00;Input.WriteBuffer(b,1);
  b:=$00;Input.WriteBuffer(b,1);
  Input.Seek(0,soFromBeginning);
  Result:=Input;
end;

procedure TDeDeMainForm.DCULVClick(Sender: TObject);
Var i : Integer;
    ListItem : TListItem;
    ClsDmp : TClassDumper;
    MethRec : TMethodRec;
    FldRec : TFieldRec;
begin
  If DCULV.Selected=nil Then Exit;

  // New Handler
  ClsDmp:=TClassDumper(DCULV.Selected.Data);

  EventLV.Items.BeginUpdate;
  ControlsLV.Items.BeginUpdate;
  EventLV.Items.Clear;
  ControlsLV.Items.Clear;
  Try
    ClassLbl.Caption:=ClsDmp.FsClassName;

    For i:=0 to ClsDmp.MethodData.Count-1 Do
      Begin
        // Adding Event Handler Data
        MethRec:=TMethodRec(ClsDmp.MethodData.Methods[i]);
        ListItem:=EventLV.Items.Add;
        ListItem.Caption:=MethRec.sName;
        ListItem.SubItems.Add(IntToHex(MethRec.dwRVA,8));
        ListItem.SubItems.Add(IntToHex(MethRec.wFlag,4));
      End;

    For i:=0 to ClsDmp.FieldData.Count-1 Do
      Begin
        // Adding Controls Data
        FldRec:=TFieldRec(ClsDmp.FieldData.Fields[i]);
        ListItem:=ControlsLV.Items.Add;
        ListItem.Caption:=FldRec.sName;
        ListItem.SubItems.Add(IntToHex(FldRec.dwID,8));
      End;
   Finally
      EventLV.Items.EndUpdate;
      ControlsLV.Items.EndUpdate;
   End;
end;


procedure TDeDeMainForm.DCULVDblClick(Sender: TObject);
Var i : Integer;
begin
  i:=PASNameList.IndexOf(DCULv.Selected.Caption);
  ShowMessage(TStringList(FOpCodeList[i]).Text);
end;

procedure TDeDeMainForm.puCopyRVAtoclipboardClick(Sender: TObject);
begin
  if EventLV.Selected=nil then Exit;
  Clipboard.AsText:=EventLV.Selected.Subitems[0];
end;



procedure TDeDeMainForm.puSaveasDFMClick(Sender: TObject);
var Input : TMemoryStream;
    s : String;
Begin
  if Not FbProcessed Then Exit;
  s:=GetLVFromClassName+'.dfm';
  Input:=PrepareDFM;
  Try
    If CheckFile(s) Then Begin
        Input.SaveToFile(s);
        ShowMessage(s+msg_filesaved);
    End;
  Finally
    If Input<>nil Then Input.Free;
  End;
end;

procedure TDeDeMainForm.puSaveasRCClick(Sender: TObject);
var Input : TMemoryStream;
    I,O : TFileStream;
    s : String;
Begin
  if Not FbProcessed Then Exit;
  s:=GetLVFromClassName+'.res';
  Input:=PrepareDFM;
  Try
    DeDePAS.Convert(Input,'');
    I:=TFileStream.Create('dfm.$$$',fmOpenRead);
    O:=TFileStream.Create(s,fmCreate);
    Try
      If CheckFile(s) Then
        Begin
          ObjectTextToResource(I,O);
          ShowMessage(s+msg_filesaved);
        End;
    Finally
      I.Free;
      O.Free;
    End;
  Finally
    If Input<>nil Then Input.Free;
  End;
end;

procedure TDeDeMainForm.puOpenwithnotepadClick(Sender: TObject);
begin
  puViewastextClick(self);
  //ExecuteFile('notepad.exe','dfm.$$$','',1);
end;

procedure TDeDeMainForm.puViewastextClick(Sender: TObject);
var blah : TStringList;
begin
  if Not FbProcessed Then Exit;
  blah:=ClassesDumper.GetDFMTXTDATA(GetLVFromClassName);
  blah.SaveToFile(FsTEMPDir+'\dfm.$$$');
  ExecuteFile('notepad.exe',FsTEMPDir+'\dfm.$$$','',1);
  ExecuteFile('notepad.exe','dfm.$$$','',1);
end;

procedure TDeDeMainForm.puSaveasTXTClick(Sender: TObject);
var s : String;
    tmp : TStringList;
begin
  if Not FbProcessed Then Exit;
  s:=GetLVFromClassName+'.txt';
  Try
    If CheckFile(s) Then
      Begin
       //CopyFile('dfm.$$$',s);
       tmp:=ClassesDumper.GetDFMTXTDATA(GetLVFromClassName);
       if tmp=nil then exit;
       tmp.SaveToFile(s);
       ShowMessage(s+msg_filesaved);
      End;
  Except
    Raise;
  End;
end;

function TDeDeMainForm.GetLVFromClassName: String;
begin
  Result:='notfound';
  If DFMList.Selected=nil Then Exit;
//  Result:=DFMList.Items[DFMList.Items.IndexOf(DFMList.Selected)].Caption;
  Result:=DFMList.Selected.Caption;
end;

procedure TDeDeMainForm.DFMListChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var blah : TStringList;
Begin
  If DFMList.Selected=nil Then Exit;

  blah:=DeDeMainForm.ClassesDumper.GetDFMTXTDATA(DFMList.Selected.Caption);
  if blah=nil then exit;

  Try
   Screen.Cursor:=crHourGlass;
   Try
     If FbLoadDFMInMemo Then DFMMemo.Lines.Assign(blah);
   Finally
     Screen.Cursor:=crDefault;
   End;
  Except
     On e : Exception Do
      If e.Message=err_text_exceeds Then
        Begin
          DFMMemo.Clear;
          If MessageDlg(msg_notepad_offer,
             mtConfirmation,[mbYes,mbNo],0)=mrNo Then Exit;
          blah.SaveToFile(FsTEMPDir+'\dfm.$$$');
          ExecuteFile('notepad.exe',FsTEMPDir+'\dfm.$$$','',1);
          DeleteTimer.Enabled:=True;
        End
        Else Raise;
  End;
end;

procedure TDeDeMainForm.Showmoredata1Click(Sender: TObject);
Var TmpList : TStringList;
    Input : TMemoryStream;
    sClass,sEvent,s,sRes : String;
    beg,en : DWORD;
    b,b2,b1 : Byte;
    i,iIndex,iPos,n : Integer;
    bFound : Boolean;
begin
  if Not FbProcessed Then Exit;
  If EventLV.Selected=nil Then Exit;
  sEvent:=EventLV.Items[EventLV.Items.IndexOf(EventLV.Selected)].Caption;
  sClass:=ClassLbl.Caption;
  For i:=0 To DFMList.Items.Count-1 Do
    If DFMList.Items[i].Caption=sClass Then Break;
  iIndex:=i;
  If i>DFMList.Items.Count-1 Then Raise Exception.Create(err_invalid_dfm_index);

  beg:=HEX2DWORD(DFMList.Items[iIndex].Subitems[0]);

  If i=DFMList.Items.Count-1
    Then Begin
      i:=PEHeader.GetSectionIndex('.rsrc');
      if i=-1 Then i:=PEHeader.GetSectionIndexByRVA(PEHeader.RESOURCE_TABLE_RVA);
      { Raise Exception.
           Create('               Unable to show data.'#13+
                  'Original application might have been crypted/packed'#13+
                  'and decrypter/dumper has not changed section names.');}
      en:=PEHeader.Objects[i].PHYSICAL_OFFSET+PEHeader.Objects[i].PHYSICAL_SIZE;
    End
    Else Begin
      i:=iIndex+1;
      en:=HEX2DWORD(DFMList.Items[i].Subitems[0]);
    End;

    Input:=TMemoryStream.Create;
    TmpList:=TStringList.Create;
    Try
      b:=$FF;Input.WriteBuffer(b,1);
      b:=$0A;Input.WriteBuffer(b,1);
      b:=$00;Input.WriteBuffer(b,1);
      For i:=1 To Length(DFMList.Items[iIndex].Caption) Do
        Begin
          b:=ORD((ANSIUpperCase(DFMList.Items[iIndex].Caption)[i]));
          Input.WriteBuffer(b,1);
          n:=i;
        End;
      b:=$00;Input.WriteBuffer(b,1);
      b:=$30;Input.WriteBuffer(b,1);
      b:=$10;Input.WriteBuffer(b,1);
      // changed because of a warning
      // original was:
      //b1:=Lo(en-beg-Length(DFMList.Items[iIndex].Caption[i]));
      b1:=Lo(en-beg-Length(DFMList.Items[iIndex].Caption[n]));
      Input.WriteBuffer(b1,1);
      b2:=Hi(en-beg-Length(DFMList.Items[iIndex].Caption[n]));
      Input.WriteBuffer(b2,1);
      b:=$00;Input.WriteBuffer(b,1);
      b:=$00;Input.WriteBuffer(b,1);
      PEFile.PEStream.Seek(beg,soFromBeginning);
      For i:=beg to en-1 Do
        Begin
          PEFile.PEStream.ReadBuffer(b,1);
          Input.WriteBuffer(b,1);
        End;
      b:=$00;Input.WriteBuffer(b,1);
      b:=$00;Input.WriteBuffer(b,1);
      Input.Seek(0,soFromBeginning);

      // Not needed anymore
      //DeDePAS.Convert(Input,'');
      //TmpList.LoadFromFile('dfm.$$$');
      TmpList.Assign(ClassesDumper.GetDFMTXTDATA(sClass));

      sRes:='';
      bFound:=False;
      iIndex:=0;
      For i:=0 To TmpList.Count-1 Do
        Begin
          s:=TmpList[i];
          If Pos(sEvent,s)<>0 Then
            Begin
              iIndex:=i;
              TruncAll(s);
              iPos:=Pos(' = ',s);
              sRes:='Event = '+Copy(s,1,iPos-1)+#13#10;
              bFound:=True;
              Break;
            End;
        End;


      For i:=iIndex DownTo 0 Do
        Begin
          s:=TmpList[i];
          TruncAll(s);
          If Copy(s,1,7)='object ' Then
             Begin
               iPos:=Pos(':',s);
               sRes:=sRes+'Owner = '+Copy(s,8,iPos-8)+'('+Copy(s,iPos+2,Length(s)-iPos)+')'#13#10;
               Break;
              End;
        End;

      For i:=iIndex DownTo 0 Do
        Begin
          s:=TmpList[i];
          TruncAll(s);
          If Copy(s,1,10)='Caption = ' Then
             Begin
               sRes:=sRes+s;
               Break;
              End;
        End;

      For i:=iIndex DownTo 0 Do
        Begin
          s:=TmpList[i];
          TruncAll(s);
          If Copy(s,1,10)='Text = ' Then
             Begin
               sRes:=sRes+s;
               Break;
              End;
        End;

     If Not bFound
       Then sRes:=Format(msg_novice_delphi_programmer
                         ,[sEvent])
       Else sRes:=sEvent+#13#10#13#10+sRes;

     ShowMessage(sRes);

    Finally
      Input.Free;
      TmpList.Free;
    End;
end;


procedure TDeDeMainForm.crtBtnClick(Sender: TObject);
Var sDir,s, sUnit, sEvent, sForm, sDeclr, sImpl : String;
    sr : TSearchRec;
    dfmList, pasList,tmpList, DasmList : TStringList;
    i, j,k, iEvent : Integer;
    Input : TMemoryStream;
    tick1,tick2 : Cardinal;
begin
  If (Not FbProcessed) or (FbFailed) Then Exit;
  If FbSavedProject Then
    Begin
      ShowMessage(err_unabletogenproj);
      Exit;
    End;
  sDir:=DirEdit.Text;
  Try
    If FindFirst(sDir,faDirectory,sr)<>0 Then
      Begin
        ShowMessage(Format(err_dir_not_found,[sDir]));
        Exit;
      End;

    If FindFirst(sDir+'\'+ProjectNameLbl.Caption,faDirectory,sr)=0 Then
      If DeDeReg.bNOT_ALLOW_EXISTING_DIR Then
        Begin
          ShowMessage(Format(err_dir_not_exist,[sDir+'\'+ProjectNameLbl.Caption]));
          Exit;
        End;
    sDir:=sDir+'\'+ProjectNameLbl.Caption;
    CreateDir(ProjectNameLbl.Caption);
    SetCurrentDir(sDir);
   Finally
    FindClose(sr);
  End;

Screen.Cursor:=crHourGlass;
DeDeDisAsm.bErrorsAsFile:=True;
DeDeDisAsm.sDisAsmErrors:='';
Try

  StsBar.Panels[1].Text:=msg_saving_project;
  StsBar.Update;
  Application.ProcessMessages;

  tick1:=GetTickCount;
  tick2:=tick1;
  Try
  dfmList:=TStringList.Create;
  pasList:=TStringList.Create;
  tmpList:=TStringList.Create;
  Try
   AssignDeDeDisAsms;
   DeDeDisASM.PEStream:=PEFile.PEStream;
   DeDeDisASM.RVAConverter.ImageBase:=PEHeader.IMAGE_BASE;
   DeDeDisASM.RVAConverter.PhysOffset:=PEHeader.Objects[1].PHYSICAL_OFFSET;
   DeDeDisASM.RVAConverter.CodeRVA:=PEHeader.Objects[1].RVA;

   Try
    For i:=0 To DCULV.Items.Count-1 Do
      begin
        pasList.Add(DCULV.Items[i].Caption);
        tmpList.Add(DCULV.Items[i].Subitems[0]);
      end;


    With DeDeMainForm.DFMList Do
     Begin
        For i:=0 To Items.Count-1 Do
          If tmpList.IndexOf(Items[i].Caption)=-1
            Then dfmList.Add(Items[i].Caption);
     End;

    SavePB.Max:=3+Self.DFMList.Items.Count;
    SavePB.Position:=0;
    SavePB.Update;
    // Include TXT event handler RVA description
    If cbTXT.Checked Then
      Begin
        s:=sDir+'\events.txt';
        SaveEventHanlderDataInFile(s);
      End;
    SavePB.Position:=1;
    SavePB.Update;


    // Include DPR project file
    If cbDPR.Checked Then
      Begin
        InitNewEmulation('','','','');
        If CheckFile(sDir+'\'+ProjectNameLbl.Caption+'.dpr') Then
        //DeDeDisASM.PEHeader:=PEHeader;
        GenerateDPR(ProjectNameLbl.Caption,
                    sDir+'\'+ProjectNameLbl.Caption+'.dpr',
                    UnitList,
                    DFMNameList,
                    PEHeader.RVA_ENTRYPOINT-
                    PEHeader.Objects[1].RVA+
                    PEHeader.Objects[1].PHYSICAL_OFFSET,
                    PEHeader.RVA_ENTRYPOINT+
                    PEHeader.IMAGE_BASE);
      End;
     SavePB.Position:=2;
     SavePB.Update;


    // Include DFM files for all forms
    If cbDFM.Checked Then
      Begin
       Try
        Self.DFMList.OnChange:=nil;
        For i:=0 To Self.DFMList.Items.Count-1 Do
          Begin
            s:=Self.DFMList.Items[i].Caption;
            Self.DFMList.Selected:=Self.DFMList.Items[i];
            If tmpList.IndexOf(s)=-1
              Then s:=sDir+'\'+s+'.dfm'
              Else s:=sDir+'\'+pasList[tmpList.IndexOf(s)]+'.dfm';
              Input:=PrepareDFMByIndex(i);
              If CheckFile(s) Then Input.SaveToFile(s);
              Input.Free;
          End;
        Finally
          Self.DFMList.OnChange:=DFMListChange;
        End;
      End;
     SavePB.Position:=3;
     SavePB.Update;


    // Include PAS files
    If cbPAS.Checked Then
      Begin
        DeDeDisAsm.PASNameList:=PASNameList;
        DeDeDisAsm.FOpCodeList:=FOpCodeList;
        DeDeDisAsm.DFMNameList:=DFMNameList;
        DeDeDisAsm.PEStream:=PEFile.PEStream;
        //DeDeDisAsm.PEHeader:=PEHeader;
        DeDeDisAsm.RVAConverter.ImageBase:=PEHeader.IMAGE_BASE;

        if bELF then begin
           DeDeDisAsm.RVAConverter.PhysOffset:=PEHeader.Objects[PEHeader.GetSectionIndex('.text')].PHYSICAL_OFFSET;
           DeDeDisAsm.RVAConverter.CodeRVA:=PEHeader.Objects[PEHeader.GetSectionIndex('.text')].RVA;
        end
        else begin
           DeDeDisAsm.RVAConverter.PhysOffset:=PEHeader.Objects[1].PHYSICAL_OFFSET;
           DeDeDisAsm.RVAConverter.CodeRVA:=PEHeader.Objects[1].RVA;
        end;

        {THE OLD METHOD}
      {  For i:=0 To Self.DFMList.Items.Count-1 Do
          Begin
            s:=Self.DFMList.Items[i].Caption;
            DeDeDisAsm.ClsDmp:=ClassesDumper.GetClass(s);
            If DeDeDisAsm.ClsDmp=nil Then continue;
            If tmpList.IndexOf(s)=-1
              Then s:=sDir+'\'+s+'.pas'
              Else Begin
                //CurrControlList:=TStringList(FControlList[GetDCUIndex(s)]);
                s:=sDir+'\'+pasList[tmpList.IndexOf(s)]+'.pas';
              End;

              self.DFMList.OnChange:=nil;
              Try
                self.DFMList.Selected:=self.DFMList.Items[i];
              Finally
                self.DFMList.OnChange:=DFMListChange;
              End;

              Input:=PrepareDFMByIndex(i,false);
              Try
              If CheckFile(s) Then DeDePas.GeneratePas(Input,s,'','');
              Except
              End;
              Input.Free;

              SavePB.Position:=4+i;
              SavePB.Update;
          End;}


        {THE NEW METHOD}
        For i:=0 To Self.DCULV.Items.Count-1 Do
          Begin
            sForm:=Self.DCULV.Items[i].Subitems[0];
            DeDeDisAsm.ClsDmp:=ClassesDumper.GetClass(sForm);
            If DeDeDisAsm.ClsDmp=nil Then continue;

            self.DCULV.Selected:=self.DCULV.Items[i];
            sUnit:=DCULV.Selected.Caption;
            DeDePas.StartNewPas(Input,sUnit);

            currUnitLbll.Caption:='processing '+sUnit+'.pas';
            currUnitLbll.Update;

            sDeclr:='type'#13#10'  '+sForm+'=class(TForm)'#13#10;
            sImpl:='  private'#13#10'    { Private declarations }'#13#10'  public'#13#10'    { Public declarations }'#13#10'  end ;'#13#10+
                   #13#10+'var'#13#10'  '+Copy(sForm,2,Length(sForm)-1)+': '+sForm+';'#13#10#13#10+
                   '{This file is generated by DeDe Ver '+GlobsCurrDeDeVersion+' Copyright (c) 1999-2002 DaFixer}'#13#10#13#10+
                   'implementation'#13#10#13#10'{$R *.DFM}'#13#10#13#10;

            for j:=0 to DeDeDisAsm.ClsDmp.FieldData.Count-1 do
              begin
                sEvent:=TFieldRec(DeDeDisAsm.ClsDmp.FieldData.Fields[j]).sName;
                s:=GetControlClassEx(sForm,sEvent);
                sDeclr:=sDeclr+'    '+sEvent+': '+s+';'#13#10;
              end;

            for j:=0 to DeDeDisAsm.ClsDmp.MethodData.Count-1 do
              begin
                sEvent:=TMethodRec(DeDeDisAsm.ClsDmp.MethodData.Methods[j]).sName;
                currUnitLbll.Caption:='processing '+sUnit+'.'+sEvent;
                currUnitLbll.Update;
                s:=GetEventPrototype(sForm,sEvent);
                iEvent:=Pos('(',s);
                sDeclr:=sDeclr+'    '+Copy(s,1,iEvent-1)+' '+sEvent+Copy(s,iEvent,Length(s)-iEvent+1)+#13#10;
                DisassembleProc(sUnit,sEvent,DasmList,False);
                sImpl:=sImpl+Copy(s,1,iEvent-1)+' '+sForm+'.'+sEvent+Copy(s,iEvent,Length(s)-iEvent+1)+#13#10'begin'#13#10
                +'(*'#13#10+DasmList.Text+'*)'#13#10'end;'#13#10#13#10;
                //For k:=0 to DasmList.Count-1 do sImpl:=sImpl+'//  '+DasmList[k]+#13#10;
                DasmList.Free;
              end;

              sImpl:=sImpl+'end.';
              Input.WriteBuffer(sDeclr[1],Length(sDeclr));
              Input.WriteBuffer(sImpl[1],Length(sImpl));

              s:=sDir+'\'+sUnit+'.pas';

              If CheckFile(s) Then Input.SaveToFile(s);

              SavePB.Position:=4+i;
              SavePB.Update;
          End;
      End;

    tick2:=GetTickCount;
    if DeDeDisAsm.sDisAsmErrors<>'' then
      begin
        with TStringList.Create do
          begin
            Text:=DeDeDisAsm.sDisAsmErrors;
            SaveToFile(sDir+'\'+ProjectNameLbl.Caption+'.err.txt');
          end;
        ShowMessage('Done with errors. Errors saved in '+ProjectNameLbl.Caption+'.err.txt');  
      end
      else ShowMessage(msg_save_complete);
    SavePB.Position:=0;
    SavePB.Update;
    currUnitLbll.Caption:='';
    currUnitLbll.Update;

    Except
      On E:Exception Do
        ShowMessage(E.Message);
    End;
  Finally
    dfmList.Free;
    pasList.Free;
  End;
  Finally
    StsBar.Panels[1].Text:=Format(msg_ready_secs,[IntToStr(Trunc((tick2-tick1)/1000))]);
  End;
Finally
 DeDeDisAsm.bErrorsAsFile:=False; 
 Screen.Cursor:=crDefault;
End;
end;

function TDeDeMainForm.IsDelphiApp: Boolean;
const sBoolean = '07426F6F6C65616E';
var b : byte;
    s : String;
    i : Integer;
begin
  GlobCBuilder:=False;
  PEFile.PEStream.Seek(PEHeader.Objects[1].PHYSICAL_OFFSET+5,soFromBeginning);
  s:='';
  For i:=1 To Length(sBoolean) div 2 Do
   Begin
     PEFile.PEStream.ReadBuffer(b,1);
     s:=s+Byte2HEX(b);
   End;

  FbCutSelfPtr:=False;
  Result:=s=sBoolean;

  If Result Then Exit;

  // CUT SELF POINTER CASE - Delphi 2
  PEFile.PEStream.Seek(PEHeader.Objects[1].PHYSICAL_OFFSET+1,soFromBeginning);
  s:='';
  For i:=1 To Length(sBoolean) div 2 Do
   Begin
     PEFile.PEStream.ReadBuffer(b,1);
     s:=s+Byte2HEX(b);
   End;
  FbCutSelfPtr:=s=sBoolean;
  If FbCutSelfPtr Then Exit;

  // BCB CASE
  s:=GetDelphiVersion(PEFile);

  if (s='<check failed>') then
    begin
      // Run time packages
      Result:=False;
      Exit;
    end;

  if (s<>'<unknown version>') then
    begin
      GlobCBuilder:=True;
      Result:=True;
      Exit;
    end;

end;

procedure TDeDeMainForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TDeDeMainForm.About1Click(Sender: TObject);
begin
//  Asm2PasForm.Show;
  AboutBox.ShowModal;
end;

procedure TDeDeMainForm.RVAconverter1Click(Sender: TObject);
begin
  ConverterForm.Show;
end;

procedure TDeDeMainForm.SaveEventHanlderDataInFile(FsFileName : String);
Var AiIndex,i : Integer;
    inst : TClassDumper;
    mr : TMethodRec;
    s : String;
    f : System.Text;
begin
  System.Assign(f,FsFileName);
  System.ReWrite(f);
  Try
    System.WriteLn(f,txt_copyright);
    System.WriteLn(f,'');
    For Aiindex:=0 To ClassesDumper.Classes.Count-1 Do
     Begin
      inst:=TClassDumper(ClassesDumper.Classes[AiIndex]);
      if inst.MethodData.Count=0 then continue;
      s:=inst.FsUnitName+#13#10;
      System.WriteLn(f,s);
      For i:=0 to inst.MethodData.Count-1 Do
        Begin
          mr:=TMethodRec(inst.MethodData.Methods[i]);
          s:=inst.FsClassName+'.'+mr.sName; While Length(s)<65 do s:=s+' ';
          s:=s+IntToHex(mr.dwRVA,8);
          If mr.wFlag<>0 Then
             System.WriteLn(f,s);
        End;
      s:=#13#10#13#10;
      System.WriteLn(f,s);
      End;
    Finally
    System.Close(f);
  End;
           
end;

procedure TDeDeMainForm.puSaveeventsRVAsastextClick(Sender: TObject);
Var s : String;
begin
  if Not FbProcessed Then Exit;
  s:=ChangeFileExt(FileEdit.FileName,'.txt');
  SaveEventHanlderDataInFile(s);
  ShowMessage(s+msg_filesaved);
end;

function TDeDeMainForm.PrepareDFMByIndex(AiIndex : Integer; bIncludeDFMHeader : Boolean = True) : TMemoryStream;
Var Input  : TMemoryStream;
    beg,en : DWORD;
    b,b2,b1 : Byte;
    i,n : Integer;
begin
  beg:=HEX2DWORD(DFMList.Items[AiIndex].Subitems[0]);
  If DFMList.Items.IndexOf(DFMList.Selected)=DFMList.Items.Count-1
    Then Begin
      i:=PEHeader.GetSectionIndex('.rsrc');
      if i=-1 Then i:=PEHeader.GetSectionIndexByRVA(PEHeader.RESOURCE_TABLE_RVA);
      en:=PEHeader.Objects[i].PHYSICAL_OFFSET+PEHeader.Objects[i].PHYSICAL_SIZE;
    End
    Else Begin
      i:=DFMList.Items.IndexOf(DFMList.Selected)+1;
      en:=HEX2DWORD(DFMList.Items[i].Subitems[0]);
    End;
  Input:=TMemoryStream.Create;
  
  If bIncludeDFMHeader Then
    Begin
    b:=$FF;Input.WriteBuffer(b,1);
    b:=$0A;Input.WriteBuffer(b,1);
    b:=$00;Input.WriteBuffer(b,1);
    For i:=1 To Length(DFMList.Items[AiIndex].Caption) Do
      Begin
        b:=ORD((ANSIUpperCase(DFMList.Items[AiIndex].Caption)[i]));
        Input.WriteBuffer(b,1);
        n:=i;
      End;
    b:=$00;Input.WriteBuffer(b,1);
    b:=$30;Input.WriteBuffer(b,1);
    b:=$10;Input.WriteBuffer(b,1);
    // Changed because of a warning
    // original was:
    //b1:=Lo(en-beg-Length(DFMList.Items[AiIndex].Caption[i]));
    b1:=Lo(en-beg-Length(DFMList.Items[AiIndex].Caption[n]));
    Input.WriteBuffer(b1,1);
    b2:=Hi(en-beg-Length(DFMList.Items[AiIndex].Caption[i]));
    Input.WriteBuffer(b2,1);
    b:=$00;Input.WriteBuffer(b,1);
    b:=$00;Input.WriteBuffer(b,1);
  End;

  PEFile.PEStream.Seek(beg,soFromBeginning);
  For i:=beg to en-1 Do
    Begin
      PEFile.PEStream.ReadBuffer(b,1);
      Input.WriteBuffer(b,1);
    End;
  b:=$00;Input.WriteBuffer(b,1);
  b:=$00;Input.WriteBuffer(b,1);
  Input.Seek(0,soFromBeginning);
  Result:=Input;
end;

procedure TDeDeMainForm.ASM1Click(Sender: TObject);
begin
  ASMForm.Show;
end;

procedure TDeDeMainForm.MorePEinfo1Click(Sender: TObject);
var bBackUp : Boolean;
begin
 { If DeDeMainForm.FbProcessed  Then
     If MessageDlg(msg_peedit_offer,
         mtConfirmation,[mbYes,mbNo],0)=mrYes Then
       Begin
         PEIForm.FsFileName:=FsFileName;
         PEIForm.PEHeader:=PEHeader;
         PEIForm.PEFile:=PEFile;
         PEIForm.ShowModal;
         Exit;
       End;
  }
{  If OpenDlg.Execute Then Begin
   Try
     PEFile.Free;
     PEFile:=ThePEFile.Create(OpenDlg.FileName);
     PEHeader.Dump(Self.PEFile);
     PEIForm.FsFileName:=OpenDlg.FileName;
     PEIForm.PEHeader:=PEHeader;
     PEIForm.PEFile:=DeDeClasses.PEFile;
     PEIForm.ShowModal;
   Finally
     // Restores Original PE File for furder use
     PEFile.Free;
     PEFile:=nil;
     If FileExists(FsFileName) Then
       Begin
        PEFile:=ThePEFile.Create(FsFileName);
        PEHeader.Dump(Self.PEFile)
       End;
   End;
  End;}

  If FbProcessed then
    If MessageDlg('This operation will affect the currently processed target! Do you want ot continue?',mtWarning,[mbYes,mbNo],0)=mrNo then Exit;

  If OpenDlg.Execute Then Begin
   Try
     bBackUp:=bElf;
     PEFile.Free;
     PEFile:=ThePEFile.Create(OpenDlg.FileName);
     if PEHeader=nil then PEHeader:=TPEHeader.Create;
     PEHeader.Dump(PEFile);

     PEIForm.FsFileName:=OpenDlg.FileName;

     PEIForm.PEHeader:=PEHeader;
     PEIForm.PEFile:=PEFile;
     PEIForm.ShowModal;
   Finally
     bElf:=bBackUp;
   End;
  End;
end;

procedure TDeDeMainForm.Disassemble1Click(Sender: TObject);
Var sUnit,sEvent,s : String;
    DasmList : TStringList;
    node : TTreeNode;
    i : Integer;
begin
   if Not FbProcessed Then Exit;
   If EventLV.Selected=nil Then Exit;
   If DCULv.Selected=nil then Raise Exception.Create('Select Unit/Class first');

   Screen.Cursor:=crHourGlass;
   Try
     sUnit:=DCULV.Selected.Caption;
     sEvent:=EventLV.Selected.Caption;

     AssignDeDeDisAsms;

     DeDeDisAsm.ClsDmp:=nil;
     DeDeDisAsm.ClsDmp:=ClassesDumper.GetClass(ClassLbl.Caption);
     if DeDeDisAsm.ClsDmp=nil Then Raise Exception.Create(err_class_not_found);
     DisassembleProc(sUnit,sEvent,DasmList,False);
   Finally
     Screen.Cursor:=crDefault;
   End;

   ASMShowForm.ASMList.Clear;
   ASMShowForm.Caption:=ClassLbl.Caption+'.'+sEvent;
   ASMShowForm.ProcCB.Clear;
   ASMShowForm.ProcCB.Items.Add(ASMShowForm.Caption);
   ASMShowForm.ProcCB.ItemIndex:=0;
   ASMShowForm.ProcRVA.Clear;
   ASMShowForm.ProcRVA.Items.Add(EventLV.Selected.SubItems[0]);
   ASMShowForm.ProcTree.Items.Clear;
   node:=ASMShowForm.ProcTree.Items.AddChildFirst(nil,ClassLbl.Caption+'.'+sEvent);
   node.ImageIndex:=1;

   ASMShow.AddCommentsToListing(DasmList, ProcRVA);
   if bModalAsmShow
     then ASMShowForm.ShowModal
     else ASMShowForm.Show;
   // Frees Disassembly Result String List
   DasmList.Free;
end;

procedure TDeDeMainForm.DisassembleProc1Click(Sender: TObject);
var s,ss : String;
    DasmList : TStringList;
    node : TTreeNode;
    i : Integer;
begin
  If Not FbProcessed Then Raise Exception.Create(err_nothing_processed);

  If Not InputQuery(txt_disassemble_proc,txt_begin_rva,s)
     Then Exit;
  s:=UpperCase(s);
  if not bELF then
  If Not OffsetInSegment(HEX2DWORD(s),'CODE')
     Then Raise Exception.Create(err_rva_not_in_CODE);

   //DeDeDisAsm.PEHeader:=DeDeClasses.PEHeader;
   DeDeDisAsm.PEStream:={BOZA DeDeClasses.}PEStream;
   DeDeDisAsm.RVAConverter.ImageBase:=PEHeader.IMAGE_BASE;
   if bELF then begin
       DeDeDisAsm.RVAConverter.PhysOffset:=PEHeader.Objects[PEHeader.GetSectionIndex('.text')].PHYSICAL_OFFSET;
       DeDeDisAsm.RVAConverter.CodeRVA:=PEHeader.Objects[PEHeader.GetSectionIndex('.text')].RVA;
    end
    else begin
       DeDeDisAsm.RVAConverter.PhysOffset:=PEHeader.Objects[1].PHYSICAL_OFFSET;
       DeDeDisAsm.RVAConverter.CodeRVA:=PEHeader.Objects[1].RVA;
    end;
   ss:=RVAConverter.GetPhys(s);
   DeDeDisAsm.RVAConverter:=DeDeDisAsm.RVAConverter;
   PEStream.Seek(HEX2DWORD(ss),soFromBeginning);

   InitNewEmulation('','','','');
   DeDeDisAsm.ControlNames.Clear;
   DeDeDisAsm.ControlIDs.Clear;
   DeDeDisAsm.UnitList.Clear;
   
   Screen.Cursor:=crHourGlass;
   Try
     DisassembleProc('','',DasmList,False,True);

     ASMShowForm.ProcCB.Clear;
     ASMShowForm.ProcCB.Items.Add(ASMShowForm.Caption);
     ASMShowForm.ProcCB.ItemIndex:=0;
     ASMShowForm.ProcRVA.Clear;
     ASMShowForm.ProcRVA.Items.Add(s);
     ASMShowForm.ProcTree.Items.Clear;
     node:=ASMShowForm.ProcTree.Items.AddChildFirst(nil,'UserProc_'+s);
     node.ImageIndex:=1;

     ASMShowForm.ASMList.Clear;
     ASMShowForm.Caption:='UserProc_'+s;
     AddCommentsToListing(DasmList,HEX2DWORD(s));
{
     For i:=0 To DasmList.Count-1 Do
      Begin
        s:=DasmList[i];
        While Pos(#13#10,s)<>0 Do
          Begin
             ASMShowForm.ASMList.Items.Add(Copy(s,1,Pos(#13#10,s)-1));
             s:=Copy(s,Pos(#13#10,s)+2,Length(s)-Pos(#13#10,s));
          End;
        ASMShowForm.ASMList.Items.Add(s);
      End;
}
   Finally
      Screen.Cursor:=crDefault;
   End;

   if bModalAsmShow
     then ASMShowForm.ShowModal
     else ASMShowForm.Show;
   // Frees Disaasembly Result String List
   DasmList.Free;
end;

procedure TDeDeMainForm.Preferences1Click(Sender: TObject);
begin
  PrefsForm.ShowModal;
end;


procedure TDeDeMainForm.PrcsBtnMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  bDebug:=ssShift in Shift;
  bUserProcs:=[ssALT,ssShift,ssCtrl] - Shift = [ssLeft];
end;

{TO BE USED IN FUTURE}
{Procedure TDeDeMainForm.ShowAPISPY;
Begin
  StsBar.Panels[0].Text:='Loading Imports ...';
  StsBar.Update;
  StsBar.Refresh;
  Application.ProcessMessages;
  Screen.Cursor:=crHourGlass;
  Try
    ASMainForm.PrepareImports;
  Finally
    StsBar.Panels[0].Text:='Ready';
    Screen.Cursor:=crDefault;
  End;

  Try
    DeDeMainForm.Visible:=False;
    ASMainForm.AsFileName:=FsFileName;
    ASMainForm.ShowModal;
  Finally
    DeDeMainForm.Visible:=True;
  End;
End;}


procedure TDeDeMainForm.APIHooker1Click(Sender: TObject);
begin
{  If DeDeMainForm.FbProcessed  Then
     If MessageDlg('Do you want to open in API Spy the current project ?',
         mtConfirmation,[mbYes,mbNo],0)=mrYes Then
       Begin
         PEIForm.PEFile:=PEFile;
         PEIForm.PEHeader:=PEHeader;
         ShowAPISPY;
         Exit;
       End;

  If OpenDlg.Execute Then Begin
   Try
     PEFile.Free;
     PEFile:=ThePEFile.Create(OpenDlg.FileName);
     PEHeader.Dump(PEFile);
     PEIForm.PEFile:=PEFile;
     PEIForm.PEHeader:=PEHeader;
     FsFileName:=OpenDlg.FileName;
     ShowAPISPY;
   Finally
     // Restores Original PE File for furder use
     PEFile.Free;
     PEFile:=ThePEFile.Create(FsFileName);
     PEHeader.Dump(PEFile);
   End;
  End;}
end;

procedure TDeDeMainForm.SaveProject1Click(Sender: TObject);
begin
  If not FbProcessed Then Raise Exception.Create(err_nothing_to_save);
end;

procedure TDeDeMainForm.PrepareProject(ssFN: String);
var iRVA,iPhys,cRVA,cPhys : String;
    iIDX : Byte;
    dw : DWORD;
begin
  // Moves file into memory
  FbProcessed:=False;
  If PEFile<>nil Then PEFile.Free;
  FsFileName:=ssFN;
  PEFile:=ThePEFile.Create(ssFN);

  //Check if its ELF file
  PEFile.PEStream.Seek(0,soFromBeginning);
  PEFile.PEStream.ReadBuffer(dw,4);
  bELF:=dw=ELF_MAGIC;

  StsBar.Panels[1].Text:=msg_thinking;
  StsBar.Panels[2].Text:=ExtractFileName(ssFN);
  StsBar.Panels[3].Text:=Format('%d bytes',[PEFile.FileSize]);

  DumpStatusLbl.Caption:=msg_loading_idata;
  DumpStatusLbl.Refresh;

  //For object->class moving
  If PEHeader<>nil then PEHeader.Free;
  PEHeader:=TPEHEader.Create;

  PEHeader.Dump(Self.PEFile);


  // Correct first section name
  if Not bELF then
    begin
     if PEHeader.ObjectNum>0 then PEHeader.Objects[1].OBJECT_NAME:='CODE';

     iIDX:=PEHeader.GetSectionIndex('.idata');
     if iIDX=255 then iIDX:=PEHeader.GetSectionIndexByRVA(PEHEader.IMPORT_TABLE_RVA);
    end
    else begin
      iIDX:=PEHeader.GetSectionIndexEx('.idata');
    end;

  iRVA:=DWORD2HEX(PEHeader.Objects[iIDX].RVA);
  iPhys:=DWORD2HEX(PEHeader.Objects[iIDX].PHYSICAL_OFFSET);
  cRVA:=DWORD2HEX(PEHeader.Objects[1].RVA);
  cPhys:=DWORD2HEX(PEHeader.Objects[1].PHYSICAL_OFFSET);
  DeDeClasses.PEHeader:=PEHeader;
  DeDeClasses.PEFile:=PEFile;

  if bELF then bBSS:=False;
  DeDeDisASM.GlobBEmulation:=bBSS;

  DeDeSym.bMakeCRC:=False;
end;

procedure TDeDeMainForm.AssignDeDeDisAsms;
var i : Integer;
var Input : TMemoryStream;
    ClsDmp : TClassDumper;
begin
  If DCULv.Selected=nil Then Exit;

  DeDeDisAsm.PASNameList:=PASNameList;
  DeDeDisAsm.FOpCodeList:=FOpCodeList;
  DeDeDisAsm.DFMNameList:=DFMNameList;
  DeDeDisAsm.PEStream:=PEFile.PEStream;
  //DeDeDisAsm.PEHeader:=PEHeader;
  DeDeDisAsm.RVAConverter.ImageBase:=PEHeader.IMAGE_BASE;
  if bELF then begin
       DeDeDisAsm.RVAConverter.PhysOffset:=PEHeader.Objects[PEHeader.GetSectionIndex('.text')].PHYSICAL_OFFSET;
       DeDeDisAsm.RVAConverter.CodeRVA:=PEHeader.Objects[PEHeader.GetSectionIndex('.text')].RVA;
    end   
    else begin
       DeDeDisAsm.RVAConverter.PhysOffset:=PEHeader.Objects[1].PHYSICAL_OFFSET;
       DeDeDisAsm.RVAConverter.CodeRVA:=PEHeader.Objects[1].RVA;
    end;


  ClsDmp:=TClassDumper(DCULv.Selected.Data);
  DeDeDisAsm.ControlNames.Clear;
  DeDeDisAsm.ControlIDs.Clear;
  For i:=0 To ClsDmp.FieldData.Count-1 Do
   Begin
     DeDeDisAsm.ControlNames.Add(TFieldRec(ClsDmp.FieldData.Fields[i]).sName);
     DeDeDisAsm.ControlIDs.Add(IntToHex(TFieldRec(ClsDmp.FieldData.Fields[i]).dwID,8));
   End;

  DeDeDisAsm.UnitList.Clear;

  For i:=0 To DCULv.Items.Count-1 Do
     DeDeDisAsm.UnitList.Add(DCULv.Items[i].Caption);

   GlobCustomEmulInit:=False;
end;

procedure TDeDeMainForm.BPLDumper1Click(Sender: TObject);
begin
  BPL.ShowModal;
end;

procedure TDeDeMainForm.RecentFileEditChange(Sender: TObject);
begin
  FE.Text:=RecentFileEdit.Items[RecentFileEdit.ItemIndex];
  FileEdit.FileName:=FE.Text;
end;

procedure TDeDeMainForm.FileEditChange(Sender: TObject);
begin
  FE.Text:=FileEdit.FileName;
end;

procedure TDeDeMainForm.CheckFolders;
var sDir : String;
    sr : TSearchRec;
begin
  sDir:=ExtractFileDir(Application.ExeName);
  Try
    IF FindFirst(sDir+'\Dumps',faDirectory,sr)<>0 Then CreateDir('Dumps');
    IF FindFirst(sDir+'\DSF',faDirectory,sr)<>0 Then CreateDir('DSF');
    IF FindFirst(sDir+'\Projects',faDirectory,sr)<>0 Then CreateDir('Projects');
    IF FindFirst(sDir+'\LANGRES',faDirectory,sr)<>0 Then CreateDir('LANGRES');
  Finally
    FindClose(sr);
  End;
end;

procedure TDeDeMainForm.DirEditBeforeDialog(Sender: TObject;
  var Name: String; var Action: Boolean);
begin
  DirEdit.InitialDir:=ExtractFileDir(Application.ExeName)+'\Dumps';
end;

procedure TDeDeMainForm.SaveDlgShow(Sender: TObject);
begin
  SaveDlg.InitialDir:=ExtractFileDir(Application.ExeName)+'\Projects';
end;

procedure TDeDeMainForm.DeDeOpenDlgShow(Sender: TObject);
begin
   DeDeOpenDlg.InitialDir:=ExtractFileDir(Application.ExeName)+'\Projects';
end;

procedure TDeDeMainForm.DCUDumper1Click(Sender: TObject);
begin
  DCUForm.ShowModal;
end;

procedure TDeDeMainForm.DFMListEnter(Sender: TObject);
begin
  AppHint(txt_rightclick4more);
end;

procedure TDeDeMainForm.AppHint(AsHint: String);
begin
   StsBar.Panels[4].Text:=AsHint;
   ClearTimer.Enabled:=True;
end;

procedure TDeDeMainForm.ClearTimerTimer(Sender: TObject);
begin
  Stsbar.Panels[4].Text:='';
  ClearTimer.Enabled:=False;
end;

procedure TDeDeMainForm.DCULVEnter(Sender: TObject);
begin
  AppHint(txt_rightclick4more);
end;

procedure TDeDeMainForm.ControlsLVEnter(Sender: TObject);
begin
  AppHint(txt_rightclick4more);
end;

procedure TDeDeMainForm.DCULVExit(Sender: TObject);
begin
  ClearTimerTimer(Self);
end;

procedure TDeDeMainForm.DFMListExit(Sender: TObject);
begin
  ClearTimerTimer(Self);
end;

procedure TDeDeMainForm.LoadSymbolFile1Click(Sender: TObject);
Var DeDeSym : TDeDeSymbol;
begin
  OpenSymDlg.InitialDir:=ExtractFileDir(Application.ExeName)+'\DSF';
  If OpenSymDlg.Execute Then
    Begin
      If Not FileExists(OpenSymDlg.FileName) Then Raise Exception.Create(err_filenotfound);
      DeDeSym:=TDeDeSymbol.Create;

      Screen.Cursor:=crHourGlass;
      Try
      If DeDeSym.LoadSymbol(OpenSymDlg.FileName)
         Then Begin
           If DeDeSym.PatternSize=_PatternSize Then
             Begin
               SymbolsList.Add(DeDeSym);
               SymbolsPath.Add(OpenSymDlg.FileName);
               ShowMessage(Format(msg_dsf_loaded,[OpenSymDlg.FileName,DeDeSym.Comment]));
             End
             Else Begin
                 ShowMessage(err_dsf_ver_not_supp);
                 DeDeSym.Free;
             End;
         End
         Else Begin
           ShowMessage(err_dsf_unabletoload);
           DeDeSym.Free;
         End;
      Finally
        Screen.Cursor:=crDefault;
      End;
    End;
end;

procedure TDeDeMainForm.FreeSymbolList;
var i : Integer;
begin
  For i:=0 To SymbolsList.Count-1 Do
    TDeDeSymbol(SymbolsList[i]).Free;
end;

procedure TDeDeMainForm.LoadSymbolFiles;
var i : Integer;
    s : String;
    DeDeSym : TDeDeSymbol;
begin
  s:='';
  For i:=0 To SymbolsToLoad.Count-1 Do
    Begin
      If FileExists(SymbolsToLoad[i])
        Then Begin
          DeDeSym:=TDeDeSymbol.Create;
          If DeDeSym.LoadSymbol(SymbolsToLoad[i])
             Then Begin
               If DeDeSym.PatternSize=_PatternSize Then
                 Begin
                   SymbolsList.Add(DeDeSym);
                   If SymbolsPath.IndexOf(SymbolsToLoad[i])=-1
                      Then SymbolsPath.Add(SymbolsToLoad[i]);
                 End
                 Else Begin
                   s:=s+SymbolsToLoad[i]+err_dsf_ver_not_supp_1+#13#10;
                   DeDeSym.Free;
                 End;

             End
             Else Begin
               s:=s+SymbolsToLoad[i]+#13#10;
               DeDeSym.Free;
             End;
        End
        Else s:=s+SymbolsToLoad[i]+#13#10;
    End;
    
  // Assigns The SymbolList To DeDeDisAsm unit
  DeDeDisAsm.SymbolsList:=SymbolsList;
  
  If s<>'' Then ShowMessage(err_dsf_failedtoload+#13#10#13#10+s);  
end;

procedure TDeDeMainForm.Symbols1Click(Sender: TObject);
begin
  SymbolsForm.SymbolsList:=SymbolsList;
  SymbolsForm.ShowModal;
end;

procedure TDeDeMainForm.UnloadDSFSymbol(i: Integer);
var Sym : TDeDeSymbol;
begin
  If i>SymbolsList.Count-1 Then Raise Exception.Create(err_dsf_invalid_index);

  Sym:=TDeDeSymbol(SymbolsList[i]);
  Sym.Free;
  SymbolsList.Delete(i);
end;

procedure TDeDeMainForm.SetExitCtrls(bEnabled: Boolean);
begin
  Exit1.Enabled:=bEnabled;
end;

procedure TDeDeMainForm.ClassesLVDblClick(Sender: TObject);
begin
  If ClassesLV.Selected=nil Then Exit;
  ClassInfoForm.ClassDumper:=TClassDumper(ClassesLV.Selected.Data);
  ClassInfoForm.ShowModal;
end;

procedure TDeDeMainForm.Panel2MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  If (ssShift in Shift) and (ssAlt in Shift) and (ssCtrl in Shift)
     Then FbHiddenStuff:=True;
end;

procedure TDeDeMainForm.Panel2MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  If (FbHiddenStuff) And (ssCtrl in Shift) and (not(ssShift in Shift)) and (not(ssAlt in Shift))
    Then RunHiddenStuff(PEFile.PEStream);
  FbHiddenStuff:=False;
end;

function TClassesDumper.GetClass(sClassName: String): TClassDumper;
var i : Integer;
begin
  Result:=nil;
  if sClassName='' then exit;
  For i:=0 To Classes.Count-1 Do
    If (TClassDumper(Classes[i]).FsClassName=sClassName)
       Then Begin
         Result:=TClassDumper(Classes[i]);
         Exit;
       End;
end;

function TClassesDumper.GetClassWMethods(sClassName: String): TClassDumper;
var i : Integer;
begin
  Result:=nil;
  if sClassName='' then exit;
  For i:=0 To Classes.Count-1 Do
    If     (TClassDumper(Classes[i]).FsClassName=sClassName)
       and (TClassDumper(Classes[i]).MethodData.Count<>0)
       Then Begin
         Result:=TClassDumper(Classes[i]);
         Exit;
       End;
end;

function TClassesDumper.GetClassWFields(sClassName: String): TClassDumper;
var i : Integer;
begin
  Result:=nil;
  if sClassName='' then exit;
  For i:=0 To Classes.Count-1 Do
    If     (TClassDumper(Classes[i]).FsClassName=sClassName)
       and (TClassDumper(Classes[i]).FieldData.Count<>0)
       Then Begin
         Result:=TClassDumper(Classes[i]);
         Exit;
       End;
end;

function TClassesDumper.GetDFMTXTDATA(sClassName: String): TStringList;
var i : Integer;
begin
  Result:=nil;
  for i:=0 to High(DFMTXTDATA_Names) do
    if DFMTXTDATA_Names[i]=sClassName then
       begin
         Result:=TStringList(DFMTXTDATA[i]);
         Break;
       end;

end;


procedure TDeDeMainForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  If MessageDlg(msg_exit_dede_confirm,mtConfirmation,[mbYes,mbNo],0)=mrNo
     Then CanClose:=False
     Else Begin
       CanClose:=True;
       If not PrcsBtn.Enabled
         Then Begin
           FormDestroy(self);
           ExitProcess(0);
         End;  
     End;
end;

procedure TDeDeMainForm.DPR1Click(Sender: TObject);
var s,ss : String;
    DasmList : TStringList;
    node : TTreeNode;
    i : Integer;
begin
  If Not FbProcessed Then Raise Exception.Create(err_nothing_processed);

   //DeDeDisAsm.PEHeader:=DeDeClasses.PEHeader;
   DeDeDisAsm.PEStream:={BOZA DeDeClasses.}PEStream;
   DeDeDisAsm.RVAConverter:=RVAConverter;
   DeDeDisAsm.RVAConverter.ImageBase:=PEHeader.IMAGE_BASE;
   if bELF then begin
       DeDeDisAsm.RVAConverter.PhysOffset:=PEHeader.Objects[PEHeader.GetSectionIndex('.text')].PHYSICAL_OFFSET;
       DeDeDisAsm.RVAConverter.CodeRVA:=PEHeader.Objects[PEHeader.GetSectionIndex('.text')].RVA;
    end
    else begin
       DeDeDisAsm.RVAConverter.PhysOffset:=PEHeader.Objects[1].PHYSICAL_OFFSET;
       DeDeDisAsm.RVAConverter.CodeRVA:=PEHeader.Objects[1].RVA;
    end;

   DeDeDisAsm.RVAConverter:=DeDeDisAsm.RVAConverter;
   PEStream.Seek(PEHeader.RVA_ENTRYPOINT-
                    PEHeader.Objects[1].RVA+
                    PEHeader.Objects[1].PHYSICAL_OFFSET,soFromBeginning);
                    
   InitNewEmulation('','','','');
   DisassembleProc('','',DasmList,False,True);

   ASMShowForm.ASMList.Clear;
   ASMShowForm.Caption:=ProjectNameLbl.Caption+'.dpr code';
   ASMShowForm.ProcCB.Clear;
   ASMShowForm.ProcCB.Items.Add(ASMShowForm.Caption);
   ASMShowForm.ProcCB.ItemIndex:=0;
   ASMShowForm.ProcRVA.Clear;
   ASMShowForm.ProcRVA.Items.Add(
     RVAConverter.GetRVA(IntToHex(PEHeader.RVA_ENTRYPOINT-
                    PEHeader.Objects[1].RVA+
                    PEHeader.Objects[1].PHYSICAL_OFFSET,8)));
   ASMShowForm.ProcTree.Items.Clear;
   node:=ASMShowForm.ProcTree.Items.AddChildFirst(nil,ProjectNameLbl.Caption+'.dpr code');
   node.ImageIndex:=1;
   For i:=0 To DasmList.Count-1 Do
    Begin
      s:=DasmList[i];
      While Pos(#13#10,s)<>0 Do
        Begin
           ASMShowForm.ASMList.Items.Add(Copy(s,1,Pos(#13#10,s)-1));
           s:=Copy(s,Pos(#13#10,s)+2,Length(s)-Pos(#13#10,s));
        End;
      ASMShowForm.ASMList.Items.Add(s);
    End;

   if bModalAsmShow
     then ASMShowForm.ShowModal
     else ASMShowForm.Show;
   // Frees Disaasembly Result String List
   DasmList.Free;
end;

procedure TDeDeMainForm.DAPClick(Sender: TObject);
var ver : DWORD;
var iRVA,iPhys,cRVA,cPhys : String;
    iIDX : Byte;
begin
  ver:=GetVersion;
//  if ((ver and $F0000000)<>0) and ((ver and $0000000F)<>5) Then
//    Raise Exception.Create('This feature is available only on Windows NT');

  If DeDeMemDumps.IsWin9x
    Then MemDmpForm.ShowProcesses95
    Else MemDmpForm.ShowProcesses;
  MemDmpForm.ShowModal;
  If MemDmpForm.MemDmp<>nil Then
    Begin
      FbMemFump:=True;
      // Moves file into memory
      FbProcessed:=False;
      If PEFile<>nil Then PEFile.Free;
      FsFileName:=MemDmpForm.FsProcessName;
      PEFile:=ThePEFile.Create('');
      PEFile.PEStream.LoadFromStream(MemDmpForm.MemDmp);

      StsBar.Panels[1].Text:=msg_thinking;
      StsBar.Panels[2].Text:=FsFileName;
      StsBar.Panels[3].Text:='';
      MemDmpForm.MemDmp.Free;

      DumpStatusLbl.Caption:=msg_loading_idata;
      DumpStatusLbl.Refresh;
      if PEHeader=nil then PEHeader:=TPEHeader.Create;
      PEHeader.Dump(Self.PEFile);
      //PEHeader:=mPEHeader;
      iIDX:=PEHeader.GetSectionIndex('.idata');
      if iIDX=255 then iIDX:=PEHeader.GetSectionIndexByRVA(PEHEader.IMPORT_TABLE_RVA);
      iRVA:=DWORD2HEX(PEHeader.Objects[iIDX].RVA);
      iPhys:=DWORD2HEX(PEHeader.Objects[iIDX].PHYSICAL_OFFSET);
      cRVA:=DWORD2HEX(PEHeader.Objects[1].RVA);
      cPhys:=DWORD2HEX(PEHeader.Objects[1].PHYSICAL_OFFSET);
      DeDeClasses.PEHeader:=PEHeader;
      DeDeClasses.PEFile:=PEFile;
      //DeDeDisASM.PEHeader:=PEHeader;
      PreBtnClick(Self);
    End
    Else FbMemFump:=False;
end;

procedure TDeDeMainForm.DumpDFMNames;
var beg, en : DWORD;
    idx,b,b1: Byte;
    buff,DFMbuff : Array [0..3] of byte;
    s : String;
    dwOffs : DWORD;
begin
  DFMFormList.Clear;
  DFMbuff[0]:=$54;DFMbuff[1]:=$50; DFMbuff[2]:=$46; DFMbuff[3]:=$30;

  if bELF then
    idx:=PEHeader.GetSectionIndexEx('.rsrc')
  else begin
    idx:=PEHeader.GetSectionIndex('.rsrc');
    if idx=255 Then idx:=PEHeader.GetSectionIndexByRVA(PEHeader.RESOURCE_TABLE_RVA);
  end;

  beg:=PEHeader.Objects[idx].PHYSICAL_OFFSET;
  en:=beg+PEHeader.Objects[idx].PHYSICAL_SIZE;

  PEStream.Seek(beg,soFromBeginning);
  Repeat
     Inc(beg);
     PEStream.Seek(beg,soFromBeginning);
     Try
       PEStream.ReadBuffer(buff[0],4);
     Except
       Break;
     End;

     if beg mod 1000 = 0 then Application.ProcessMessages;
     if CompareMem(@buff[0],@DFMbuff[0],4) then
       begin
         dwOffs:=PEStream.Position-4;
         PEStream.ReadBuffer(b1,1);
         if b1=$F1 then PEStream.ReadBuffer(b1,1);
         s:='';
         for idx:=0 To b1-1 do
           begin
             PEStream.ReadBuffer(b,1);
             s:=s+CHR(b);
             //if CHR(b) in ['A'..'Z','a'..'z','0'..'9','_']
             //   then s:=s+CHR(b)
             //   else break;
           end;
        if Length(s)=b1 Then DFMFormList.AddObject(s,Pointer(dwOffs));
       end;

  Until PEStream.Position>=en-4;

end;

function TClassesDumper.ClassExists(sClassName : String): Boolean;
var i : Integer;
begin
  Result:=False;
  For i:=0 To self.Classes.Count-1 Do
    If TClassDumper(self.Classes[i]).FsClassName=sClassName Then
      Begin
        Result:=true;
        Exit;
      End;
end;

function TClassesDumper.GetClassByName(sClassName: String): TClassDumper;
var i : Integer;
begin
  Result:=nil;
  For i:=0 To Classes.Count-1 Do
    If     (TClassDumper(Classes[i]).FsClassName=sClassName)
       Then Begin
         Result:=TClassDumper(Classes[i]);
         Exit;
       End;
end;
procedure TDeDeMainForm.DFMListColumnClick(Sender: TObject;
  Column: TListColumn);
var Tag : Byte;
begin
  Tag:=(Sender as TListView).Tag;
  Tag:=(Tag+1) mod 2;
  (Sender as TListView).Tag:=Tag;

  If Column.ID=0 Then (Sender as TListView).SortType:=stText
                 Else (Sender as TListView).SortType:=stData;

  (Sender as TListView).AlphaSort;
end;

procedure TDeDeMainForm.DFMListCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
var dw1, dw2 : DWORD;
begin
 if (Sender as TListView).SortType=stData then
   begin
     dw1:=HEX2DWORD(Item1.SubItems[0]);
     dw2:=HEX2DWORD(Item2.SubItems[0]);
     if dw1=dw2 then Compare:=0;
     if dw1<dw2 then Compare:=-1;
     if dw1>dw2 then Compare:=1;
   end
   else begin
     if Item1.Caption=Item2.Caption then Compare:=0;
     if Item1.Caption<Item2.Caption then Compare:=-1;
     if Item1.Caption>Item2.Caption then Compare:=1;
   end;
end;

procedure TDeDeMainForm.IDAMAPClick(Sender: TObject);
begin
   RVACB.Enabled:=IDAMAP.Checked;
   ControlCB.Enabled:=IDAMAP.Checked;
   AllStrCB.Enabled:=REF.Checked;
   AllCallsCB.Enabled:=REF.Checked;
   CustomCB.Enabled:=REF.Checked;
end;

procedure TDeDeMainForm.Button1Click(Sender: TObject);
var FS : String;
    text : System.Text;
    i,j,k,l,idx : Integer;
    ClsDmp : TClassDumper;
    MethRec : TMethodRec;
    s,ss,s1,ss1 : String;
    DasmList, TmpList : TStringList;
    dw,Code, dw1 : DWORD;
    tick1,tick2 : Double;
    WA : TWPJALF;
    bStr : Boolean;
    dwFrom, dwTo, cnt : DWORD;
    b : Byte;

var cont_call_str, cont_call_str2 : String;
    sSoftIceDir : String;

    procedure ParsIT(s : String; var List : TStringList; var RVA : String);
    var ps : Integer;
    begin
      List.Clear;
      if Copy(s,1,2)=#13#10 then s:=Copy(s,3,Length(s)-2);
      Repeat
        ps:=Pos(#13#10,s);
        if ps<>0 then begin
          List.Add(Copy(s,1,ps-1));
          s:=Copy(s,ps+2,Length(s)-ps-3);
        end;
      Until ps=0;
      RVA:=Copy(s,1,8);
      if (List.Count>0) and (List[List.Count-1]<>'|') then List.Add('|')
    end;

    Function Min(a,b : Cardinal) : Cardinal;
    begin
      if a<b then Result:=a
             else Result:=b;
    end;

    Procedure PrepareList(aList : TStringList; s : String);
    var inx : Integer;
        s1 : String;
    begin
      aList.Clear;
      inx:=Pos(#13#10,s);
      while (inx<>0) and (s<>'') do
        begin
          s1:=Copy(s,1,inx-1);
          s:=Copy(s,inx+2,Length(s)-inx-1);
          if s1<>'' then aList.Add(s1);
          inx:=Pos(#13#10,s);
        end;
      if s<>'' then aList.Add(s);
    end;

var bReferenceFound : Boolean;
    sPrefix, sSufix : String;

begin
  If (Not FbProcessed) or (FbFailed) Then Exit;

  cont_call_str  := 'call';
  cont_call_str2 :='|'#13#10;

  FS:=ExportFileName.FileName;
  If FS='' Then Raise Exception.Create(err_specifyfilename);


  If IDAMAP.Checked Then
  begin
    ///////////////////////////////////////////////////////////////////////
    /// IDA MAP File Export
    ///////////////////////////////////////////////////////////////////////
    Screen.Cursor:=crHourGlass;
    TmpList:=TStringList.Create;
    DeDeDisAsm.bErrorsAsFile:=True;
    DeDeDisAsm.sDisAsmErrors:='';
    Try

      StsBar.Panels[1].Text:=msg_creating_exports;
      StsBar.Update;
      Application.ProcessMessages;

      tick1:=GetTickCount;
      tick2:=tick1;

      If CheckFile(FS) Then
        Begin
          // Create the output file and put the header
          System.Assign(text,FS);
          System.ReWrite(text);
          System.WriteLn(text,'');
          System.WriteLn(text,sIDAMAP_LINE1);
          CODE:=PEHeader.IMAGE_BASE+PEHeader.Objects[1].RVA;
          System.WriteLn(text,Format(sIDAMAP_LINE2,[DWORD2HEX(CODE),
                                                                                DWORD2HEX(PEHeader.Objects[1].VIRTUAL_SIZE)]));
          System.WriteLn(text,'');
          System.WriteLn(text,'');
          System.WriteLn(text,sIDAMAP_LINE3);
          System.WriteLn(text,'');

          // Adding references
          EPB.Min:=0;
          EPB.Position:=0;
          EPB.Max:=DCULV.Items.Count;
          EPB.Update;
          Application.ProcessMessages;

          For j:=0 To DCULV.Items.Count-1 do
           // For all units in the project
           Begin
            // Get the form as TClassDumper
            ClsDmp:=TClassDumper(DCULV.Items[j].Data);

            EPB.Position:=j+1;
            EPB.Update;
            Application.ProcessMessages;

            For i:=0 to ClsDmp.MethodData.Count-1 Do
              // For all published mehods of the form
              Begin
                MethRec:=TMethodRec(ClsDmp.MethodData.Methods[i]);
                //No _PROC_s
                if Pos('_PROC_',MethRec.sName)<>0 then continue;
                
                // Adding RVAs and Method Names
                If RVACB.Checked Then
                  // Skip non published methods
                  if Copy(MethRec.sName,1,1)<>'~'
                    then System.WriteLn(text,
                      Format(sIDAMAP_ENTRY_LINE,[
                           DWORD2HEX(MethRec.dwRVA-CODE),
                           DeDeStrToIDAStr(IDA_EVENT_HANDLER_START+
                                           ClsDmp.FsClassName+
                                           IDA_SEPARATOR_SIGN_SHIT+
                                           MethRec.sName)
                           ]));

                // prepare to disassemble the current method
                DeDeDisAsm.PEStream:={BOZA DeDeClasses.}PEStream;
                DeDeDisAsm.RVAConverter.ImageBase:=PEHeader.IMAGE_BASE;
                if bELF then begin
                     DeDeDisAsm.RVAConverter.PhysOffset:=PEHeader.Objects[PEHeader.GetSectionIndex('.text')].PHYSICAL_OFFSET;
                     DeDeDisAsm.RVAConverter.CodeRVA:=PEHeader.Objects[PEHeader.GetSectionIndex('.text')].RVA;
                  end
                  else begin
                     DeDeDisAsm.RVAConverter.PhysOffset:=PEHeader.Objects[1].PHYSICAL_OFFSET;
                     DeDeDisAsm.RVAConverter.CodeRVA:=PEHeader.Objects[1].RVA;
                  end;

                ss:=RVAConverter.GetPhys(DWORD2HEX(MethRec.dwRVA));
                DeDeClassEmulator.ClsDmp:=ClassesDumper;
                AssignDeDeDisAsms;
                DeDeDisAsm.ClsDmp:=nil;
                DeDeDisAsm.ClsDmp:=ClsDmp;

                PEStream.Seek(HEX2DWORD(ss),soFromBeginning);


                // If control references must be added
                If (ControlCB.Checked) Then
                  Begin
                    // ---------------------------------------------------------------
                    // Setting controls lists for control refs
                    // This might not be neseccary with the current
                    // control references implementation with
                    // DeDeDisAsm.ControlRef() and DeDeClassEmulator.GetDOIReference()
                    // ---------------------------------------------------------------
                    DeDeDisAsm.ControlNames.Clear;
                    DeDeDisAsm.ControlIDs.Clear;
                    For k:=0 To ClsDmp.FieldData.Count-1 Do
                     Begin
                       DeDeDisAsm.ControlNames.Add(TFieldRec(ClsDmp.FieldData.Fields[k]).sName);
                       DeDeDisAsm.ControlIDs.Add(IntToHex(TFieldRec(ClsDmp.FieldData.Fields[k]).dwID,8));
                     End;

                    ExportDetailsLbl.Caption:=ClsDmp.FsClassName+MethRec.sName;
                    ExportDetailsLbl.Update;
                    Application.ProcessMessages;

                    // init emulation with current form class in EAX
                    if GlobBEmulation
                       then InitNewEmulation(ClsDmp.FsClassName,'','','');

                    // disassemble procedure
                    DisassembleProc('','',DasmList,False,True);

                    k:=-1;
                    Repeat
                      // Increase line number
                      Inc(k);

                      // Read next line from disassembly list (same as the one in ASMShow form)
                      s:=DasmList[k];

                      if s='' then continue;
                      PrepareList(TmpList,s);
                      idx:=0;
                      If TmpList.Count=0 then continue;

                      bReferenceFound:=False;

                      ///////////////////////////////////////
                      // DOI MEMBER/CONTROL REFERENCES
                      ///////////////////////////////////////
                      If (Pos(sREF_TEXT_CONTROL,s)<>0) then
                        Begin
                          // Copy the text of the reference
                          ss:=Copy(s,26,Length(s)-25);
                          // Set bReferenceFound to True
                          bReferenceFound:=True;
                          sPrefix:=IDA_LOCAL_SIGN_SHIT;
                          sSufix:='';
                        End;
                      If (Pos(sREF_TEXT_FIELD,s)<>0) then
                        Begin
                          // Copy the text of the reference
                          ss:=Copy(s,24,Length(s)-23);
                          // Set bReferenceFound to True
                          bReferenceFound:=True;
                          sPrefix:=IDA_LOCAL_SIGN_SHIT;
                          sSufix:='';
                        End;
                      If (Pos(sREF_TEXT_PROPERTY,s)<>0) then
                        Begin
                          // Copy the text of the reference
                          ss:=Copy(s,24,Length(s)-23);
                          // Set bReferenceFound to True
                          bReferenceFound:=True;
                          sPrefix:=IDA_LOCAL_SIGN_SHIT;
                          sSufix:='';
                        End;


                      ////////////////////////////////////////////////////////////////////////
                      // REFERENCES TO PUBLISHED METHODS, DOI METHODS and DOI DYNAMIC METHODS
                      ////////////////////////////////////////////////////////////////////////
                      If (Pos(sREF_TEXT_PUBLISHED,s)<>0) then
                        Begin
                          // Copy the text of the reference
                          ss:=Copy(s,18,Length(s)-17);
                          // Set bReferenceFound to True
                          bReferenceFound:=True;
                          sPrefix:=IDA_CALL_TO_FUNCTION;
                          sSufix:='';
                        End;
                      If (Pos(sREF_TEXT_METHOD,s)<>0) then
                        Begin
                          // Copy the text of the reference
                          ss:=Copy(s,24,Length(s)-23);
                          // Set bReferenceFound to True
                          bReferenceFound:=True;
                          sPrefix:=IDA_CALL_TO_FUNCTION;
                          sSufix:='';
                        End;
                      If (Pos(sREF_TEXT_DYN_METHOD,s)<>0) then
                        Begin
                          // Copy the text of the reference
                          ss:=Copy(s,31,Length(s)-30);
                          // Set bReferenceFound to True
                          bReferenceFound:=True;
                          sPrefix:=IDA_CALL_TO_FUNCTION;
                          sSufix:='';
                        End;

                      ///////////////////////////////////////////
                      // REFERENCES TO DSF METHOD or IMPORT CALL
                      ///////////////////////////////////////////
                      If (Pos(sREF_TEXT_REF_DSF,s)<>0) then
                        Begin
                          // Copy the text of the reference
                          ss:=Copy(s,18,Length(s)-17);
                          s:=TmpList[idx+2]+'|';
                          if s[1]<>'|' then
                            begin
                              // Just a single DSF/Import reference
                              bReferenceFound:=True;
                              sPrefix:=IDA_CALL_TO_FUNCTION;
                              sSufix:='';
                            end
                            else begin
                              // Set bReferenceFound to True
                              bReferenceFound:=True;
                              sPrefix:=IDA_CALL_TO_FUNCTION;
                              sSufix:=IDA_MORE_DSF_REFERENCES;
                              Repeat
                                Inc(idx);
                                s:=TmpList[idx+2]+'|' ;
                              Until s[1]<>'|';
                            end;
                        End;


                       // If there is a single line reference then add it !!!
                       if (bReferenceFound) then
                         begin
                          // find the possition of the first #13
                          dw:=Pos(#$D,ss);
                          // and cut until then
                          ss:=Copy(ss,1,dw-1);
                          // Skip next 2 lines to be processed
                          Inc(idx,2);
                          // Get the next line (the asm instruction that is referenced)
                          s:=TmpList[idx];
                          // calculate the RVA
                          dw:=HEX2DWORD(Copy(s,1,8));
                          // if there stays something
                          if (dw<>0) and (ss<>'') then
                            begin
                              // Calculate the offset from the beggining of the CODE section
                              dw:=dw-Code;
                              // and insert line into the .map file
                             System.WriteLn(text,Format(sIDAMAP_ENTRY_LINE,[
                                                 DWORD2HEX(dw),
                                                 DeDeStrToIDAStr(sPrefix+ss+sSufix)]));
                            end;
                         end;


                    Until k=DasmList.Count-1;
                  End;{if ControlCB.Checked}
              End; {With}

           End; {for j}

          // Add the program entry point
          System.WriteLn(text,'');
          System.WriteLn(text,Format(sIDAMAP_PEP_LINE,[DWORD2HEX(PEHeader.RVA_ENTRYPOINT+PEHeader.IMAGE_BASE)]));
          System.Close(text);

          tick2:=GetTickCount;
          SavePB.Position:=0;
          SavePB.Update;

          ///////////////////////////////////////////////////////////
          //    Ask user if he wants the file to be compiled to .sym
          // and loaded in SoftIce
          ///////////////////////////////////////////////////////////
          sSoftIceDir:=GetSoftIceDir;
          if sSoftIceDir<>'' then
            // SoftIce is installed
            begin
              if SoftIceIsActive then
                 if MessageDlg(msg_load_in_sice ,mtConfirmation,[mbYes,mbNo],0)=mrYes
                    Then CompileToSymAndLoadInSice(FS, sSoftIceDir)
                    Else ShowMessageFmt(msg_load_in_sice_manually+#13#13+
                                        'msym.exe %s.map'#13+
                                        'nmsym.exe %s.sym'#13+
                                        'nmsym.exe /SYM:%s.nms',
                                        [FsProjectName,FsProjectName,FsProjectName])
                 else ShowMessage(msg_sym_sice_info);                                        
            end;

        if DeDeDisAsm.sDisAsmErrors<>'' then
          begin
            with TStringList.Create do
              begin
                Text:=DeDeDisAsm.sDisAsmErrors;
                SaveToFile(ChangeFileExt(FS,'.err'));
              end;
            ShowMessage('Done with errors.'#13#10+msg_file_created+#13#10'Errors saved in '+ExtractFileName(ChangeFileExt(FS,'.err')));
          end
          else ShowMessageFmt(msg_file_created,[FS]);
        End;
      Finally
        StsBar.Panels[1].Text:=Format(msg_ready_secs,[IntToStr(Trunc((tick2-tick1)/1000))]);
        EPB.Position:=0;
        Screen.Cursor:=crDefault;
        ExportDetailsLbl.Caption:='';
        DeDeDisAsm.bErrorsAsFile:=False;
        TmpList.Free;
      End;
   End;

 If REF.checked Then
   begin
    ///////////////////////////////////////////////////////////////////////
    /// W32DASM WPJ/ALF File Export
    ///////////////////////////////////////////////////////////////////////
    bStr:=AllStrCB.Checked;
    If FindWindow(PChar('OWL_Window'),nil)<>0 Then
          MessageDlg(wrn_w32dasm_active,mtWarning,[mbOK],0);
    Screen.Cursor:=crHourGlass;
    WA:=TWPJALF.Create;
    TmpList:=TStringList.Create;
     DeDeDisAsm.bErrorsAsFile:=True;
     DeDeDisAsm.sDisAsmErrors:='';
    Try
      tick1:=GetTickCount;
      tick2:=tick1;

      StsBar.Panels[1].Text:=msg_open_files;
      StsBar.Update;
      Application.ProcessMessages;
      if not WA.OpenWPJFile(FS) then
        begin
          ShowMessage(err_only_one_w32dasm_export);
          Exit;
        end;

      WA.NewReferences;

      StsBar.Panels[1].Text:=msg_dis_bepatient;
      StsBar.Update;
      Application.ProcessMessages;

          // Adding references
          EPB.Min:=0;
          EPB.Position:=0;
          EPB.Max:=DCULV.Items.Count;
          EPB.Update;
          Application.ProcessMessages;

          if ((CustomCB.Checked) and (w32CustSetForm.FormsCB.Checked))
            or (not CustomCB.Checked)then
          For j:=0 To DCULV.Items.Count-1 do
           Begin
            ClsDmp:=TClassDumper(DCULV.Items[j].Data);

            // If custom settings are selected then skip the class if it is not in selection list
            If CustomCB.Checked then
               If w32CustSetForm.SelectedLB.Items.IndexOf(ClsDmp.FsClassName)=-1 then Continue;


            EPB.Position:=j+1;
            EPB.Update;
            Application.ProcessMessages;

            For i:=0 to ClsDmp.MethodData.Count-1 Do
              Begin
                MethRec:=TMethodRec(ClsDmp.MethodData.Methods[i]);

                // Event Handlers Comments
                if Pos('_PROC_',MethRec.sName)=0 then
                  begin
                    WA.AddRefference(DWORD2HEX(MethRec.dwRVA),Color_DB_BLK,'');
                    WA.AddRefference(DWORD2HEX(MethRec.dwRVA),Color_DB_BLK,Format('* Event Handler: %s.%s()',[ClsDmp.FsClassName,MethRec.sName]));
                    WA.AddRefference(DWORD2HEX(MethRec.dwRVA),Color_DB_BLK,'|');
                  end;

                DeDeDisAsm.PEStream:={BOZA DeDeClasses.}PEStream;
                DeDeDisAsm.RVAConverter.ImageBase:=PEHeader.IMAGE_BASE;
                DeDeDisAsm.RVAConverter.PhysOffset:=PEHeader.Objects[1].PHYSICAL_OFFSET;
                DeDeDisAsm.RVAConverter.CodeRVA:=PEHeader.Objects[1].RVA;
                ss:=RVAConverter.GetPhys(DWORD2HEX(MethRec.dwRVA));
                DeDeDisAsm.RVAConverter:=DeDeDisAsm.RVAConverter;
                PEStream.Seek(HEX2DWORD(ss),soFromBeginning);

                    // Setting controls lists for control refs
                    DeDeDisAsm.ControlNames.Clear;
                    DeDeDisAsm.ControlIDs.Clear;
                    For k:=0 To ClsDmp.FieldData.Count-1 Do
                     Begin
                       DeDeDisAsm.ControlNames.Add(TFieldRec(ClsDmp.FieldData.Fields[k]).sName);
                       DeDeDisAsm.ControlIDs.Add(IntToHex(TFieldRec(ClsDmp.FieldData.Fields[k]).dwID,8));
                     End;

                    AssignDeDeDisAsms;
                    DeDeDisAsm.ClsDmp:=nil;
                    DeDeDisAsm.ClsDmp:=ClsDmp;

                    DisassemblerOptions.Imports:=False;
                    DisassemblerOptions.EnglishStrings:=False;
                    DisassemblerOptions.NonEnglishStrings:=AllStrCB.Checked;

                    ExportDetailsLbl.Caption:=ClsDmp.FsClassName+'.'+MethRec.sName;
                    ExportDetailsLbl.Update;
                    Application.ProcessMessages;

                    DisassembleProc('','',DasmList,False,True);
                    k:=-1;
                    Repeat
                      Inc(k);
                      s:=DasmList[k];

                      // Control Reference
                      If (Pos(sREF_TEXT_FINALLY,s)<>0)
                      or (Pos(sREF_TEXT_END,s)<>0)
                      or (Pos(sREF_TEXT_TRY,s)<>0)
                      or (Pos(sREF_TEXT_EXCEPT,s)<>0 ) then
                        Begin
                          ParsIT(s,TmpList,ss);
                          WA.AddRefference(ss,Color_DB_BLK,'');
                          for l:=0 to Min(1,TmpList.Count-1) Do
                             if ss>'00001000' then WA.AddRefference(ss,Color_DB_BLK,TmpList[l]);
                        End;

                      // BSS Reference
                      If (Pos(sREF_TEXT_REF_TO,s)<>0) then
                        Begin
                          ParsIT(s,TmpList,ss);
                          WA.AddRefference(ss,Color_B_BLK,'');
                          for l:=0 to TmpList.Count-1 Do
                             WA.AddRefference(ss,Color_B_BLK,TmpList[l]);
                        End;

                      // DSF Reference
                      If (Pos(sREF_TEXT_POSSIBLE_TO+' ',s)<>0) then
                        Begin
                          ParsIT(s,TmpList,ss);
                          WA.AddRefference(ss,Color_DB_BLK,'');
                          for l:=0 to TmpList.Count-1 Do
                             WA.AddRefference(ss,Color_DB_BLK,TmpList[l]);
                        End;

                      // String References if needed
                      If (bStr) and (Pos(sREF_TEXT_REF_STRING,s)<>0) then
                        Begin
                          ParsIT(s,TmpList,ss);
                          WA.AddRefference(ss,Color_G_BLK,'');
                          for l:=0 to TmpList.Count-1 Do
                             WA.AddRefference(ss,Color_G_BLK,TmpList[l]);
                        End;

                    Until k=DasmList.Count-1;
              End; {With}

           End; {for j}

          // Process All CALLs in the ALF file
          If (AllCallsCB.Checked)
             or ((CustomCB.Checked) and (w32CustSetForm.DSFCB.Checked)) Then
            begin
              if (CustomCB.Checked) and (w32CustSetForm.DSFCB.Checked) then
                begin
                  dwFrom:=HEX2DWORD(w32CustSetForm.FromRVA.Text);
                  dwTo:=HEX2DWORD(w32CustSetForm.ToRVA.Text);
                end
                else begin
                  dwFrom:=PEHeader.Objects[1].RVA+PEHeader.IMAGE_BASE;
                  dwTo:=PEHeader.Objects[1].RVA+PEHeader.Objects[1].VIRTUAL_SIZE+PEHeader.IMAGE_BASE;
                end;

              StsBar.Panels[1].Text:=msg_process_calls;
              StsBar.Update;
              ExportDetailsLbl.Caption:='';
              ExportDetailsLbl.Update;
              EPB.Min:=0;
              EPB.Max:=(WA.dwLineNum-1) div 100;
              EPB.Position:=0;
              EPB.Update;
              Application.ProcessMessages;

              DeDeDisAsm.PEStream:={BOZA DeDeClasses.}PEStream;
              DeDeDisAsm.RVAConverter.ImageBase:=PEHeader.IMAGE_BASE;
              if bELF then begin
                  DeDeDisAsm.RVAConverter.PhysOffset:=PEHeader.Objects[PEHeader.GetSectionIndex('.text')].PHYSICAL_OFFSET;
                  DeDeDisAsm.RVAConverter.CodeRVA:=PEHeader.Objects[PEHeader.GetSectionIndex('.text')].RVA;
               end
               else begin
                  DeDeDisAsm.RVAConverter.PhysOffset:=PEHeader.Objects[1].PHYSICAL_OFFSET;
                  DeDeDisAsm.RVAConverter.CodeRVA:=PEHeader.Objects[1].RVA;
               end;
              //ss:=RVAConverter.GetPhys(DWORD2HEX(MethRec.dwRVA));
              DeDeDisAsm.RVAConverter:=DeDeDisAsm.RVAConverter;


              //Read and compare to find calls - new engine
              cnt:=0;
              WA.ALF.Seek(0,soFromBeginning);
              Repeat
               b:=WA.LinesData[cnt]+2;
               SetLength(s1,8);
               SetLength(ss1,8);
               // the line can be call line
               if b>=49 then
                begin
                   WA.ALF.Seek(1,soFromCurrent);
                   WA.ALF.ReadBuffer(s1[1],8); ss1:=s1;
                   dw:=HEX2DWORD(ss1);
                   WA.ALF.Seek(25,soFromCurrent);
                   WA.ALF.ReadBuffer(s1[1],4);
                   WA.ALF.Seek(1,soFromCurrent);
                   WA.ALF.ReadBuffer(ss1[1],8);
                   dw1:=HEX2DWORD(ss1);
                   WA.ALF.Seek(b-47,soFromCurrent);

                   // skip RVAs outside the set interval
                   if (dwFrom<=dw) and (dwTo>=dw) then
                      begin
                       if CompareMem(@s1[1],@cont_call_str[1],4) then
                        begin
                          s:=GetSymbolReference(dw1);
                          while length(s)<3 do s:=s+' ';
                          if not (CompareMem(@s[1],@cont_call_str2[1],3)) then
                            begin
                              ParsIT(s,TmpList,ss);
                              if TmpList.Count<>0 then
                               begin
                                 ss:=DWORD2HEX(dw);
                                 WA.AddRefference(ss,Color_B_BLK,'');
                                 for l:=0 to TmpList.Count-2 Do
                                     WA.AddRefference(ss,Color_B_BLK,TmpList[l]);
                                 //WA.AddRefference(ss,Color_B_BLK,'|');
                               end;

                              if TmpList.Count=2 then
                                begin
                                  ss:=DWORD2HEX(dw1);
                                  WA.AddRefference(ss,Color_DB_BLK,'');
                                  WA.AddRefference(ss,Color_DB_BLK,'* Procedure: '+Copy(TmpList[0],17,Length(TmpList[0])-16));
                                  WA.AddRefference(ss,Color_DB_BLK,'|');
                                end;
                            end;
                        end;
                     end; {dwFrom,dwTo check}
                end  {if b>50}
                else WA.ALF.Seek(b,soFromCurrent);

               if cnt mod 100 = 0 then
                  begin
                   EPB.Position:=cnt div 100;
                   EPB.Update;
                   Application.ProcessMessages;
                  end;

               Inc(cnt);
              Until (WA.ALF.Position>=WA.ALF.Size) or (cnt>WA.dwLineNum);



{  Old symbol reference finder
               For idx:=0 to WA.dwLineNum-1 Do
               begin
                 s:=WA.Listing[idx];
                 dw:=HEX2DWORD(Copy(s,40,8));

                 // skip RVAs outside the set interval
                 if dwFrom>dw then continue;
                 if dwTo<dw then continue;

                 s:='';
                 if Copy(s,35,4)='call' then
                  begin
                    //s:=GetSymbolReference(dw);
                    if s<>'|'#13#10 then
                      begin
                        ParsIT(s,TmpList,ss);
                        if TmpList.Count<>0 then
                         begin
                           ss:=Copy(WA.Listing[idx],2,8);
                           WA.AddRefference(ss,Color_B_BLK,'');
                           for l:=0 to TmpList.Count-2 Do
                               WA.AddRefference(ss,Color_B_BLK,TmpList[l]);
                           //WA.AddRefference(ss,Color_B_BLK,'|');
                         end;

                        if TmpList.Count=2 then
                          begin
                            ss:=DWORD2HEX(dw);
                            WA.AddRefference(ss,Color_DB_BLK,'');
                            WA.AddRefference(ss,Color_DB_BLK,'* Procedure: '+Copy(TmpList[0],17,Length(TmpList[0])-16));
                            WA.AddRefference(ss,Color_DB_BLK,'|');
                          end;
                      end;
                  end;

                  if idx mod 100 = 0 then
                    begin
                     EPB.Position:=idx div 100;
                     EPB.Update;
                     Application.ProcessMessages;
                    end;
               end;}
            end;

          ExportDetailsLbl.Caption:='';
          ExportDetailsLbl.Update;
          EPB.Position:=EPB.Max;
          EPB.Update;
          StsBar.Panels[1].Text:=msg_save_alfwpj;
          StsBar.Update;

          if w32CustSetForm.NoBackupCB.Checked then
            begin
             DeleteFile(ChangeFileExt(FS,'.wpj'));
             DeleteFile(ChangeFileExt(FS,'.alf'));
            end
            else begin
             RenameFile(ChangeFileExt(FS,'.wpj'),ChangeFileExt(FS,'.wp~'));
             RenameFile(ChangeFileExt(FS,'.alf'),ChangeFileExt(FS,'.al~'));
            end;

          WA.ReffStrings.Sorted:=True;
          if w32CustSetForm.SaveRefCB.Checked
             then WA.ReffStrings.SaveToFile(ChangeFileExt(FS,'.ref'));
          WA.SaveCopy(ChangeFileExt(FS,'.wpj'));
          tick2:=GetTickCount;
          SavePB.Position:=0;
          SavePB.Update;

          if DeDeDisAsm.sDisAsmErrors<>'' then
            begin
              with TStringList.Create do
                begin
                  Text:=DeDeDisAsm.sDisAsmErrors;
                  SaveToFile(ChangeFileExt(FS,'.err'));
                end;
              ShowMessageFmt('Done with errors.'#13#10+msg_wpjalf_ready+#13#10'Errors saved in '+ExtractFileName(ChangeFileExt(FS,'.err')),
                  [ChangeFileExt(FS,'.wpj'),ChangeFileExt(FS,'.alf'),WA.ReffStrings.Count]);
            end
            else ShowMessageFmt(msg_wpjalf_ready,[ChangeFileExt(FS,'.wpj'),ChangeFileExt(FS,'.alf'),WA.ReffStrings.Count]);
      Finally
        StsBar.Panels[1].Text:=Format(msg_ready_secs,[IntToStr(Trunc((tick2-tick1)/1000))]);
        WA.Free;
        TmpList.Free;
        EPB.Position:=0;
        Screen.Cursor:=crDefault;
        ExportFileName.Clear;
        ExportDetailsLbl.Caption:='';
        DeDeDisAsm.bErrorsAsFile:=False;
      End;
      Application.ProcessMessages;
    end;
end;

procedure TDeDeMainForm.ExportFileNameBeforeDialog(Sender: TObject;
  var Name: String; var Action: Boolean);
var s : String;
begin
 s:=ExtractFileName(FsFileName);
 s:=ChangeFileExt(s,'.wpj');
 ExportFileName.InitialDir:=ExtractFileDir(Application.ExeName)+'\Projects';
 If IDAMAP.Checked
   Then ExportFileNAme.Filter:='MAP file ('+FsProjectName+'.map)|'+FsProjectName+'.map'
   Else ExportFileNAme.Filter:=s+'|'+s;
end;

procedure TDeDeMainForm.FEChange(Sender: TObject);
var s : String;
begin
  //FileEdit.FileName:=FE.Text;
  s:=ExtractFileDir(FileEdit.FileName)+'\dfm.$$$';
  if FileExists(s) then DeleteFile(s);
end;

procedure TDeDeMainForm.MakePEHeader1Click(Sender: TObject);
begin
  //MakePEHForm.ShowModal;
end;

procedure TDeDeMainForm.LoadOffsetInfo;
var s, sf : String;
begin
  //Clear All data before loading DOIs for next version
  //OffsInfArchive.ClearAllData;
  LoadedDOIList.Clear;

  Try
    sf:=sDelphiVersion+'.doi';
    if sDelphiVersion='BCB3' then sf:='d3.doi';
    if sDelphiVersion='BCB4' then sf:='d4.doi';
    if sDelphiVersion='BCB5' then sf:='d5.doi';
    if sDelphiVersion='D6 CLX' then sf:='d6clx.doi';
    s:=ExtractFileDir(Application.ExeName)+'\DSF\'+sf;
    If (FsLoadedDOIFile<>sDelphiVersion) and (FileExists(s)) then
      begin
        DumpstatusLbl.Caption:=Format(msg_loaddoi,[AnsiLowerCase(sf)]);
        DumpstatusLbl.Update;
        Screen.Cursor:=crHourGlass;
        Try
          DeDeClassEmulator.LoadOffsetInfos(s);
          LoadedDOIList.Add(s);
        Finally
          Screen.Cursor:=crDefault;
        End;
        FsLoadedDOIFile:=sDelphiVersion;
      end;

// In future more than 1 DOI file should be possible to be loaded
//  To build 'common.doi' for additional stuff
    s:=ExtractFileDir(Application.ExeName)+'\DSF\common.doi';
    If FileExists(s) then
      begin
        DumpstatusLbl.Caption:=msg_loaddoi;
        DumpstatusLbl.Update;
        DeDeClassEmulator.LoadOffsetInfos(s);
        LoadedDOIList.Add(s);
      end;  
  Except
    ShowMessage('Error Loading '+s);
  End;
end;

procedure TDeDeMainForm.doibClick(Sender: TObject);
begin
  DOIBForm.Show;
end;

procedure TClassesDumper.EnumDFMOffsets;
var i, len : Integer;
    ofs_from, ofs_to : DWORD;
    buffer, classbuffer : Array of byte;
    bFound : Boolean;
    b : Byte;
    s : String;
begin
  //Gets Resource Section Offsetes
  i:=PEHeader.GetSectionIndexEx('.rsrc');
  if i=-1 Then i:=PEHeader.GetSectionIndexByRVA(PEHeader.RESOURCE_TABLE_RVA);

  ofs_from:=PEHeader.Objects[i].PHYSICAL_OFFSET;
  ofs_to:=ofs_from+PEHeader.Objects[i].PHYSICAL_SIZE;

  DFMOffsets.Clear;

  // DFM Magic
  classbuffer[0]:=$54;classbuffer[1]:=$50;classbuffer[2]:=$46;classbuffer[3]:=$30;
  len:=4;

  {BOZA DeDeClasses.}PEStream.Seek(ofs_from,soFromBeginning);
  Repeat
    {BOZA DeDeClasses.}PEStream.Seek(1,soFromCurrent);
    {BOZA DeDeClasses.}PEStream.ReadBuffer(buffer[0],len);
    bFound:=CompareMem(@buffer[0],@classbuffer[0],len);
    if bFound then
      begin
        {BOZA DeDeClasses.}PEStream.ReadBuffer(b,1);
        SetLength(s,b);
        {BOZA DeDeClasses.}PEStream.ReadBuffer(s[1],b);
        DFMOffsets.AddObject(s,Pointer({BOZA DeDeClasses.}PEStream.Position-len));
      end;
    {BOZA DeDeClasses.}PEStream.Seek(-len,soFromCurrent);
    If ({BOZA DeDeClasses.}PEStream.Position mod 1000)=0 Then Application.ProcessMessages;
  Until ({BOZA DeDeClasses.}PEStream.Position>=ofs_to-len);
end;

procedure TDeDeMainForm.PIULDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var C1,C2,C3,C4,C5,C6 : DWORD;
    i : Integer;
begin
    If odSelected in State
      Then Begin
        C1:=clWhite;
        C2:=clGreen xor $00FFFFFF;
        C3:=clRed xor $00FFFFFF;
        C4:=clBlue xor $00FFFFFF;
        C5:=clNavy xor $00FFFFFF;
        C5:=clWhite;
      End
      Else Begin
        C1:=clBlack;
        C2:=clGreen;
        C3:=clRed;
        C4:=clBlue;
        C5:=clNavy;
        C6:=clMaroon;
      End;


  With (Control as TListBox).Canvas Do
    Begin

      If StandartDCUList.IndexOf((Control as TListBox).Items[Index]+'.dcu')=-1
         then (Control as TListBox).Canvas.Font.Color:=C4
         else (Control as TListBox).Canvas.Font.Color:=C1;

       for i:=0 to DCULV.Items.Count-1 Do
          if DCULV.Items[i].Caption=(Control as TListBox).Items[Index] then
            begin
              (Control as TListBox).Canvas.Font.Color:=C6;
              break;
            end;


      FillRect(Rect);
      TextOut(Rect.Left + 2, Rect.Top, (Control as TListBox).Items[Index]);
    End;
end;

procedure TDeDeMainForm.ExportFileNameAfterDialog(Sender: TObject;
  var Name: String; var Action: Boolean);
var f : TFileStream;
    alf,wpj : String;
begin
  Action:=True;
  if IDAMAP.Checked then exit;

  Action:=False;

  wpj:=Name;
  alf:=ChangeFileExt(wpj,'.alf');

  If not (FileExists(alf) and FileExists(wpj)) then
     begin
       if REF.Checked then ShowMessage(err_disasm_first);
       Exit;
     end;
  Action:=True;
end;

procedure TDeDeMainForm.CustomCBClick(Sender: TObject);
var i : Integer;
begin
  If (Not FbProcessed) or (FbFailed) Then
    begin
      ShowMessage(err_process1st);
           CustomCB.OnClick:=nil;
           try
             CustomCB.Checked:=False;
           finally
             CustomCB.OnClick:=CustomCBClick;
           end;
      Exit;
    end;
    
  if CustomCB.Checked then
    begin
      if (w32CustSetForm.FromRVA.Text='')
         or (MessageDlg(msg_reset_adj_sett,mtConfirmation,[mbYes,mbNo],0)=mrYes)
        then begin
          w32CustSetForm.SelectedLB.Items.Clear;
          w32CustSetForm.SkipLB.Items.Clear;
          w32CustSetForm.dwRVAFrom:=PEHeader.Objects[1].RVA+PEHeader.IMAGE_BASE;
          w32CustSetForm.dwRVATo:=PEHeader.Objects[1].RVA+PEHeader.Objects[1].VIRTUAL_SIZE+PEHeader.IMAGE_BASE;
          For i:=0 To DCULV.Items.Count-1 do
                w32CustSetForm.SelectedLB.Items.Add(TClassDumper(DCULV.Items[i].Data).FsClassName);
        end;
      w32CustSetForm.ShowModal;
      if w32CustSetForm.bSet then
         begin
           AllCallsCB.Enabled:=False;
         end
         else begin
           CustomCB.OnClick:=nil;
           try
             CustomCB.Checked:=False;
           finally
             CustomCB.OnClick:=CustomCBClick;
           end;
         end;
    end
    else begin
      AllCallsCB.Enabled:=True;
    end;
end;



procedure TDeDeMainForm.DSFSpy1Click(Sender: TObject);
var idx : Integer;
begin
  idx:=PEHeader.GetSectionIndexEx('CODE');
  SpyDebugForm.dwBeg:=PEHeader.IMAGE_BASE+PEHeader.Objects[idx].RVA;
  SpyDebugForm.dwEnd:=SpyDebugForm.dwBeg+PEHeader.Objects[idx].VIRTUAL_SIZE;
  SpyDebugForm.ShowModal;
end;


procedure TDeDeMainForm.LoadDeDeRES;
begin
    // Main Menu
    MMenu.Items[0].Caption:=mm_file;
    MMenu.Items[0].Items[0].Caption:=mm_file_process;
    MMenu.Items[0].Items[2].Caption:=mm_file_open_project;
    MMenu.Items[0].Items[3].Caption:=mm_file_save_project;
    MMenu.Items[0].Items[4].Caption:=mm_file_save_project_as;
    MMenu.Items[0].Items[6].Caption:=mm_file_loadsym;
    MMenu.Items[0].Items[8].Caption:=mm_file_exit;
    MMenu.Items[1].Caption:=mm_dumpers;
    MMenu.Items[1].Items[0].Caption:=mm_dumpers_bpl;
    MMenu.Items[1].Items[1].Caption:=mm_dumpers_dcu;
    MMenu.Items[2].Caption:=mm_tools;
    MMenu.Items[2].Items[0].Caption:=mm_tools_peedit;
    //MMenu.Items[2].Items[1].Caption:=mm_tools_peheadcon;
    MMenu.Items[2].Items[3].Caption:=mm_tools_dump_active;
    MMenu.Items[2].Items[5].Caption:=mm_tools_doibuild;
    MMenu.Items[2].Items[7].Caption:=mm_tools_rvaconv;
    MMenu.Items[2].Items[8].Caption:=mm_tools_opcodeasm;
    MMenu.Items[3].Caption:=mm_options;
    MMenu.Items[3].Items[0].Caption:=mm_options_symbols;
    MMenu.Items[3].Items[1].Caption:=mm_options_config;
    MMenu.Items[3].Items[2].Caption:=mm_options_languages;

    MMenu.Items[4].Caption:=mm_about;

    // Popup menus
    svrvspu.Items[0].Caption:=pm_svrvspu_1;

    rvapu.Items[0].Caption:=pm_rvapu_copy_rva;
    rvapu.Items[2].Caption:=pm_rvapu_showadddata;
    rvapu.Items[4].Caption:=pm_rvapu_disassemble;

    DFMListPopUp.Items[0].Caption:=pm_DFMListPopUp_0;
    DFMListPopUp.Items[2].Caption:=pm_DFMListPopUp_2;
    DFMListPopUp.Items[3].Caption:=pm_DFMListPopUp_3;
    DFMListPopUp.Items[4].Caption:=pm_DFMListPopUp_4;

    // Tab Controls
    uts.Caption:=tab_mpc_uts;
    fmts.Caption:=tab_mps_fmts;
    dts.Caption:=tab_mps_dts;
    fts.Caption:=tab_mps_fts;
    TabSheet1.Caption:=tab_mps_xp;

    TabSheet4.Caption:=tab_2_ev;
    TabSheet5.Caption:=tab_2_ctrl;

    // Listviews
    ClassesLV.Columns[0].Caption:=lv_ClassesLV_col0;
    ClassesLV.Columns[1].Caption:=lv_ClassesLV_col1;
    ClassesLV.Columns[2].Caption:=lv_ClassesLV_col2;
    ClassesLV.Columns[3].Caption:=lv_ClassesLV_col3;

    DFMList.Columns[0].Caption:=lv_DFMList_col0;
    DFMList.Columns[1].Caption:=lv_DFMList_col1;

    DCULV.Columns[0].Caption:=lv_DCULV_col0;
    DCULV.Columns[1].Caption:=lv_DCULV_col1;

    EventLV.Columns[0].Caption:=lv_EventLV_col0;
    EventLV.Columns[1].Caption:=lv_EventLV_col1;
    EventLV.Columns[2].Caption:=lv_EventLV_col2;

    ControlsLV.Columns[0].Caption:=lv_ControlsLV_col0;
    ControlsLV.Columns[1].Caption:=lv_ControlsLV_col1;

    // LABELS
    Label1.Caption:=lbl_MainForm_Label1;
    Label2.Caption:=lbl_MainForm_Label2;
    Label3.Caption:=lbl_MainForm_Label3;
    Label4.Caption:=lbl_MainForm_Label4;
    Label5.Caption:=lbl_MainForm_Label5;
    cbDFM.Caption:=lbl_MainForm_cbDFM;
    cbPAS.Caption:=lbl_MainForm_cbPAS;
    cbDPR.Caption:=lbl_MainForm_cbDPR;
    cbTXT.Caption:=lbl_MainForm_cbTXT;
    REF.Caption:=lbl_MainForm_REF;
    IDAMAP.Caption:=lbl_MainForm_IDAMAP;
    AllStrCB.Caption:=lbl_MainForm_AllStrCB;
    AllCallsCB.Caption:=lbl_MainForm_AllCallsCB;
    CustomCB.Caption:=lbl_MainForm_CustomCB;
    RVACB.Caption:=lbl_MainForm_RVACB;
    ControlCB.Caption:=lbl_MainForm_ControlCB;
    PrcsBtn.Caption:=lbl_MainForm_PrcsBtn;
    crtBtn.Caption:=lbl_MainForm_ctrBtn;
    Button1.Caption:=lbl_MainForm_Button1;

end;




procedure TDeDeMainForm.DCULVChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  DCULVClick(self);
end;

procedure TDeDeMainForm.crtBtnMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if ssCtrl in Shift then GlobDontCutStringReferences:=not GlobDontCutStringReferences;
end;

function TDeDeMainForm.ClassRefInCode(Offs: DWORD; var s: String): Boolean;
var beg, en : DWORD;
    bt, len : Byte;
    ch : Char;
    bStrMode : Boolean;
begin
  beg:=RVAConverter.GetPhys(Offs);
  en:=beg+iCLASS_REF_IN_CODE_SEEK_LENGTH;
  Result:=False;
  With PEFile.PEStream Do
    Begin
      BeginSearch;
      Try
        s:='';len:=0;
        Seek(beg,soFromBeginning);
        While Position<en Do
         Begin
           ReadBuffer(ch,1);

           if bStrMode
             then
              if ch in ['A'..'Z','a'..'z','0'..'9','_']
                 then s:=s+ch
                 else begin
                   bStrMode:=False;
                   if (len=Length(s)) and (len>2) then
                     begin
                       Result:=True;
                       Exit;
                     end;
                 end;

           if not bStrMode
             then begin
              if (ch<#$20) and (ch<>#0) then
               begin
                 bStrMode:=True;
                 len:=ORD(ch);
                 s:='';
               end;
             end;

         End; {While}

      Finally
        EndSearch;
      End;
    End;
end;

procedure TDeDeMainForm.Analizethisclass1Click(Sender: TObject);
begin
  if Not FbProcessed Then Exit; 
  AnalyzForm.ShowModal;
end;

procedure TDeDeMainForm.FormActivate(Sender: TObject);
var s : String;
begin
  s:=ParamStr(1);
  if s='more' then
    begin
      DOIBForm.bParser:=True;
    end;

  if (FileExists(s)) and (LowerCase(ExtractFileExt(s))='.exe') then
    begin
      FE.Text:=s;
      FileEdit.FileName:=s;
      DoItTimer.Enabled:=True;
    end;
end;

procedure TDeDeMainForm.DeleteTimerTimer(Sender: TObject);
begin
  DeleteTimer.Enabled:=False;
  If FileExists(FsTEMPDir+'\dfm.$$$') then DeleteFile(FsTEMPDir+'\dfm.$$$');
end;

procedure TDeDeMainForm.De1Click(Sender: TObject);
begin
  with SpyDebugForm Do
   begin
    dwBeg:=PEHeader.Objects[1].RVA+PEHeader.IMAGE_BASE;
    dwEnd:=dwBeg+PEHeader.Objects[1].VIRTUAL_SIZE;
    SpyDebugForm.ShowModal;
   end;
end;



//////////////////////////////////////////////////////
//// PLUGINS INTERFACE ///////////////////////////////
////
//////////////////////////////////////////////////////
function GetPhys(dw : DWORD) : DWORD;
begin
  Result:=dw-PEHeader.IMAGE_BASE
            -PEHeader.Objects[1].RVA
            +PEHeader.Objects[1].PHYSICAL_OFFSET;
end;


function GetByte(dwVirtOffset : DWORD) : Byte;
var b : Byte;
begin
  PEStream.BeginSearch;
  try
    PEStream.Seek(GetPhys(dwVirtOffset), soFromBeginning);
    PEStream.ReadBuffer(b,1);
    Result:=b;
  finally
    PEStream.EndSearch;
  end;
end;

function GetWord(dwVirtOffset : DWORD) : Word;
var w : WORD;
begin
  PEStream.BeginSearch;
  try
    PEStream.Seek(GetPhys(dwVirtOffset), soFromBeginning);
    PEStream.ReadBuffer(w,2);
    Result:=w;
  finally
    PEStream.EndSearch;
  end;
end;

function GetDWORD(dwVirtOffset : DWORD) : DWORD;
var dw : DWORD;
begin
  PEStream.BeginSearch;
  try
    PEStream.Seek(GetPhys(dwVirtOffset), soFromBeginning);
    PEStream.ReadBuffer(dw,4);
    Result:=dw;
  finally
    PEStream.EndSearch;
  end;
end;

function GetPascalString(dwVirtOffset : DWORD) : String;
var sz : Byte;
    s : String;
begin
  PEStream.BeginSearch;
  try
    PEStream.Seek(GetPhys(dwVirtOffset), soFromBeginning);
    PEStream.ReadBuffer(sz,1);
    SetLength(s,sz);
    PEStream.ReadBuffer(s[1],sz);
    Result:=s;
  finally
    PEStream.EndSearch;
  end;
end;

procedure GetBinaryData(var buffer : Array of Byte; size : Integer; dwVirtOffset : DWORD);
begin
  PEStream.BeginSearch;
  try
    PEStream.Seek(GetPhys(dwVirtOffset), soFromBeginning);
    PEStream.ReadBuffer(buffer[0],size);
  finally
    PEStream.EndSearch;
  end;
end;

Function Disassemble(dwVirtOffset : DWORD; var sInstr : String; var size : Integer) : Boolean;
Var PC, ins, dta, sof : String;
    sz : Integer;
    dwdta : LongInt;
    idx : Integer;
begin
  PEStream.BeginSearch;
  try
    PEStream.Seek(GetPhys(dwVirtOffset), soFromBeginning);
    SetLength(pc,17);
    PEStream.ReadBuffer(pc[1],16);
    ins:=PlugIn_DASM.GetInstruction(PChar(pc),sz);

    Size:=sz;
    sInstr:=ins;

    if bPlugInsFixRelative then
      begin
        dta:=Copy(ins,9,Length(ins)-8);
        ins:=Copy(ins,1,8); ins:=Trim(ins);
        If DeDeDisASM.OffsetShouldCorrect(ins) Then
         Begin
           Case dta[1] of
             '-' : idx:=-1;
             '+' : idx:=1
             else Exit;
           End;

           sof:=Copy(dta,3,Length(dta)-2);
           dwdta:=idx*HEX2DWORD(sof);
           dwdta:=dwdta+dwVirtOffset+sz;
           while Length(ins)<8 do ins:=ins+' ';
           ins:=ins+DWORD2HEX(dwdta);
           sInstr:=ins;
         End;
       end;

  finally
    PEStream.EndSearch;
  end;
end;

function CorrectParams(sName,sUnit : String; mode : Byte) : string;
var iPrnPos : Integer;
begin
  result:='';

  if (mode and REF_MODE_INCLUDE_UNIT) <> 0 then result:=sUnit+'.'+result;

  iPrnPos:=Pos('(',sName);
  if (mode and REF_MODE_INCLUDE_PARENS) <> 0 then
    if (mode and REF_MODE_INCLUDE_PARAMS) <> 0
          then
          else sName:=Copy(sName,1,iPrnPos-1)+'()';

  result:=result+sName;
end;

Function GetCallReference(dwVirtOffset : DWORD; var sReference : String; var btRefType : Byte; btMode : Byte = 0) : Boolean;
var w : word;
    inst : TClassDumper;
    methrec : TMethodRec;
    i, j : Integer;
    buff,buff1 : TSymBuffer;
    bk,phys : Cardinal;
    Sym : TDeDeSymbol;
    s,sc : String;
    b : Byte;
    dw : DWORD;
begin
  if dwVirtOffset=0 then exit;
  
  PEStream.BeginSearch;
  try
    For i:=0 to ClsDmp.Classes.Count-1 Do
      begin
        inst:=TClassDumper(ClsDmp.Classes[i]);
        For j:=0 to inst.MethodData.Count-1 do
          begin
            methrec:=TMethodRec(inst.MethodData.Methods[j]);
            if methrec.dwRVA=dwVirtOffset then
               begin
                 // Published Reference
                 btRefType:=REF_TYPE_PUBLISHED;
                 sReference:=CorrectParams(inst.FsClassName+'.'+methrec.sName,inst.FsUnitName,btMode);

                 exit;
               end;
          end;
      end;

    PEStream.Seek(GetPhys(dwVirtOffset), soFromBeginning);
    Try
      PEStream.ReadBuffer(w,2);
    Except
    End;
    if w=$25FF then  begin
       // Possible Import reference
        PEStream.ReadBuffer(dw,4);
        sc:=GetImportReference(DWORD2HEX(dw));

       if sc<>'' then
         begin
           btRefType:=REF_TYPE_IDATA;
           sReference:=CorrectParams(sc,'',btMode);
           exit;
         end;
      end;

    /////////////////////////////////////////////////////
    // DSF References
    /////////////////////////////////////////////////////
    sc:=DeDeDisAsm.GetSymbolReference(dwVirtOffset);
  (*
    PEStream.Seek(GetPhys(dwVirtOffset), soFromBeginning);
    // reads the procedure bytes in buff1
    PEStream.ReadBuffer(buff[1],_PatternSize);
    // Makes the buffer in DSF format
    UnlinkCalls(buff,0,dwVirtOffset);
    sc:='';
    // Loops among the all loaded symbols
    For i:=0 To SymbolsList.Count-1 Do
      Begin
        // Gets a symbol
        Sym:=TDeDeSymbol(SymbolsList[i]);

        // the current symbol file is not for the current Delphi version
        // so process next DSF
        if (Sym.Mode and DelphiVestionCompability)=0 then Continue;

        // initializes the streams
        Sym.Sym.Seek(0,soFromBeginning);
        Sym.Str.Seek(0,soFromBeginning);
        // Loops among the entries
        For j:=0 To Sym.Count-1 Do
          Begin
            // Reads the pattern
            Sym.Sym.ReadBuffer(buff1[1],_PatternSize);
            // and compare it to buff1
            If CompareMem(@buff[1],@buff1[1],_PatternSize) Then
               Begin
                 // If equal, then a reference is found
                 // goes to the offset of the procedure name
                 // in the DeDeSymbol object
                 Sym.Str.Seek(Sym.Index[j],soFromBeginning);
                 Sym.Str.ReadBuffer(b,1);
                 SetLength(s,b);
                 // Reads the procedure name
                 Sym.Str.ReadBuffer(s[1],b);
                 if sc=''
                   then sc:=CorrectParams(s,'',btMode)
                   else
                     if (btMode and REF_MODE_ALL_REFS)<>0 then sc:=sc+#13+CorrectParams(s,'',btMode)
                                                          else exit;
               End;
           End; {for j}
     End;{for i}
 *)
     if sc<>'' then begin
       sReference:=sc;
       btRefType:=REF_TYPE_DSF;
     end;
     
  finally
     PEStream.EndSearch;
  end;
end;

Function GetObjectName(dwVirtOffset : DWORD; var sObjName : String) : Boolean;
begin
  Result:=ASMShow._GetObjectName(dwVirtOffset,sObjName);
end;

Function GetFieldReference(dwVirtOffset : DWORD; var sReference : String) : Boolean;
begin
  Result:=ASMShow._GetFieldReference(dwVirtOffset,sReference);
end;



Function GetDeDe_FunctionsList : TFunctionPointerListArray;
begin
   GetDeDe_FunctionsList[nDisassemble]:=@Disassemble;
   GetDeDe_FunctionsList[nGetByte]:=@GetByte;
   GetDeDe_FunctionsList[nGetWord]:=@GetWord;
   GetDeDe_FunctionsList[nGetDWORD]:=@GetDWORD;
   GetDeDe_FunctionsList[nGetPascalString]:=@GetPascalString;
   GetDeDe_FunctionsList[nGetBinaryData]:=@GetBinaryData;
   GetDeDe_FunctionsList[nGetCallReference]:=@GetCallReference;
   GetDeDe_FunctionsList[nGetObjectName]:=@GetObjectName;
   GetDeDe_FunctionsList[nGetFieldReference]:=@GetFieldReference;
end;

Function LoadPlugInsFromDLL(ADllName : String) : Boolean;
var hM : HMODULE;
    GetPlgInf : TGetPlugInfoProc;
    GetVer    : TGetPlugVerProc;
    IntPlgIn  : TInitPlugInProc;
    StartPlg  : TStartPlugInProc;
    GetPlgCount : TGetPlugCountProc;
    pIntPlgIn, pGetVer, pGetPlgInf, pStartPlg, pGetPlgCount : Pointer;

    PlugInfo : Array of TPlugInfoRec;
    PlugCount, i : Integer;
begin
    Result:=False;

    hM:=LoadLibrary(PChar(ADllName));
    if (hM=0) or (hM=INVALID_HANDLE_VALUE) then Exit;

    pIntPlgIn:=GetProcAddress(hM,PChar(InitPlugInProc_Name));
    pGetVer:=GetProcAddress(hM,PChar(GetPlugVerProc_Name));
    pGetPlgInf:=GetProcAddress(hM,PChar(GetPlugInfoProc_Name));
    pStartPlg:=GetProcAddress(hM,PChar(StartPlugInProc_Name));
    pGetPlgCount:=GetProcAddress(hM,PChar(GetPlugCountProc_Name));

    if (pIntPlgIn=nil) or (pGetVer=nil) or (pGetPlgInf=nil) or (pStartPlg=nil) or (pGetPlgCount=nil) then Exit;

    IntPlgIn:=pIntPlgIn;
    GetVer:=pGetVer;
    GetPlgInf:=pGetPlgInf;
    StartPlg:=pStartPlg;
    GetPlgCount:=pGetPlgCount;

    PlugCount:=GetPlgCount;
    SetLength(PlugInfo,PlugCount);
    GetPlgInf(PlugInfo);

    For i:=0 To PlugCount-1 Do
      Begin
        if DeDePlugins_Count=MAX_LOADED_PLUGINS then
          begin
            ShowMessage('Loaded plugins list is full!');
            exit;
          end;
        Inc(DeDePlugins_Count);
        DeDePlugins_PluginsArray[DeDePlugins_Count].Handle:=hM;
        DeDePlugins_PluginsArray[DeDePlugins_Count].DLL_NAME:=ADllName;
        DeDePlugins_PluginsArray[DeDePlugins_Count].InternalIndex:=i+1; // It is 1-based
        DeDePlugins_PluginsArray[DeDePlugins_Count].StartPlugInProc:=pStartPlg;
        DeDePlugins_PluginsArray[DeDePlugins_Count].PlugInType:=PlugInfo[i].PlugType;
        DeDePlugins_PluginsArray[DeDePlugins_Count].sPlugInName:=PlugInfo[i].PlugName;
        DeDePlugins_PluginsArray[DeDePlugins_Count].sPlugInVersion:=PlugInfo[i].PlugVersion;
      End;

    IntPlgIn(GetDeDe_FunctionsList);
    Result:=True;
end;

Procedure PlugIn_AddressRefProc(Param: Pointer; ValueAddress, RefAddress: PChar; var Result: string);
begin
end;

//////////////////////////////////////////////////////


procedure TDeDeMainForm.UnitDataLVChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var inst : TStringList;
    i : Integer;
    lst : TListItem;
begin
  if UnitDataLV.Selected=nil then exit;
  inst:=TStringList(UnitDataLV.Selected.Data);
  With UnitsDataClassesLV Do
    begin
      Try
        Items.BeginUpdate;
        Items.Clear;
        For i:=0 to inst.count-1 do
          begin
            lst:=Items.Add;
            lst.Caption:=inst[i];
          end;
      Finally
        Items.EndUpdate;
      End;
    end;
end;

procedure TDeDeMainForm.Saveunitdataasbinaryfile1Click(Sender: TObject);
var rva1, rva2, ps1 : DWORD;
    ii : Integer;
    MemStr : TMemoryStream;
    b : Byte;
begin
  if UnitDataLV.Selected=nil then exit;
  ii:=UnitDataLV.Items.IndexOf(UnitDataLV.Selected);
  if ii=UnitDataLV.Items.Count-1 then exit;

  rva1:=HEX2DWORD(UnitDataLV.Items[ii].SubItems[0]);
  rva2:=HEX2DWORD(UnitDataLV.Items[ii+1].SubItems[0]);

  ps1:=RVAConverter.GetPhys(rva1);

  MemStr:=TMemoryStream.Create;
  PEStream.BeginSearch;
  Try
    PEStream.Seek(ps1,soFromBeginning);
    For ii:=1 to rva2-rva1 do
     begin
       PEStream.ReadBuffer(b,1);
       MemStr.WriteBuffer(b,1);
     end;
    With SaveDlg Do
     Try
       Filter:='Binary Files (*.bin)|*.bin';
       If Execute Then MemStr.SaveToFile(FileName);
     Finally
       Filter:='DeDe Project Files (*.dede)|*.dede'
     end;
  Finally
    MemStr.Free;
    PEStream.EndSearch;
  End;
end;

procedure TDeDeMainForm.DoItTimerTimer(Sender: TObject);
begin
  DoItTimer.Enabled:=False;
  PreBtnClick(Self);
end;

// [ LC ]
// This Method is not used anymore. Use TDeDeMainForm.FreePlugIns 
procedure UnloadPluginDll(idx : integer);
var
  hM : HMODULE;
  i, j : integer;
begin
  hM := DeDePlugins_PluginsArray[idx].Handle;
  i := 1;
  while i <= DeDePlugins_Count do begin
     if DeDePlugins_PluginsArray[i].Handle = hM then begin
        dec(DeDePlugins_Count);
        for j:=i to DeDePlugins_Count do begin
           DeDePlugins_PluginsArray[j]:=DeDePlugins_PluginsArray[j + 1];
        end; { for }
        PrefsForm.PlugInLB.Selected[i - 1] := true;
     end else begin
        inc(i);
     end; { if }
  end; { while }
  FreeLibrary(hM);
end;

procedure TDeDeMainForm.LoadProjectFile1Click(Sender: TObject);
begin
   ShowMessage('Not implemented yet!'); Exit;
   DeDeProjectOpenDialog.FileName := ExtractFileNameWOExt(FsFileName) + '.dpj';
   DeDeProjectOpenDialog.InitialDir := ExtractFilePath(FsFileName);
   if DeDeProjectOpenDialog.Execute then begin
      DeDeProjectFileName:=DeDeProjectOpenDialog.FileName;
      DeDeDPJEng.LoadDPJFile(DeDeProjectFileName);
   end; { if }
end;

procedure TDeDeMainForm.SaveProjectFile1Click(Sender: TObject);
begin
   ShowMessage('Not implemented yet!'); Exit;
   if Trim(DeDeProjectFileName) <> '' then begin
      DeDeDPJEng.SaveDPJFile(DeDeProjectFileName);
   end else begin
      SaveProjectFileAs1Click(Sender);
   end; { if }
end;

procedure TDeDeMainForm.SaveProjectFileAs1Click(Sender: TObject);
var
   ext : string;
begin
   ShowMessage('Not implemented yet!'); Exit;
   DeDeProjectSaveDialog.InitialDir := ExtractFilePath(FsFileName);
   DeDeProjectSaveDialog.FileName := ExtractFileNameWOExt(FsFileName) + '.dpj';
   if DeDeProjectSaveDialog.Execute then begin
      DeDeProjectFileName:=DeDeProjectSaveDialog.FileName;
      ext:=Trim(ExtractFileExt(DeDeProjectFileName));
      if ext = '' then DeDeProjectFileName:=ExtractFileName(DeDeProjectFileName) + '.dpj';
      if FileExists(DeDeProjectFileName) then
         if MessageBox(0, 'Overwrite', 'File already exists.', MB_YESNO + MB_ICONWARNING) = IDNO then exit;
      DeDeDPJEng.SaveDPJFile(DeDeProjectFileName);
 
   end; { if }
end;

procedure TDeDeMainForm.ChangeLanguage(Sender: TObject);
var s : String;
    i : Integer;
begin
  s:=(Sender as TMenuItem).Caption+'.ini';
  sLanguageFile:='';
  For i:=1 to length(s) do  if not (s[i] in ['&']) then sLanguageFile:=sLanguageFile+s[i];
  SaveRegistryData(nil, True);
  LoadResourcesFromIniFile(ExtractFileDir(Application.ExeName)+'\LANGRES\'+sLanguageFile);
  LoadDeDeRES;
  (Sender as TMenuItem).Checked:=True;
end;

procedure TDeDeMainForm.LoadLangMenuItems;
var mi : TMenuItem;
    sr : TSearchRec;

   procedure AddItem(sCaption : String);
   begin
      mi:=TMenuItem.Create(LanguagesMI);
      mi.Caption:=UpperCase(sCaption);
      mi.OnClick:=ChangeLanguage;
      mi.RadioItem:=True;
      LanguagesMI.Add(mi);
      if (UpperCase(sLanguageFile)=UpperCase(sCaption+'.ini')) then mi.Checked:=True;
   end;

begin
  LanguagesMI.Clear;
  if FindFirst(ExtractFileDir(Application.ExeName)+'\LANGRES\*.ini',faAnyFile,sr)=0 then AddItem(ChangeFileExt(sr.Name,''));
  While FindNext(sr)=0 do AddItem(ChangeFileExt(sr.Name,''));
  FindClose(sr);
end;

procedure TClassesDumper.GetBufferForDPJSave(var buff: array of byte;
  var size: Integer);
var OutPut : TMemoryStream;
    dw, clid : DWORD;
    s : String;
    i,j, idx : Integer;
    bf, localbuf : array of byte;
    bfsz : integer;
    bt : Byte;
    cls : TClassDumper;
    fld : TFieldRec;
    mth : TMethodRec;

   procedure WriteBuffer(const Buffer; Count : Integer);
   var len : Integer;
   begin
     len:=Length(localbuf);
     SetLength(localbuf,len+Count);
     Move(Buffer, localbuf[len], Count);
   end;

   procedure StoreStringList(sl : TStringList);
   var idx : Integer;
       ib : Integer;
   begin
     ib:=sl.Count;
     {OutPut.}WriteBuffer(ib,4);
     for idx:=0 to sl.Count-1 do
       begin
         ib:=Length(sl[idx]);
         {OutPut.}WriteBuffer(ib,4);
         {OutPut.}WriteBuffer(sl[idx][1],ib);
         ib:=DWORD(sl.Objects[idx]);
         {OutPut.}WriteBuffer(ib,4);
       end;
   end;



begin
  // DFMTXTDATA_Names
  dw:=Length(DFMTXTDATA_Names);
  {OutPut.}WriteBuffer(dw,4);
  for i:=0 to dw-1 do
    begin
      j:=Length(DFMTXTDATA_Names);
      {OutPut.}WriteBuffer(j,4);
      {OutPut.}WriteBuffer(DFMTXTDATA_Names[i][1],j);
    end;

  // DFMTXTDATA
  dw:=DFMTXTDATA.Count;
  {OutPut.}WriteBuffer(dw,4);
  for i:=0 to dw-1 do StoreStringList(TStringList(DFMTXTDATA[i]));

  // FiZeroCount
  {OutPut.}WriteBuffer(FiZeroCount,4);

  // DFMOffsets StringList
  StoreStringList(DFMOffsets);

  // PackageInfoTable
  {OutPut.}WriteBuffer(PackageInfoTable.dwUnitCount,4);
  {OutPut.}WriteBuffer(PackageInfoTable.dwPhysOffs,4);
  dw:=Length(PackageInfoTable.UnitsStartPtrs);
  {OutPut.}WriteBuffer(dw,4);
  for i:=0 to dw-1 do
    begin
      j:=PackageInfoTable.UnitsStartPtrs[i];
      {OutPut.}WriteBuffer(j,4);
    end;
  dw:=Length(PackageInfoTable.UnitsInitPtrs);
  {OutPut.}WriteBuffer(dw,4);
  for i:=0 to dw-1 do
    begin
      j:=PackageInfoTable.UnitsInitPtrs[i];
      {OutPut.}WriteBuffer(j,4);
    end;
  dw:=Length(PackageInfoTable.UnitsFInitPtrs);
  {OutPut.}WriteBuffer(dw,4);
  for i:=0 to dw-1 do
    begin
      j:=PackageInfoTable.UnitsFInitPtrs[i];
      {OutPut.}WriteBuffer(j,4);
    end;
  StoreStringList(PackageInfoTable.UnitsNames);
  dw:=PackageInfoTable.ClassesList.Count;
  {OutPut.}WriteBuffer(dw,4);
  for i:=0 to dw-1 do StoreStringList(TStringList(PackageInfoTable.ClassesList[i]));

  // BSS with all data
  dw:=BSS.dwStartRVA;{OutPut.}WriteBuffer(dw,4);
  dw:=BSS.dwSize;{OutPut.}WriteBuffer(dw,4);
  dw:=BSS.dwDATAStartRVA;{OutPut.}WriteBuffer(dw,4);
  dw:=BSS.dwDATASize;{OutPut.}WriteBuffer(dw,4);
  BSS.GetProtectedDataForDPJSave(bf,bfsz);
  SetLength(bf,bfsz);
  BSS.GetProtectedDataForDPJSave(bf,bfsz);
  {OutPut.}WriteBuffer(bfsz,4);
  {OutPut.}WriteBuffer(bf[0],bfsz);

  // Classes Data
  dw:=Classes.Count;
  {OutPut.}WriteBuffer(dw,4);
  for clid:=0 to Classes.Count-1 do
    begin
      cls:=TClassDumper(Classes[i]);

      dw:=cls.FdwBSSOffset.Count;
      {OutPut.}WriteBuffer(dw,4);
      for i:=0 to dw-1 do
        begin
          j:=DWORD(cls.FdwBSSOffset[i]);
          {OutPut.}WriteBuffer(j,4);
        end;

      dw:=cls.FdwHeapPtr.Count;
      {OutPut.}WriteBuffer(dw,4);
      for i:=0 to dw-1 do
        begin
          j:=DWORD(cls.FdwHeapPtr[i]);
          {OutPut.}WriteBuffer(j,4);
        end;

      dw:=cls.FdwDATAPrt.Count;
      {OutPut.}WriteBuffer(dw,4);
      for i:=0 to dw-1 do
        begin
          j:=DWORD(cls.FdwDATAPrt[i]);
          {OutPut.}WriteBuffer(j,4);
        end;


      {OutPut.}WriteBuffer(cls.FdwSelfPrt,4);
      {OutPut.}WriteBuffer(cls.FdwSelfPrtPos,4);
      j:=Length(cls.FsClassName);
      {OutPut.}WriteBuffer(j,4);
      {OutPut.}WriteBuffer(cls.FsClassName[1],j);
      j:=Length(cls.FsUnitName);
      {OutPut.}WriteBuffer(j,4);
      {OutPut.}WriteBuffer(cls.FsUnitName[1],j);
      {OutPut.}WriteBuffer(cls.FbClassFlag,1);
      {OutPut.}WriteBuffer(cls.FdwVMTPtr,4);
      {OutPut.}WriteBuffer(cls.FdwVMTPos,4);
      {OutPut.}WriteBuffer(cls.FdwVMTPtr2,4);
      {OutPut.}WriteBuffer(cls.FdwInterfaceTlbPtr,4);
      {OutPut.}WriteBuffer(cls.FdwAutomationTlbPtr,4);
      {OutPut.}WriteBuffer(cls.FdwInitializationTlbPtr,4);
      {OutPut.}WriteBuffer(cls.FdwInformationTlbPtr,4);
      {OutPut.}WriteBuffer(cls.FdwFieldDefTlbPtr,4);
      {OutPut.}WriteBuffer(cls.FdwMethodDefTlbPtr,4);
      {OutPut.}WriteBuffer(cls.FdwDynMethodsTlbPtr,4);
      {OutPut.}WriteBuffer(cls.FdwInterfaceTlbPos,4);
      {OutPut.}WriteBuffer(cls.FdwAutomationTlbPos,4);
      {OutPut.}WriteBuffer(cls.FdwInitializationTlbPos,4);
      {OutPut.}WriteBuffer(cls.FdwInformationTlbPos,4);
      {OutPut.}WriteBuffer(cls.FdwFieldDefTlbPos,4);
      {OutPut.}WriteBuffer(cls.FdwMethodDefTlbPos,4);
      {OutPut.}WriteBuffer(cls.FdwDynMethodsTlbPos,4);
      {OutPut.}WriteBuffer(cls.FdwClassNamePos,4);
      {OutPut.}WriteBuffer(cls.FdwClassNamePtr,4);
      {OutPut.}WriteBuffer(cls.FdwClassSize,4);
      {OutPut.}WriteBuffer(cls.FdwAncestorPtrPtr,4);
      {OutPut.}WriteBuffer(cls.FdwSafecallExceptionMethodPtr,4);
      {OutPut.}WriteBuffer(cls.FdwDefaultHandlerMethodPtr,4);
      {OutPut.}WriteBuffer(cls.FdwNewInstanceMethodPtr,4);
      {OutPut.}WriteBuffer(cls.FdwFreeInstanceMethodPtr,4);
      {OutPut.}WriteBuffer(cls.FdwDestroyDestructorPtr,4);
      {OutPut.}WriteBuffer(cls.FdwDFMOffset,4);
      {OutPut.}WriteBuffer(cls.FdwFirstProcRVA,4);

      dw:=cls.FieldData.Count;
      {OutPut.}WriteBuffer(dw,4);
      dw:=cls.FieldData.Ptr;
      {OutPut.}WriteBuffer(dw,4);
      for idx:=0 to cls.FieldData.Count-1 do
        begin
          fld:=TFieldRec(cls.FieldData.Fields[idx]);
          dw:=Length(fld.sName);
          {OutPut.}WriteBuffer(dw,4);
          {OutPut.}WriteBuffer(fld.sName[1],dw);
          {OutPut.}WriteBuffer(fld.dwID,4);
          {OutPut.}WriteBuffer(fld.wFlag,4);
        end;

      dw:=cls.MethodData.Count;
      {OutPut.}WriteBuffer(dw,4);
      for idx:=0 to cls.MethodData.Count-1 do
        begin
          mth:=TMethodRec(cls.MethodData.Methods[idx]);
          dw:=Length(mth.sName);
          {OutPut.}WriteBuffer(dw,4);
          {OutPut.}WriteBuffer(mth.sName[1],dw);
          {OutPut.}WriteBuffer(mth.dwRVA,4);
          {OutPut.}WriteBuffer(mth.wFlag,4);
        end;
    end;

    size:=Length(localbuf);
    if Length(buff)=size then Move(localbuf,buff,size);
//    FreeMem(localbuf,size);

end;



procedure TDeDeMainForm.LoadDSFForDelphiTargetVersion;
var sf,s  : String;
    DeDeSym, Sym : TDeDeSymbol;
    i : Integer;
begin
  sf:='vcl'+(sDelphiVersion+'00')[2]+'.dsf';
  if sDelphiVersion='BCB3' then sf:='vcl3.dsf';
  if sDelphiVersion='BCB4' then sf:='vcl4.dsf';
  if sDelphiVersion='BCB5' then sf:='vcl5.dsf';
  if sDelphiVersion='D6 CLX' then sf:='vcl6.dsf';
  sf:=ExtractFileDir(Application.ExeName)+'\DSF\'+sf;


  If (FileExists(sf)) then
    begin
      For i:=0 To SymbolsList.Count-1 Do
        Begin
          Sym:=TDeDeSymbol(SymbolsList[i]);
          //Dont load loaded symbol files
          if LowerCase(Sym.FileName)=LowerCase(sf) then exit;
        End;

      DumpstatusLbl.Caption:=Format(msg_loaddoi,[ExtractFileName(AnsiLowerCase(sf))]);
      DumpstatusLbl.Update;
      Screen.Cursor:=crHourGlass;
      Try
        DeDeSym:=TDeDeSymbol.Create;
        If DeDeSym.LoadSymbol(sf)
           Then Begin
             If DeDeSym.PatternSize=_PatternSize
               Then begin
                  SymbolsList.Add(DeDeSym);
                  SymbolsPath.Add(sf);
               end
               Else DeDeSym.Free;
           End
      Finally
        Screen.Cursor:=crDefault;
      End;

    end;
end;

procedure TDeDeMainForm.FreePlugIns;
var i, cnt : Integer;
    lst : Array of Cardinal;
    hmod : Cardinal;

    function IndexOf(val : Cardinal): integer;
    var j : integer;
    begin
      Result:=-1;
      for j:=Low(lst) to High(lst) do
        if lst[j]=val then
          begin
            Result:=j;
            exit;
          end;
    end;

begin
  cnt:=0;
  SetLength(lst,DeDePlugins_Count);

  for i:=1 to DeDePlugins_Count Do
    begin
      hmod:=GetModuleHandle(PChar(DeDePlugins_PluginsArray[i].DLL_NAME));
      if (hmod=INVALID_HANDLE_VALUE) or (hmod=0) then continue;

      if IndexOf(hmod)=-1
        then begin
          Lst[cnt]:=hmod;
          Inc(cnt);
        end;
    end;

  for i:=0 to cnt-1 do
     FreeLibrary(Lst[i]);
end;

procedure TDeDeMainForm.FEKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then PreBtnClick(self);
end;


function Hash(s : String) : String;
var sha1 : TDCP_sha1;
    koza :array[0..19] of byte;
    i : Integer;
begin
  sha1:=TDCP_sha1.Create(nil);
  try
    sha1.Init;
    sha1.UpdateStr(s);
    for i:=0 to 19 do koza[i]:=0;
    sha1.Final(koza);
    Result:='';
    For i:=1 to 20 do
      Result:=Result+IntToHex(koza[i-1],2);
  finally
    sha1.free;
  end;
end;

Function GetVersionHash : String;
var reg : TRegistry;
    sWinVer : String;
begin
  reg:=TRegistry.Create;
  Try
    reg.RootKey:=HKEY_LOCAL_MACHINE;
    reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion',False);
    sWinVer:=reg.ReadString('ProductId');
  Finally
    reg.Free;
  End;

  Result:=Hash(sWinVer+GlobsCurrDeDeVersion+AnsiLowerCase(Application.ExeName));
end;

procedure DebugLog(sMessage: String);
begin
  DebugLogList.Add(DateTimeToStr(Now)+'  '+sMessage);
end;

initialization
  bDebug:=False;
  bUserProcs:=False;
  bBSS:=False;
  DebugLogList:=TStringList.Create;

finalization
  DebugLogList.Free;

end.
