Class Asynchronous extends AHK.Lang.Class.Meta.Call_Functor{
	Call(self:="",Task:="",Cancel:=0)
	{
		Static Scheduler_Init:=0,TaskList_Running:=0,Schedule:=Array(),Scheduled:=Array(),TaskList:=Array()
		if(!Scheduler_Init)		{
			Scheduler_Init:=1
			schedule_func:=Func(A_thisfunc)
			SetTimer, %schedule_func% , 500,-2147483640
		}
		if(isobject(Task))
		{
			
		
		
		}
		else
		{
		
		
		}
		
		
	}
	Class Task extends AHK.Lang.Class.Meta.Call_Construct{
		__New(byref Obj,Funct,Delay:=1,Repeat:=0)	{
			if(isfunc(Obj[funct]))
			{
				this.ID:=Ahk.obj.ID(Obj) "_" Funct
				this.Obj:=Obj
				this.Funct:=Funct
				this.Repeat:=Repeat is digit?Repeat:0
				this.Exec_List:=0
				this.Delay(delay)
			}
			else
				this.invalid:=1
		}
		Delay(delay:=1)	{
			if delay is not digit
				delay:=1
			if(!isobject(this.Exec_Time))
				this.Exec_Time:=Array()
			this.Exec_Time.Sec:=A_Sec + Delay
			this.Exec_Time.Min:=A_Min + this.Exec_Time.Sec >= 60
			this.Exec_Time.Sec:=this.this.Exec_Time.Sec < 60?this.Exec_Time.Sec:this.Exec_Time.Sec-60
		}
		Execute()	{
			this["obj"][this.funct]()
			this.Delay(this.Repeat)
		}
		Execute_Time()	{
			return this.Exec_Time
		}
	}

}