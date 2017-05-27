Class Array extends Lib.obj.meta.Call{
	#Include %A_ScriptDir%\Library\Object\Array\Linear.ahk
	#Include %A_ScriptDir%\Library\Object\Array\Associative.ahk
	#Include %A_ScriptDir%\Library\Object\Array\Generic.ahk
	#Include %A_ScriptDir%\Library\Object\Array\Filter.ahk
	Call(function,byref Parameters*)	{	;Needs rewritten
		if(Parameters.length() == 0)	;Checks if no parameters were entered
			return this["Generic"][function]()
		LastParam:=0
		Loop % Parameters.Length()	;Determines the start of arr*
			if(!isobject(Parameters[A_Index]) or isfunc(Parameters[A_Index]))
				LastParam:=A_Index
		if(LastParam == Parameters.length())
			return this["Generic"][function](Parameters*)
		if(LastParam == 0)
			Arr:=Parameters,Params:=Array()
		else		{
			Params:=Parameters.clone()
			Params.removeAt(LastParam + 1,Parameters.Length())
			Arr:=Parameters.clone()
			Arr.removeAt(1,LastParam)
		}
		Output:=Array()
		if(Params.length() == 0)	{
			Loop % Arr.Length()
				Output.push(this[this.generic.isLinear(Arr[A_Index])?"linear":"associative"][function](Arr[A_Index]))
		}
		else		{
			paramcache:=Array()
			Loop % Arr.Length()
			{
				arrtype:=this.generic.isLinear(Arr[A_Index])?"linear":"associative"
				paramcache[arrtype]:=isobject(paramcache[Arrtype])?paramcache[Arrtype]:this.linear.trim(0,isfunc(this[arrtype][function]) - 2,Params)
				paramcache[arrtype].push(Arr[A_Index])
				Output.push(this[arrtype][function](paramcache[arrtype]*))
				paramcache[arrtype].pop()
			}
		}
		return Output.length() == 1? Output[1]:Output
	}
	__Parse_Parameters(Parameters)	{
		LastParam:=Parameters.length()
		if(isobject(Parameters[LastParam]) and !isfunc(Parameters[LastParam]))		{
			while(isobject(Parameters[LastParam]) and !isfunc(Parameters[LastParam]) and LastParam > 1) 
				LastParam--
		}
		else
			return {params:Parameters,Arr:Array()}
		if(LastParam == 1)
			return {params:Array(),Arr:Parameters}
		Output:={params:Parameters.clone(),Arr:Parameters.clone()}
		Output.Params.removeAt(LastParam + 1,Parameters.Length())
		Output.Arr.removeAt(1,LastParam)
		return Output
	}
	__fCall(function,Parse_Obj:="")	{
		if(!isobject(Parse_Obj))
			return this["Generic"][function]()
	
	}


	

}