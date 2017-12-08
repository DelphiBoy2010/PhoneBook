object frmLogLevel: TfrmLogLevel
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Log Level'
  ClientHeight = 211
  ClientWidth = 319
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object rgLevel: TRadioGroup
    Left = 0
    Top = 0
    Width = 319
    Height = 170
    Align = alClient
    Caption = 'rgLevel'
    TabOrder = 0
    ExplicitLeft = 32
    ExplicitTop = 8
    ExplicitWidth = 185
    ExplicitHeight = 105
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 170
    Width = 319
    Height = 41
    Align = alBottom
    Caption = 'pnlButtons'
    TabOrder = 1
    ExplicitLeft = 136
    ExplicitTop = 104
    ExplicitWidth = 185
    object btnOk: TButton
      Left = 56
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Ok'
      TabOrder = 0
      OnClick = btnOkClick
    end
    object btnCancel: TButton
      Left = 192
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
end
