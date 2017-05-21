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