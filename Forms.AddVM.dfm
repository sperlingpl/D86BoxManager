object AddVMForm: TAddVMForm
  Left = 0
  Top = 0
  Caption = 'AddVMForm'
  ClientHeight = 323
  ClientWidth = 506
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Label1: TLabel
    Left = 104
    Top = 32
    Width = 34
    Height = 15
    Caption = 'Label1'
  end
  object Button1: TButton
    Left = 423
    Top = 290
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 342
    Top = 290
    Width = 75
    Height = 25
    Caption = 'Add'
    TabOrder = 1
  end
  object LabeledEdit1: TLabeledEdit
    Left = 40
    Top = 112
    Width = 257
    Height = 23
    EditLabel.Width = 67
    EditLabel.Height = 15
    EditLabel.Caption = 'LabeledEdit1'
    TabOrder = 2
    Text = ''
  end
end
