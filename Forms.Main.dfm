object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'D86Box Manager'
  ClientHeight = 366
  ClientWidth = 561
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  DesignSize = (
    561
    366)
  TextHeight = 15
  object ListView1: TListView
    Left = 8
    Top = 40
    Width = 545
    Height = 318
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <>
    TabOrder = 0
  end
  object Button1: TButton
    Left = 478
    Top = 9
    Width = 75
    Height = 25
    Caption = 'About'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 8
    Top = 9
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 2
    OnClick = Button2Click
  end
end
