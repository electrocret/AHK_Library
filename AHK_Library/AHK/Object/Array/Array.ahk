Class Array extends Ahk.Lang.Class.Meta.Call{
	#Include %A_ScriptDir%\AHK_Library\AHK\Object\Array\Linear.ahk
	#Include %A_ScriptDir%\AHK_Library\AHK\Object\Array\Associative.ahk
	#Include %A_ScriptDir%\AHK_Library\AHK\Object\Array\Generic.ahk
	Call(function,byref Parameters*)	{	;Needs rewritten
		if(Parameters.length() == 0)	;Checks if no parameters were entered - Calls Generic Array
			return this["Generic"][function]()
		LastParam:=0
		Loop % Parameters.Length()	;Determines the start of arr*
			if(!isobject(Parameters[A_Index]) or isfunc(Parameters[A_Index]))
				LastParam:=A_Index
		if(LastParam == Parameters.length()) ;No Parameters are arr*
			return this["Generic"][function](Parameters*)
		if(LastParam == 0)  ;If All Parameter are Arr*
			Arr:=Parameters,Params:=Array()
		else		{ ;Splits At Arr* start Location
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
			Loop % Arr.Length()
				Output.push(this[this.generic.isLinear(Arr[A_Index])?"linear":"associative"][function](Params*,Arr[A_Index]))
		}
		return AHK.Helpers.Variadic_RTN_FMT_Optional(Arr)
	}


	

}