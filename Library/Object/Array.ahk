Class Array extends Lib.obj.meta.Call{
	Call(function,byref Parameters*)	{
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
			Params.removeAt(LastParam,LastParam + Parameters.Length() - 1)
			Arr:=Arr.clone()
			Arr.removeAt(1,LastParam - 1)
		}
		if(Arr.Length() == 0)
			return this["Generic"][function](this.linear.trim(isfunc(this["Generic"][function]) - 1,,Params)*)
		Output:=Array()
		if(Params.length() == 0)	{
			Loop % Arr.Length()
				Output.push(this[this.generic.isLinear(Arr[A_Index])?"linear":"associative"][function](Arr[A_Index]))
		}
		else		{
			Loop % Arr.Length()
				arrtype:=this.generic.isLinear(Arr[A_Index])?"linear":"associative",Output.push(this[arrtype][function](this.linear.trim(isfunc(this[arrtype][function]) - 2,,Params)*,Arr[A_Index]))
		}
		return Output.length() == 1? Output[1]:Output
	}
	Class Generic {
		isLinear(Arr*)	{
			Loop % Arr.Length()
			{
				index:=1
				For key, value in Arr[A_Index]
				{
					if(key != index)
						index:=-1,break
					index++
				}
				Arr[A_Index]:=index is digit
			}
			return arr.length() == 1?arr[1]:arr
		}
		Values(Arr*)	{
			Loop % Arr.Length()
			{
				tout:=Array()
				For key,value in Arr[A_Index]
					if(!Lib.obj.isMetaInfo(key,value))
						tout.push(Value)
				Arr[A_Index]:=tout
			}
			return arr.length() == 1?arr[1]:arr
		}
		isEmpty(Arr*)	{
			Loop % Arr.Length()
			{
				For key,value in Arr[A_Index]
					if(!Lib.obj.isMetaInfo(key,value))
						Arr[A_Index]:="",break
				Arr[A_Index]:=isobject(Arr[A_Index])
			}
			return arr.length() == 1?arr[1]:arr
		}
		Swap(Index_Key,Swap_Value,byref Arr*)	{
			Output:=Array()
			Loop % Arr.Length()
			{
				if(Arr[A_Index].hasKey(Index_Key))
					Output.push(Arr[A_Index][Index_Key]),		Arr[A_Index][Index_Key]:=Swap_Value
				else
					Output.push("")
			}
			return Output.length() == 1?Output[1]:Output
		}
	}
	Class Linear extends Lib.obj.Array.Generic{
		Clone(Arr*)	{
				Loop % Arr.length()
				{
					tOut:=Array()
					For index,value in Arr[A_Index]
						if(!Lib.obj.isMetaInfo(index,value))
							tOut.push(value)
					Arr[A_Index]:=tOut
				}
				return arr.length() == 1?arr[1]:arr
		}
		/*
			
			trim_instruction:
				1 - Remove at beginning of array
				0 - remove value at end of array
				an array of instructions can be input and they will be cycled through
		*/
		Trim(size,trim_instruction:=0,Arr*)	{
			if(!isobject(trim_instruction))
				trim_instruction:=[trim_instruction,trim_instruction]
			Loop % Arr.length()
			{
				tArr:=Arr[A_Index]
				increment:=1
				While(this.Length(tArr) >= size)
				{
					inst_num:=Mod(increment,trim_instruction.length()) + 1
					increment++
					if(trim_instruction[inst_num] == 1)
						remval:=tArr.RemoveAt(1)
					else
						remval:=tArr.pop()
					if(Lib.obj.isMetaInfo(remval))		{
						Random rando, 1, % tArr.Length()
						tArr.InsertAt(rando,remval)
					}
				}
				Arr[A_Index]:=tArr
			}
			return Arr.length() == 1 ? arr[1]:arr
		}
		Split(Split_Index, Arr*) {
			Arr.push("")
			Arr:=this.Clone(Arr*)
			Arr.pop()
			Loop % Arr.Length()
			{
				Arr[A_Index]:=[Arr[A_Index].clone(),Arr[A_Index].Clone()]
				Arr[A_Index][1].removeAt(Split_Index,Split_Index + Arr[A_Index][1].Length() - 1)
				Arr[A_Index][2].removeAt(1,Split_Index - 1)
			}
			return arr.length() == 1?arr[1]:arr
		}
		Length(Arr*)
		{
			Loop % Arr.length()
			{
				length:=0
				For index,value in Arr[A_Index]
					if(!Lib.obj.isMetaInfo(index,value))
						length++
				Arr[A_Index]:=Length
			}
			return arr.length() == 1?arr[1]:arr
		}
	}
	Class Associative extends Lib.obj.Array.Generic {
			Clone(Arr*)	{
				Loop % Arr.length()
				{
					tOut:=Array()
					For key,value in Arr[A_Index]
						if(!Lib.obj.isMetaInfo(Key,value))
							tOut[key]:=value
					Arr[A_Index]:=tOut
				
				}
				return arr.length() == 1?arr[1]:arr
			}
			Keys(Arr*)	{
				Loop % Arr.Length()
				{
					tout:=Array()
					For key,value in Arr[A_Index]
						if(!Lib.obj.isMetaInfo(key,value))
							tout.push(key)
					Arr[A_Index]:=tout
				}
				return arr.length() == 1?arr[1]:arr
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