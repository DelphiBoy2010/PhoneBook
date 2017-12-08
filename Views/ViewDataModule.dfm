object ViewGlobalModule: TViewGlobalModule
  OldCreateOrder = False
  Height = 540
  Width = 856
  object ActionList1: TActionList
    Left = 416
    Top = 256
    object NextTabAction1: TNextTabAction
      Category = 'Tab'
    end
    object PreviousTabAction1: TPreviousTabAction
      Category = 'Tab'
    end
    object actCloseForm: TAction
      Text = 'actCloseForm'
    end
    object WindowClose1: TWindowClose
      Category = 'Window'
      Hint = 'Close Window|Close active form'
    end
  end
end
