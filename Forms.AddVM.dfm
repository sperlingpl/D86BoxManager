object AddVMForm: TAddVMForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'AddVMForm'
  ClientHeight = 204
  ClientWidth = 426
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  DesignSize = (
    426
    204)
  TextHeight = 15
  object BtnCancel: TButton
    Left = 343
    Top = 171
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    TabOrder = 0
    OnClick = BtnCancelClick
    ExplicitTop = 196
  end
  object BtnAdd: TButton
    Left = 262
    Top = 171
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Add'
    TabOrder = 1
    OnClick = BtnAddClick
    ExplicitTop = 196
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 409
    Height = 89
    Caption = 'Virtual machine'
    TabOrder = 2
    object Label1: TLabel
      Left = 15
      Top = 27
      Width = 35
      Height = 15
      Caption = 'Name:'
    end
    object Label3: TLabel
      Left = 15
      Top = 56
      Width = 63
      Height = 15
      Caption = 'Description:'
    end
    object EdtName: TEdit
      Left = 112
      Top = 24
      Width = 281
      Height = 23
      TabOrder = 0
      OnChange = EdtNameChange
    end
    object EdtDescription: TEdit
      Left = 112
      Top = 53
      Width = 281
      Height = 23
      TabOrder = 1
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 103
    Width = 410
    Height = 58
    Caption = 'Choose emulator'
    TabOrder = 3
    object Label2: TLabel
      Left = 15
      Top = 28
      Width = 51
      Height = 15
      Caption = 'Emulator:'
    end
    object CbEmulator: TComboBox
      Left = 112
      Top = 24
      Width = 201
      Height = 23
      Style = csDropDownList
      TabOrder = 0
    end
    object BtnNewEmulator: TButton
      Left = 319
      Top = 23
      Width = 75
      Height = 25
      Caption = 'New'
      TabOrder = 1
    end
  end
end
