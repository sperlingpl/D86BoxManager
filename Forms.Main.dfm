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
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    561
    366)
  TextHeight = 15
  object LvMachines: TListView
    Left = 8
    Top = 40
    Width = 545
    Height = 318
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = 'Name'
        Width = 200
      end
      item
        Caption = 'Status'
        Width = 100
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    ExplicitWidth = 541
    ExplicitHeight = 317
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
