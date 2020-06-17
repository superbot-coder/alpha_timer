unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, sSkinManager, sLabel,
  Vcl.StdCtrls, Vcl.ComCtrls, sComboBoxes, sButton, TimeFormat, sRadioButton,
  System.ImageList, Vcl.ImgList, System.IniFiles;

type
  TFrmMain = class(TForm)
    LblFXTime: TsLabelFX;
    sSkinManager: TsSkinManager;
    BtnStart: TsButton;
    BtnStop: TsButton;
    BtnClear: TsButton;
    sSkinSelector1: TsSkinSelector;
    sRadioBtnAlfa: TsRadioButton;
    sRadioBtnColon: TsRadioButton;
    ImageList: TImageList;
    procedure TimerEngine;
    procedure BtnStartClick(Sender: TObject);
    procedure BtnStopClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sRadioBtnClick(Sender: TObject);
    procedure SaveConfig;
    procedure LoadConfig;
    procedure sSkinManagerAfterChange(Sender: TObject);
    procedure BtnClearClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;



var
  FrmMain: TFrmMain;
  TMR_START: Boolean;
  BgnTime : Cardinal;
  TmSpliter: TimeSpliter;
  TmFormat : TimeShow;
  CurDir  : String;
  CurPath : String;
  INI: TIniFile;
  SkinName : String;

const
  FileConfig = 'Config.ini';


implementation

{$R *.dfm}

{ TForm1 }

procedure TFrmMain.BtnClearClick(Sender: TObject);
begin
  BgnTime := GetTickCount;
  LblFXTime.Caption := GetMilisecondsFormat(0, TmFormat, TmSpliter);
end;

procedure TFrmMain.BtnStartClick(Sender: TObject);
begin
  TimerEngine;
end;

procedure TFrmMain.BtnStopClick(Sender: TObject);
begin
  TMR_START := false;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  CurDir    := ExtractFileDir(Application.ExeName);
  CurPath   := ExtractFilePath(Application.ExeName);
  TmFormat  := TS_HOUR;
  TmSpliter := TS_Colon;

  LoadConfig;
  sSkinManager.SkinDirectory := CurPath + 'Skins';
  if DirectoryExists(CurPath + 'Skins') then
  begin
    sSkinManager.SkinName := SkinName;
  end
  else
  begin
    sSkinManager.SkinName := 'Black Box (internal)';
  end;
  sSkinManager.Active := true;
end;

procedure TFrmMain.LoadConfig;
var i: ShortInt;
    s: String;
begin
  INI := TIniFile.Create(CurPath + FileConfig);
  try
    i := INI.ReadInteger('SETTINGS', 'TimeFormat', 1);
    TmSpliter := TimeSpliter(i);
    case i of
      0: sRadioBtnAlfa.Checked  := true;
      1: sRadioBtnColon.Checked := true;
    end;
    SkinName := INI.ReadString('SETTINGS', 'SkinName', 'Black Box');
  finally
    INI.Free;
  end;
end;

procedure TFrmMain.SaveConfig;
begin
  //
end;

procedure TFrmMain.sRadioBtnClick(Sender: TObject);
begin
  if sRadioBtnColon.Checked then TmSpliter := TS_Colon;
  if sRadioBtnAlfa.Checked then TmSpliter  := TS_Alfa;
  INI := TIniFile.Create(CurPath + FileConfig);
  try
    INI.WriteInteger('SETTINGS', 'TimeFormat', Integer(TimeSpliter(TmSpliter)));
  finally
    INI.Free;
  end;
end;

procedure TFrmMain.sSkinManagerAfterChange(Sender: TObject);
begin
  INI := TIniFile.Create(CurPath + FileConfig);
  try
    INI.WriteString('SETTINGS', 'SkinName', sSkinManager.SkinName);
  finally
    INI.Free;
  end;
end;

procedure TFrmMain.TimerEngine;
begin
  TMR_START := true;
  BgnTime := GetTickCount;
  While TMR_START do
  begin
    Application.ProcessMessages;
    LblFXTime.Caption := GetMilisecondsFormat(GetTickCount - BgnTime, TmFormat, TmSpliter);
    Sleep(100);
  end;
end;

end.
