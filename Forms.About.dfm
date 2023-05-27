object AboutForm: TAboutForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'AboutForm'
  ClientHeight = 199
  ClientWidth = 390
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  TextHeight = 15
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 374
    Height = 153
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 90
      Height = 15
      Caption = 'D86Box Manager'
    end
  end
  object Button1: TButton
    Left = 307
    Top = 166
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 1
    OnClick = Button1Click
  end
end
