Class Array extends Lib.obj.meta.Call{
	Call(function,byref Parameters*)	{	;Needs rewritten so it takes advantage of Variatic
		if(Parameters.length() == 0)	;Checks if no parameters were entered
			return this["Generic"][function]()
		LastParam:=0
		Loop % Parameters.Length()	;Determines the start of arr*
			if(!isobject(Parameters[A_Index]) or isfunc(Parameters[A_Index]))
				LastParam:=A_Index
		if(LastParam == 0)
			Arr:=Parameters,Params:=Array()
		else if(LastParam == Parameters.length())
			Params:=Parameters,Arr:=Array()
		else		{
			Params:=Parameters.clone()
			Params.removeAt(LastParam + 1,Parameters.Length())
			Arr:=Parameters.clone()
			Arr.removeAt(1,LastParam)
		}
		if(Arr.Length() == 0)
			return this["Generic"][function](Params*)
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
	Class Generic {
		isLinear(Arr*)	{
			for i, sArr in Arr {
				index:=1
				For key, value in sArr	{
					if(key != index)
						index:=-1,break
					index++
				}
				Arr[i]:=index is digit
			}
			return arr.length() == 1?arr[1]:arr
		}
		Keys(Arr*)	{
			for i, sArr in Arr		{
				tout:=Array()
				For key,value in sArr
					if(!Lib.obj.isMetaInfo(key,value))
						tout.push(Key)
				Arr[i]:=tout
			}
			return arr.length() == 1?arr[1]:arr
		}
		Values(Arr*)	{
			for i, sArr in Arr		{
				tout:=Array()
				For key,value in sArr
					if(!Lib.obj.isMetaInfo(key,value))
						tout.push(Value)
				Arr[i]:=tout
			}
			return arr.length() == 1?arr[1]:arr
		}
		isEmpty(Arr*)	{
			For i,sArr in Arr {
				For key,value in sArr
					if(!Lib.obj.isMetaInfo(key,value))
						Arr[i]:="",break
				Arr[i]:=isobject(Arr[i])
			}
			return arr.length() == 1?arr[1]:arr
		}
		Swap(Index_Key,Swap_Value,byref Arr*)	{
			Output:=Array()
			For i, sArr in Arr
				Output.push(sArr[Index_Key]), Arr[i][Index_Key]:=Swap_Value
			return Output.length() == 1?Output[1]:Output
		}
		purge(byref Arr*)	{
			Arr.push(Array())
			Arr:=Lib.Obj.Array.RemoveAll("",Arr*)
		}
		toString(value*)	{
			For i,val in value
				if val is not number
					value[i]:="""" val """"
			return Value.length() == 1? value[1]:value
		}
	}
	Class Linear extends Lib.obj.Array.Generic{
		Clone(Arr*)	{
				For i, sArr in Arr {
					tOut:=Array()
					For index,value in sArr
						if(!Lib.obj.isMetaInfo(index,value))
							tOut.push(value)
					Arr[i]:=tOut
				}
				return arr.length() == 1?arr[1]:arr
		}
		/*
			trim_instruction:
				1 - Remove at beginning of array
				0 - remove value at end of array
				an array of instructions can be input and they will be cycled through
		*/
		
		Trim(trim_instruction,size,Arr*)	{
			if(!isobject(trim_instruction))
				trim_instruction:=[trim_instruction,trim_instruction]
			For i,sArr in Arr {
				increment:=1
				if(this.Length(sArr) > size)
					While(this.Length(sArr) > size)		{
						inst_num:=Mod(increment,trim_instruction.length()) + 1
						increment++
						if(trim_instruction[inst_num] == 1)
							remval:=sArr.RemoveAt(1)
						else
							remval:=sArr.pop()
						if(Lib.obj.isMetaInfo(remval))		{
							Random rando, 1, % sArr.Length()
							sArr.InsertAt(rando,remval)
						}
					}
				Arr[i]:=sArr
			}
			return Arr.length() == 1 ? arr[1]:arr
		}
		Split(Split_Index, Arr*) {
			Arr.push("")
			Arr:=this.Clone(Arr*)
			Arr.pop()
			For i,sArr in Arr	{
				Arr[i]:=[sArr.clone(),sArr.Clone()]
				Arr[i][1].removeAt(Split_Index,sArr.Length())
				Arr[i][2].removeAt(1,Split_Index - 1)
			}
			return arr.length() == 1?arr[1]:arr
		}
		Length(Arr*)		{
			For i,sArr in Arr {
				length:=0
				For index,value in sArr
					if(!Lib.obj.isMetaInfo(index,value))
						length++
				Arr[i]:=Length
			}
			return arr.length() == 1?arr[1]:arr
		}
		removeAll(value, Arr*)		{
			For i,sArr in Arr		{
				rval_index:=""
				Loop % sArr.length()
					if(sArr[A_Index] == value)
						rval_index.="|" A_Index
				StringTrimLeft, Purge,Purge,1
				Sort rval_index, N R D|
				Loop, Parse, rval_index ,|
					Arr[i].removeAt(A_LoopField)
			}
			return Arr.length() == 1?Arr[1]:Arr
		}
		toString(Arr*){
			for i,sArr in Arr
			{
				Loop % sArr.length()
					if(!Lib.obj.isMetaInfo(A_Index,sArr[A_Index]))
						sOut.= ", " Lib.Obj.Array.toString(sArr[A_Index])
				StringTrimLeft,sOut,sOut,1
				Arr[i]:="[" sOut "]"
			}
			return Arr.length() == 1?Arr[1]:Arr
		}
	}
	Class Associative extends Lib.obj.Array.Generic {
		Clone(Arr*)	{
			For i,sArr in Arr {
				tOut:=Array()
				For key,value in sArr
					if(!Lib.obj.isMetaInfo(Key,value))
						tOut[key]:=value
				Arr[i]:=tOut
			}
			return arr.length() == 1?arr[1]:arr
		}
		removeAll(value,Arr*)	{
			For i,sArr in Arr	{
				For key,value in sArr
					if(value == value)
						Arr[i].remove(key)
			}
			return Arr.length() == 1?Arr[1]:Arr
		}
		toString(Arr*){
			For i,sArr in Arr	{
				sOut:=""
				For Key,Value in sArr
					if(!Lib.obj.isMetaInfo(Key,value))
						sOut.=", " key ":" Lib.obj.Array.toString(Value)
				StringTrimLeft sOut,sOut,1
				Arr[i]:="{" sOut "}"
			}
			return Arr.length() == 1?Arr[1]:Arr
		}
	}
	Class Recursive extends Lib.obj.Array { ;Needs work - Recursively performs functions on arrays
		Call(function,byref parameters*)	{
			parameters.push(Array())
			output:=base.Call(function,parameters*)
			parameters.pop(),output.pop()
			if(output.length() != parameters.length())
			{
				parameters.length() - output.length()
			}
		
		}
	}

}
Class old_Array extends Lib.obj.meta.Call{
	Call(value*)
	{
		lib.tshoot(this.__Class, value*)
	
	}
	toString(arr*)	{
		Loop % Arr.Length()
			arr[A_Index]:=!isobject(arr[A_Index])?(arr[A_Index] is number?arr[A_Index]:"""" arr[A_Index] """"):this.linear.isLinear(Arr)?this.linear.toString(Arr):this.associative.toString(Arr)
		return arr.length() == 1?arr[1]:arr
	}
	Class Linear extends Lib.obj.Array.Generic{
		isLinear(Arr*)	{
				Loop % Arr.Length()
				{
					index:=1
					For key, value in Arr[A_Index]
					{
						if(key != index)
							return 0
						index++
					}
				}
				return 1
		}
		toString(Arr*){
			Output:=array()
			Loop % Arr.length()
			{
				sArr:=Arr[A_Index]
				Loop % sArr.length()
					sOut.= ", " base.toString(sArr[A_Index])
				StringTrimLeft,sOut,sOut,1
				Output.push("[" sOut "]")
			}
			return Output.length() == 1?Output[1]:Output
		}
		purge(byref Arr*)		{
			Loop % Arr.Length()
			{
				sArr:=Arr[A_Index]
				Purge:=""
				Loop % sArr.length()
					if(sArr[A_Index] == "")
						Purge.="|" A_Index
				StringTrimLeft, Purge,Purge,1
				Sort Purge, N R D|
				Loop, Parse, Purge ,|
					sArr.removeAt(A_LoopField)
				Arr[A_Index]:=sArr
			}
			return Arr.length() == 1?Arr[1]:Arr
		}
	}
	Class Associative extends Lib.obj.Array{
		isAssociative(Arr*)	{
			return !this.linear.isLinear(Arr*)
		}
		toString(Arr*){
			Output:=array()
			Loop % Arr.length()
			{
				sOut:=""
				For Key,Value in arr[A_Index]
					sOut.=", " key ":" base.toString(Value)
				StringTrimLeft sOut,sOut,1
				Output.push("{" sOut "}")
			}
			return Output.length() == 1?Output[1]:Output
		}
		Purge(byref Arr*)	{
			Loop % Arr.Length()
			{
				sArr:=Arr[A_Index]
				For key,value in sArr
					if(value == "")
						sArr.remove(key)
				Arr[A_Index]:=sArr
			}
			return Arr.length() == 1?Arr[1]:Arr
		}

	}




}