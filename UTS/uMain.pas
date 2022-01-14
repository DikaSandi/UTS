unit uMain;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.StrUtils,
  System.Variants,
  System.Classes,
  System.Inifiles,
  System.Masks,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  Vcl.Menus,
  System.Actions,
  Vcl.ActnList,
  Vcl.ComCtrls,
  Vcl.Mask;

type
  TfMain = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    ListViewData: TListView;
    StatusBar1: TStatusBar;
    Label1: TLabel;
    OpenDialog1: TOpenDialog;
    FileName: TLabeledEdit;
    LabelPath: TLabel;
    ButtonSimpan: TButton;
    ButtonHapus: TButton;
    ListBoxFile: TListBox;
    Edit1: TEdit;
    AL1: TActionList;
    ActSimpan: TAction;
    ActHapus: TAction;
    ActTambah: TAction;
    ActUbah: TAction;
    ActBuka: TAction;
    ActListFile: TAction;
    ActHapusFile: TAction;
    ActUbahFile: TAction;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    OpenFile1: TMenuItem;
    EditFile1: TMenuItem;
    DeleteFile1: TMenuItem;
    Save1: TMenuItem;
    Delete1: TMenuItem;
    Insert1: TMenuItem;
    Edit2: TMenuItem;
    procedure ActSimpanExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ActListFileExecute(Sender: TObject);
    procedure ActHapusExecute(Sender: TObject);
    procedure ListBoxFileDblClick(Sender: TObject);
    procedure ListViewDataColumnClick(Sender: TObject; Column: TListColumn);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure ActTambahExecute(Sender: TObject);
    procedure ActUbahExecute(Sender: TObject);
    procedure ActBukaExecute(Sender: TObject);
    procedure ActHapusFileExecute(Sender: TObject);
    procedure ActUbahFileExecute(Sender: TObject);

  private
    { Private declarations }
    function PathDirectory: string;
    procedure FindFilePattern(root: String; pattern: String);
    procedure RefreshCount;
  public
    { Public declarations }
  end;

  TCustomSortStyle = (cssAlphaNum, cssNumeric, cssDateTime);

var
  fMain: TfMain;

  { variable to hold the sort style }
  LvSortStyle: TCustomSortStyle;
  { array to hold the sort order }
  LvSortOrder: array [0 .. 4] of Boolean;
  // High[LvSortOrder] = Number of Lv Columns

implementation

{$R *.dfm}

function CustomSortProc(Item1, Item2: TListItem; SortColumn: Integer): Integer; stdcall;
var
  s1, s2: string;
  i1, i2: Integer;
  r1, r2: Boolean;
  d1, d2: TDateTime;
  { Helper functions }
  function IsValidNumber(AString: string; var AInteger: Integer): Boolean;
  var
    Code: Integer;
  begin
    Val(AString, AInteger, Code);
    Result := (Code = 0);
  end;
  function IsValidDate(AString: string; var ADateTime: TDateTime): Boolean;
  begin
    Result := True;
    try
      ADateTime := StrToDateTime(AString);
    except
      ADateTime := 0;
      Result    := False;
    end;
  end;
  function CompareDates(dt1, dt2: TDateTime): Integer;
  begin
    if (dt1 > dt2) then
      Result := 1
    else if (dt1 = dt2) then
      Result := 0
    else
      Result := -1;
  end;
  function CompareNumeric(AInt1, AInt2: Integer): Integer;
  begin
    if AInt1 > AInt2 then
      Result := 1
    else if AInt1 = AInt2 then
      Result := 0
    else
      Result := -1;
  end;
begin
  Result := 0;
  if (Item1 = nil) or (Item2 = nil) then
    Exit;
  case SortColumn of
    - 1:
      { Compare Captions }
      begin
        s1 := Item1.Caption;
        s2 := Item2.Caption;
      end;
  else
    { Compare Subitems }
    begin
      s1 := '';
      s2 := '';
      { Check Range }
      if (SortColumn < Item1.SubItems.Count) then
        s1 := Item1.SubItems[SortColumn];
      if (SortColumn < Item2.SubItems.Count) then
        s2 := Item2.SubItems[SortColumn]
    end;
  end;
  { Sort styles }
  case LvSortStyle of
    cssAlphaNum:
      Result := lstrcmp(PChar(s1), PChar(s2));
    cssNumeric:
      begin
        r1     := IsValidNumber(s1, i1);
        r2     := IsValidNumber(s2, i2);
        Result := ord(r1 or r2);
        if Result <> 0 then
          Result := CompareNumeric(i2, i1);
      end;
    cssDateTime:
      begin
        r1     := IsValidDate(s1, d1);
        r2     := IsValidDate(s2, d2);
        Result := ord(r1 or r2);
        if Result <> 0 then
          Result := CompareDates(d1, d2);
      end;
  end;
  { Sort direction }
  if LvSortOrder[SortColumn + 1] then
    Result := -Result;
end;

procedure TfMain.ActBukaExecute(Sender: TObject);
var
  LIniFile   : TIniFile;
  LStringList: TStringList;
  I          : Integer;
  LI         : TListItem;
  fFileName  : String;
begin
  /// Pilih File
  with OpenDialog1 do
  begin
    Execute;
    /// baca File
    try
      LIniFile    := TIniFile.Create(FileName);
      LStringList := TStringList.Create;
      LIniFile.ReadSections(LStringList);
      with LIniFile, ListViewData do
      begin
        if LStringList.Count > 0 then
        begin
          /// Clear
          Items.Clear;
          /// Loop Data From IniFile
          for I := 0 to LStringList.Count - 1 do
          begin
            LI         := Items.Add;
            LI.Caption := IntToStr(I);
            LI.SubItems.Add(ReadString(IntToStr(I), 'Nama', ''));
            LI.SubItems.Add(ReadString(IntToStr(I), 'Alamat', ''));
            LI.SubItems.Add(ReadString(IntToStr(I), 'Pekerjaan', ''));
            LI.SubItems.Add(ReadString(IntToStr(I), 'Keterangan', ''));
          end;
        end;
      end;
    finally
      LStringList.Free;
      LIniFile.Free;
    end;
  end;
  fFileName := OpenDialog1.Files[0];
  Delete(fFileName, 1, Length(PathDirectory) + 1);
  FileName.Text := fFileName;
  // Hitung Jumlah
  RefreshCount;
end;

procedure TfMain.ActHapusExecute(Sender: TObject);
begin
  /// Delete ListView
  with ListViewData do
  begin
    case MessageDlg('Apakah Anda Ingin Menghapus?', mtConfirmation, [mbYes, mbNo], 0) of
      mrYes:
        begin
          Items[ItemIndex].Delete;
          // Hitung Jumlah
          RefreshCount;
        end;
      mrNo:
        ;
    end;
  end;
end;

procedure TfMain.ActHapusFileExecute(Sender: TObject);
begin
  /// Delete File
  case MessageDlg('Apakah anda Yakin ingin menghapus file?', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) of
    mrYes:
      begin
        if FileExists(LabelPath.Caption + '\' + ListBoxFile.Items[ListBoxFile.ItemIndex]) then
        begin
          DeleteFile(LabelPath.Caption + '\' + ListBoxFile.Items[ListBoxFile.ItemIndex]);
          ActListFileExecute(Sender);
          // Hitung Jumlah
          RefreshCount;
        end;
      end;
    mrNo:
      ;
  end;
end;

procedure TfMain.ActListFileExecute(Sender: TObject);
begin
ListBoxFile.Items.Clear;
  FindFilePattern(LabelPath.Caption + '\', '*.*');
  // Hitung Jumlah
  RefreshCount;
end;

procedure TfMain.ActSimpanExecute(Sender: TObject);
var
  LIniFile: TIniFile;
  I       : Integer;
begin
    /// Save Data IniFile Format
  try
    /// Delete File
    if FileExists(PathDirectory + '\' + FileName.Text) then
      DeleteFile(PathDirectory + '\' + FileName.Text);
    LIniFile := TIniFile.Create(PathDirectory + '\' + FileName.Text + '.ini');
    /// Save Record TO File
    with LIniFile, ListViewData do
    begin
      for I := 0 to Items.Count - 1 do
      begin
        WriteString(IntToStr(I), 'Nama', Items[I].SubItems[0]);
        WriteString(IntToStr(I), 'Alamat', Items[I].SubItems[1]);
        WriteString(IntToStr(I), 'Pekerjaan', Items[I].SubItems[2]);
        WriteString(IntToStr(I), 'Keterangan', Items[I].SubItems[3]);
      end;
    end;
    MessageDlg('Data Berhasil diSimpan', mtInformation, [mbOK], 0);
    ActListFileExecute(Sender);
    // Hitung Jumlah
    RefreshCount;
  finally
    LIniFile.Free;
  end;
end;

procedure TfMain.ActTambahExecute(Sender: TObject);
var
  LAValue  : array [0 .. 4] of string;
  LocalItem: TListItem;
  fNumber  : Integer;
begin
  /// Isi data
  LAValue[0] := '';
  LAValue[1] := '';
  LAValue[2] := '';
  LAValue[3] := '';
  LAValue[4] := '';
  InputQuery('Input Data', ['Nama', 'Alamat', 'Pekerjaan', 'Keterangan'], LAValue);
  // Masukkan Ke ListView
  fNumber   := ListViewData.Items.Count + 1;
  LocalItem := ListViewData.Items.Add;
  with LocalItem do
  begin
    Caption := IntToStr(fNumber);
    SubItems.Add(LAValue[0]);
    SubItems.Add(LAValue[1]);
    SubItems.Add(LAValue[2]);
    SubItems.Add(LAValue[3]);
  end;
  // Hitung Jumlah
  RefreshCount;
end;

procedure TfMain.ActUbahExecute(Sender: TObject);
var
  LAValue: array [0 .. 4] of string;
begin
  /// Ubah Data
  with ListViewData do
  begin
    Items.BeginUpdate;
    /// Identification Value
    LAValue[0] := Items[Selected.Index].SubItems[0];
    LAValue[1] := Items[Selected.Index].SubItems[1];
    LAValue[2] := Items[Selected.Index].SubItems[2];
    LAValue[3] := Items[Selected.Index].SubItems[3];
    LAValue[4] := Items[Selected.Index].SubItems[4];
    InputQuery('Input Data', ['Nama', 'Alamat', 'Pekerjaan', 'Keterangan'], LAValue);
    /// Chande Value
    Items[Selected.Index].SubItems[0] := LAValue[0];
    Items[Selected.Index].SubItems[1] := LAValue[1];
    Items[Selected.Index].SubItems[2] := LAValue[2];
    Items[Selected.Index].SubItems[3] := LAValue[3];
    Items[Selected.Index].SubItems[4] := LAValue[4];
    Items.EndUpdate;
  end;
end;

procedure TfMain.ActUbahFileExecute(Sender: TObject);
var
  NewFile: String;
begin
  /// Rename File
  NewFile := ReplaceStr(ListBoxFile.Items[ListBoxFile.ItemIndex], '.ini', '');
  InputQuery('Rename File', 'Masukkan Nama File Baru', NewFile);
  RenameFile(PathDirectory + '\' + ListBoxFile.Items[ListBoxFile.ItemIndex], PathDirectory + '\' + NewFile + '.ini');
  { Refresh ListFile }
  ActListFileExecute(Sender);
end;

procedure TfMain.Edit1KeyPress(Sender: TObject; var Key: Char);
var
  I: Integer;
begin
  if Key = #13 then
  begin
    ListBoxFile.Items.BeginUpdate;
    try
      for I                  := 0 to ListBoxFile.Items.Count - 1 do
        ListBoxFile.Selected[I] := ContainsText(ListBoxFile.Items[I], Edit1.Text);
    finally
      ListBoxFile.Items.EndUpdate;
    end;
  end;
end;

procedure TfMain.FindFilePattern(root, pattern: String);
var
  SR: TSearchRec;
begin
  root := IncludeTrailingPathDelimiter(root);
  if FindFirst(root + '*.*', faAnyFile, SR) = 0 then
    try
      repeat
        Application.ProcessMessages;
        if (SR.Attr and faDirectory) <> 0 then
        begin
          if (SR.Name <> '.') and (SR.Name <> '..') then
            FindFilePattern(root + SR.Name, pattern);
        end
        else
        begin
          if MatchesMask(SR.Name, pattern) then
            fMain.ListBoxFile.Items.Add(SR.Name);
        end;
      until FindNext(SR) <> 0;
    finally
      FindClose(SR);
    end;
end;

function TfMain.PathDirectory: string;
begin
  Result := ExtractFileDir(Application.ExeName) + '\Notes';
end;

procedure TfMain.RefreshCount;
begin
  /// Hitung Jumlah File
  StatusBar1.Panels[1].Text := IntToStr(ListBoxFile.Items.Count);
  /// Jumlah data Inifile
  StatusBar1.Panels[3].Text := IntToStr(ListViewData.Items.Count);
end;

procedure TfMain.FormShow(Sender: TObject);
begin
var
  I: Integer;
  begin
    /// Path Directory to Save File.
    LabelPath.Caption := PathDirectory;
    if not DirectoryExists(PathDirectory) then
      ForceDirectories(PathDirectory);
    /// List File To ListBox
    ActListFileExecute(Sender);

  end;
end;

procedure TfMain.ListBoxFileDblClick(Sender: TObject);
var
  LIniFile   : TIniFile;
  LStringList: TStringList;
  LI         : TListItem;
  I          : Integer;
begin
  /// Read Record From File
  /// baca File
  try
    LIniFile    := TIniFile.Create(LabelPath.Caption + '\' + ListBoxFile.Items[ListBoxFile.ItemIndex]);
    LStringList := TStringList.Create;
    LIniFile.ReadSections(LStringList);
    FileName.Text := ReplaceStr(ListBoxFile.Items[ListBoxFile.ItemIndex], '.ini', '');
    with LIniFile, ListViewData do
    begin
      if LStringList.Count > 0 then
      begin
        /// Clear
        Items.Clear;
        /// Loop Data From IniFile
        for I := 0 to LStringList.Count - 1 do
        begin
          LI         := Items.Add;
          LI.Caption := IntToStr(I);
          LI.SubItems.Add(ReadString(IntToStr(I), 'Nama', ''));
          LI.SubItems.Add(ReadString(IntToStr(I), 'Status', ''));
          LI.SubItems.Add(ReadString(IntToStr(I), 'Keterangan', ''));
          LI.SubItems.Add(ReadString(IntToStr(I), 'Tanggal', ''));
        end;
      end;
    end;
    // Hitung Jumlah
    RefreshCount;
  finally
    LStringList.Free;
    LIniFile.Free;
  end;
end;

procedure TfMain.ListViewDataColumnClick(Sender: TObject; Column: TListColumn);
begin
  { determine the sort style }
  if Column.Index = Column.Index then
    LvSortStyle := cssAlphaNum
  else
    LvSortStyle := cssNumeric;
  { Call the CustomSort method }
  ListViewData.CustomSort(@CustomSortProc, Column.Index - 1);
  { Set the sort order for the column }
  LvSortOrder[Column.Index] := not LvSortOrder[Column.Index];
end;

end.
