Class Generic {
	isKey(allow_arr_Key:=1,Keys*) {
		AHK.Helpers.Variadic_PARAM_DEF_VAL(Keys,1,allow_arr_Key)
		if(allow_arr_Key)
		Keys.push(""), Linear:=this.isLinear(Keys*), Keys.pop()
		For i,Key in Keys {
			if(Linear[i] and allow_arr_Key)	{
				Keys[i]:=1
				For a,sKey in Key
				if(sKey == "" or RegExMatch(sKey, "([[:alnum:]]|#|\$|_|@)*(*PRUNE)\D") or StrLen(sKey) >= 253 or isObject(sKey))
				Keys[i]:=0,break
			}
			else
			Keys[i]:=!(Key == "" or RegExMatch(Key, "([[:alnum:]]|#|\$|_|@)*(*PRUNE)\D") or StrLen(Key) >= 253 or isObject(Key))
		}
		return AHK.Helpers.Variadic_RTN_FMT_Optional(Keys)
	}
	/*
		Returns boolean value as to whether Arr is a linear array
		
	*/
	isLinear(Arr*)	{
		for i, sArr in Arr {
			if(!isobject(sArr))
			Arr[i]:=0
			else	
			{
				index:=1
				For key, value in sArr	{
					if(key != index)
					index:=-1,break
					index++
				}
				Arr[i]:=index != -1
			}
		}
		return AHK.Helpers.Variadic_RTN_FMT_Optional(Arr)
	}
	/*
		Returns a linear array of the keys in Array (Excludes all Meta Info)
	*/
	Keys(Arr*)		{
		for i, sArr in Arr		{
			tout:=Array()
			For key,value in sArr
			if(!Ahk.obj.isMetaInfo(key,value))
			tout.push(Key)
			Arr[i]:=tout
		}
		return AHK.Helpers.Variadic_RTN_FMT_Optional(Arr)
	}
	/*
		Returns a linear array of the values in Array (Excludes all Meta Info)
	*/
	Values(Arr*)	{
		for i, sArr in Arr		{
			tout:=Array()
			For key,value in sArr
			if(!Ahk.obj.isMetaInfo(key,value))
			tout.push(Value)
			Arr[i]:=tout
		}
		return AHK.Helpers.Variadic_RTN_FMT_Optional(Arr)
	}
	/*
		Returns a boolean value of whether Array is empty. (Excludes all Meta Info)
	*/
	isEmpty(Arr*)	{
		For i,sArr in Arr {
			For key,value in sArr
			if(!Ahk.obj.isMetaInfo(key,value))
			Arr[i]:="",break
			Arr[i]:=isobject(Arr[i])
		}
		return AHK.Helpers.Variadic_RTN_FMT_Optional(Arr)
	}
	/*
		Purges all empty values from Array
	*/
	purge(byref Arr*)	{
		Arr.push(Array())
		Arr:=Ahk.Obj.Array.RemoveAll("",Arr*)
		Arr.pop()
	}
	/*
		toString(value*)
		Returns a string value in an AHK compatible string format.
	*/
	toString(value*)	{
		For i,val in value
		if val is not number
		value[i]:="""" val """"
		return AHK.Helpers.Variadic_RTN_FMT_Optional(Value)
	}
	/*
		hasValue(value,is_CSV:=0,Arr*)
		boolean Check whether the array has value. if is_CSV is true then it will parse the value as a CSV and return first index/key of matching value.
	*/
	hasValue(value,is_CSV:=0,Arr*) {
		AHK.Helpers.Variadic_PARAM_DEF_VAL(Arr,0,is_CSV)
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
		return AHK.Helpers.Variadic_RTN_FMT_Optional(Arr)
	}
	hasKey(Key,Arr*) {
		if(!isobject(Key))	{ ;A Single Key or CSV List of keys is provided
			multiple:=instr(Key,",")
			For i,sArr in Arr {
				Arr[i]:=multiple?"":0
				Loop, Parse, Key,CSV
				if(sArr.hasKey(A_LoopField))
				Arr[i]:=multiple?A_LoopField:1, break
			}
		}
		else if(this.isKey(Key)) { ;Key Array is provided
			ArrKeys:=Array()
			LastKey:=Array()
			Arr.push("")
			For i, K in Key {
				Keys:=Array()
				Loop % i
				if(A_LoopField == i)
				LastKey[i]:=Key[A_LoopField]
				else
				Keys.push(Key[A_LoopField])
				ArrKeys[i]:=this.get(Keys,Arr*)
			}
			Arr.pop()
			For i, sArr in Arr {
				Arr[i]:=1
				For ik,kArr in ArrKeys
				if(!kArr[i].hasKey(Lastkey[ik]))
				Arr[i]:=0,break
			}
		}
		else
		return
		return AHK.Helpers.Variadic_RTN_FMT_Optional(Arr)
	}
	Sort_Group(Group_Keys:=1,Sort_Keys:="",Skip_Meta:=1,Arr*)		{
		AHK.Helpers.Variadic_PARAM_DEF_VAL(Arr,1,Group_Keys,1,Skip_Meta,"",Sort_Keys)
		tGroup_Keys:=Array()
		Loop, parse, Group_Keys,CSV
		tGroup_Keys.push(A_LoopField)
		Group_Keys:=tGroup_Keys
		For i,sArr in Arr	{
			GMap:=Array()
			For gi,Group_Key in Group_Keys
			For key,group in sArr[Group_Key] {	;Builds Grouping Map
				if(group == "" or (Skip_Meta and Ahk.Obj.isMetaInfo(key,group)))
				continue
				if(!this.isKey(group))
				group:=Ahk.Hash(group)
				if(!isobject(GMap[Group]))
				Gmap[Group]:=Array()
				Gmap[Group].push(key)
			}
			if(Sort_Keys == "") {	;No Sort_Keys is defined, so sort all Keys
				For key,sVal in sArr ;Builds Grouping for each key in Array
				if(isobject(sVal) and !this.hasValue(key,0,Group_Keys)){ ;Ensures Value is Object and not a Group_Key
					Arr[i][key]:=this.Helper_Sort_Group_Keys(sVal,GMap)
				}
			}
			else { ;Sort_Keys is defined
				Loop, parse, Sort_Keys, CSV
				if(this.isKey(A_LoopField))
				if(sArr.hasKey(A_LoopField))
				Arr[i][A_LoopField]:=this.Helper_Sort_Group_Keys(sArr[A_LoopField])
			}
		}
		return AHK.Helpers.Variadic_RTN_FMT_Optional(Arr)
	}
	Helper_Sort_Group_Keys(gVal, GMap)	{	;Groups gVal according to Group map
		GKMap:=Array()
		For group,gKeys in GMap {	;Build each group in GroupMap
			GKMap[Group]:=Array()
			For gi, gKey in gKeys	;Moves each Key value in that Group list into Grouping
			if(sVal.hasKey(gKey))
			GKMap[group].push(sVal[gKey])
		}
		return GKMap
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
		if(Key != "")		{
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
		}
		return AHK.Helpers.Variadic_RTN_FMT_Optional(Arr)
	}
	/*
		Length(Arr*)
		Returns the number of non-meta items in the array.
	*/
	Length(Arr*)		{
		Output:=Array()
		For i,sArr in Arr {
			length:=0
			For index,value in sArr
			if(!Ahk.obj.isMetaInfo(index,value))
			length++
			Output[i]:=Length
		}
		return AHK.Helpers.Variadic_RTN_FMT_Optional(Output)
	}
	
}				