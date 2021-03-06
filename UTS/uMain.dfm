object fMain: TfMain
  Left = 0
  Top = 0
  Caption = 'Daftar Alumni'
  ClientHeight = 487
  ClientWidth = 1006
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object PageControl1: TPageControl
    Left = -3
    Top = 0
    Width = 1010
    Height = 487
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Main Source'
      PopupMenu = PMenu1
      object GroupBox1: TGroupBox
        Left = 3
        Top = 0
        Width = 917
        Height = 81
        Caption = 'Document Title'
        TabOrder = 0
        object Label1: TLabel
          Left = 8
          Top = 20
          Width = 30
          Height = 15
          Caption = 'Path :'
        end
        object LabelPath: TLabel
          Left = 53
          Top = 20
          Width = 67
          Height = 15
          Caption = 'Location File'
        end
        object FileName: TLabeledEdit
          Left = 64
          Top = 41
          Width = 593
          Height = 23
          EditLabel.Width = 53
          EditLabel.Height = 15
          EditLabel.Caption = 'File Name'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = [fsItalic]
          LabelPosition = lpLeft
          ParentFont = False
          TabOrder = 0
          Text = ''
        end
      end
      object GroupBox2: TGroupBox
        Left = 3
        Top = 87
        Width = 206
        Height = 345
        Align = alCustom
        Caption = 'Options'
        TabOrder = 1
        object ButtonSimpan: TButton
          Left = 2
          Top = 17
          Width = 202
          Height = 25
          Action = ActSimpan
          Align = alTop
          Caption = 'Save File'
          TabOrder = 0
        end
        object ButtonHapus: TButton
          Left = 2
          Top = 42
          Width = 202
          Height = 25
          Action = ActHapusFile
          Align = alTop
          Caption = 'Delete File'
          TabOrder = 1
        end
        object ListBoxFile: TListBox
          Left = 2
          Top = 90
          Width = 202
          Height = 252
          Align = alTop
          ItemHeight = 15
          TabOrder = 2
          OnDblClick = ListBoxFileDblClick
        end
        object Edit1: TEdit
          Left = 2
          Top = 67
          Width = 202
          Height = 23
          Align = alTop
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = [fsItalic]
          ParentFont = False
          TabOrder = 3
          TextHint = 'Search File Name'
          OnKeyPress = Edit1KeyPress
        end
      end
      object ListViewData: TListView
        Left = 211
        Top = 97
        Width = 782
        Height = 335
        Align = alCustom
        Anchors = [akLeft, akTop, akRight, akBottom]
        Columns = <
          item
            Caption = 'No'
            Width = 30
          end
          item
            Caption = 'Nama'
            Width = 200
          end
          item
            Caption = 'Alamat'
            Width = 200
          end
          item
            Caption = 'Pekerjaan'
            Width = 150
          end
          item
            Caption = 'Keterangan'
            Width = 200
          end>
        PopupMenu = PMenu1
        TabOrder = 2
        ViewStyle = vsReport
        OnColumnClick = ListViewDataColumnClick
      end
      object StatusBar1: TStatusBar
        Left = 0
        Top = 438
        Width = 1002
        Height = 19
        Panels = <
          item
            Text = 'Jumlah File :'
            Width = 75
          end
          item
            Width = 100
          end
          item
            Text = 'Jumlah Data :'
            Width = 85
          end
          item
            Width = 100
          end>
        ExplicitWidth = 923
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 688
    Top = 48
  end
  object AL1: TActionList
    Left = 672
    Top = 200
    object ActSimpan: TAction
      Caption = 'Simpan'
      ShortCut = 16467
      OnExecute = ActSimpanExecute
    end
    object ActHapus: TAction
      Caption = 'Hapus'
      ShortCut = 46
      OnExecute = ActHapusExecute
    end
    object ActTambah: TAction
      Caption = 'Tambah'
      ShortCut = 16457
      OnExecute = ActTambahExecute
    end
    object ActUbah: TAction
      Caption = 'Ubah'
      ShortCut = 113
      OnExecute = ActUbahExecute
    end
    object ActBuka: TAction
      Caption = 'Buka'
      ShortCut = 16463
      OnExecute = ActBukaExecute
    end
    object ActListFile: TAction
      Caption = 'Daftar File'
      ShortCut = 16460
      OnExecute = ActListFileExecute
    end
    object ActHapusFile: TAction
      Caption = 'Hapus File'
      ShortCut = 8238
      OnExecute = ActHapusFileExecute
    end
    object ActUbahFile: TAction
      Caption = 'Ubah File'
      ShortCut = 16497
      OnExecute = ActUbahFileExecute
    end
  end
  object PMenu1: TPopupMenu
    Left = 672
    Top = 264
    object OpenFile1: TMenuItem
      Action = ActBuka
      Caption = 'Open'
    end
    object EditFile1: TMenuItem
      Action = ActUbahFile
      Caption = 'Edit File'
    end
    object DeleteFile1: TMenuItem
      Action = ActHapusFile
      Caption = 'Delete File'
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Save1: TMenuItem
      Action = ActSimpan
      Caption = 'Save'
    end
    object Delete1: TMenuItem
      Action = ActHapus
      Caption = 'Delete'
    end
    object Insert1: TMenuItem
      Action = ActTambah
      Caption = 'Insert'
    end
    object Edit2: TMenuItem
      Action = ActUbah
      Caption = 'Edit'
    end
  end
end
