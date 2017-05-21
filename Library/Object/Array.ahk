Class Array extends Lib.obj.meta.Call{
	#Include %A_ScriptDir%\Library\Object\Array\Filter.ahk
	Call(function,byref Parameters*)	{	;Needs rewritten so it takes advantage of Variatic
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
	Class Generic {
		isLinear(Arr*)	{
			for i, sArr in Arr {
				index:=1
				For key, value in sArr	{
					if(key != index)
						index:=-1,break
					index++
				}
				Arr[i]:=index != -1
			}
			return this.Helper.Return_format(Arr)
		}
		Keys(Arr*)	{
			for i, sArr in Arr		{
				tout:=Array()
				For key,value in sArr
					if(!Lib.obj.isMetaInfo(key,value))
						tout.push(Key)
				Arr[i]:=tout
			}
			return this.Helper.Return_format(Arr)
		}
		Values(Arr*)	{
			for i, sArr in Arr		{
				tout:=Array()
				For key,value in sArr
					if(!Lib.obj.isMetaInfo(key,value))
						tout.push(Value)
				Arr[i]:=tout
			}
			return this.Helper.Return_format(Arr)
		}
		isEmpty(Arr*)	{
			For i,sArr in Arr {
				For key,value in sArr
					if(!Lib.obj.isMetaInfo(key,value))
						Arr[i]:="",break
				Arr[i]:=isobject(Arr[i])
			}
			return this.Helper.Return_format(Arr)
		}
		purge(byref Arr*)	{
			Arr.push(Array())
			Arr:=Lib.Obj.Array.RemoveAll("",Arr*)
			Arr.pop()
		}
		toString(value*)	{
			For i,val in value
				if val is not number
					value[i]:="""" val """"
			return this.Helper.Return_format(Value)
		}
		hasValue(value,is_CSV:=0,Arr*) {
			this.Helper.Default_Param(Arr,0,is_CSV)
			if(is_CSV and !isobject(value)) {
				for i,sArr in Arr	{
					Loop, Parse, Value,CSV 
					{
						For	key,val in sArr
							if(val == A_LoopField)
								Arr[i]:=key,break
						if(!isobject(Arr[i]))
							break
					}
					if(isObject(Arr[i]))
						Arr[i]:=""
				}
			}
			else		{
				for i, sArr in Arr {
					For	key,val in sArr {
						if(val == value)
							Arr[i]:=1,break
					}
					if(isObject(Arr[i]))
						Arr[i]:=0
				}
			}
			return this.Helper.Return_format(Arr)
		}
		hasKey(Key,Arr*) {
			multiple:=instr(Key,",")
			For i,sArr in Arr {
				Loop, Parse, Key,CSV
					if(sArr.hasKey(A_LoopField))
						Arr[i]:=multiple?A_LoopField:1, break
				if(isobject(Arr[i]))
					Arr[i]:=multiple?"":0
			}
			return this.Helper.Return_format(Arr)
		}
		Sort_Group(Group_Keys:=1,Sort_Keys:="",Skip_Meta:=1,Arr*)		{
			this.Helper.Default_Param(Arr,1,Group_Keys,Skip_Meta,"",Sort_Keys)
			tGroup_Keys:=Array()
			Loop, parse, Group_Keys,CSV
				tGroup_Keys.push(A_LoopField)
			Group_Keys:=tGroup_Keys
			For i,sArr in Arr	{
				GMap:=Array()
				For gi,Group_Key in Group_Keys
					For key,group in sArr[Group_Key] {	;Builds Grouping Map
						if(group == "" or (Skip_Meta and Lib.Obj.isMetaInfo(key,group)))
							continue
						if(isobject(group) or RegExMatch(group, "([[:alnum:]]|#|\$|_|@)*(*PRUNE)\D") or StrLen(group) >= 253)
							group:=Lib.Hash(group)
						if(!isobject(GMap[Group]))
							Gmap[Group]:=Array()
						Gmap[Group].push(key)
					}
				if(Sort_Keys == "") {	;No Sort_Keys is defined, so sort all Keys
					For key,sVal in sArr ;Builds Grouping for each key in Array
						if(isobject(sVal) and !this.hasValue(key,0,Group_Keys)) ;Ensures Value is Object and not a Group_Key
							Arr[i][key]:=this.Helper.Sort_Group_Keys(sVal,GMap)
				}
				else { ;Sort_Keys is defined
					Loop, parse, Sort_Keys, CSV
						if(!(RegExMatch(A_LoopField, "([[:alnum:]]|#|\$|_|@)*(*PRUNE)\D") or StrLen(A_LoopField) >= 253))
							if(sArr.hasKey(A_LoopField))
								Arr[i][A_LoopField]:=this.Helper.Sort_Group_Keys(sArr[A_LoopField])
				}
			}
			return this.Helper.Return_format(Arr)
		}
		Swap(Index_Key,Swap_Value,byref Arr*)	{
			Output:=this.get(Index_Key,Arr*)
			this.Set(Index_Key,Swap_Value,Arr*)
			return Output
		}
		Set(Key,Value,byref Arr*)	{
			if(isobject(Key))
				for i,sArr in Arr
					Arr[i][Key*]:=Value
			else
				for i, sArr in Arr
					Arr[i][Key]:=Value
		}
		Get(Key,Arr*){
			if(isobject(Key)) 
				for i,sArr in Arr
					Arr[i]:=sArr[Key*]
			else if(instr(Key,",")) 
				for i,sArr in Arr	{
					output:=Array()
					Loop, Parse, Key,CSV
						output[A_LoopField]:=sArr[A_LoopField]
					Arr[i]:=Output
				}
			else 
				for i,sArr in Arr
					Arr[i]:=sArr[Key]
			return this.Helper.Return_format(Arr)
		}
		Class Helper {
			Default_Param(Byref Arr,Byref Params*) {
				For i,Val in Params
					if(isObject(Val)) 
						Arr.push(Params[i]),	Params[i]:=Default_Value
					else
						Default_Value:=Val
			}
			Return_format(byref Output) {
				return Output.length() == 1? Output[1]:Output
			}
			Sort_Group_Keys(gVal, GMap)	{	;Groups gVal according to Group map
				GKMap:=Array()
				For group,gKeys in GMap {	;Build each group in GroupMap
					GKMap[Group]:=Array()
					For gi, gKey in gKeys	;Moves each Key value in that Group list into Grouping
						if(gVal.hasKey(gKey))
							GKMap[group].push(gVal[gKey])
				}
				return GKMap
			}
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
				return this.Helper.Return_format(Arr)
		}
		/*
			trim_instruction:
				1 - Remove at beginning of array
				0 - remove value at end of array
				an array of instructions can be input and they will be cycled through
		*/
		
		Trim(trim_instruction,size,Arr*)	{ ;Needs updated so trim_instruction uses CSV
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
			return this.Helper.Return_format(Arr)
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
			return this.Helper.Return_format(Arr)
		}
		Length(Arr*)		{
			For i,sArr in Arr {
				length:=0
				For index,value in sArr
					if(!Lib.obj.isMetaInfo(index,value))
						length++
				Arr[i]:=Length
			}
			return this.Helper.Return_format(Arr)
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
			return this.Helper.Return_format(Arr)
		}
		toString(Arr*){
			for i,sArr in Arr	{
				Loop % sArr.length()
					if(!Lib.obj.isMetaInfo(A_Index,sArr[A_Index]))
						sOut.= ", " Lib.Obj.Array.toString(sArr[A_Index])
				StringTrimLeft,sOut,sOut,1
				Arr[i]:="[" sOut "]"
			}
			return this.Helper.Return_format(Arr)
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
			return this.Helper.Return_format(Arr)
		}
		removeAll(value,Arr*)	{
			For i,sArr in Arr	{
				For key,value in sArr
					if(value == value)
						Arr[i].remove(key)
			}
			return this.Helper.Return_format(Arr)
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
			return this.Helper.Return_format(Arr)
		}
	}
}