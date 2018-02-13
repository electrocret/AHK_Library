Class Array{
	toString(arr)	{
		if(!isobject(arr))	{
			if arr is number
				return arr
			return """" arr """"
		}
		return this.linear.isLinear(Arr)?this.linear.toString(Arr):this.associative.toString(Arr)
	}
	Clone(Arr)	{
		Output:=Array()
		For key, value in arr
			if(isobject(value))
				Output[key]:=this.Clone(value)
			else
				Output[key]:=value
		return Output
	}
	isEmpty(arr)	{
		arr:=this.purge(arr)
		For key, value in arr
				return 1
		return 0
	}
	hasValue(arr,val*)	{
		if(val.length() > 1){
			Loop % val.length()
				if(this.hasValue(val[A_Index]) == "")
					return 0
			return 1
		}
		For key, value in arr
			if(value == val[1])
				return key
		return ""
	}
	/*
		Overwrite:
			0 - does not overwrite values in Arr or its subarrays.
			1 - combines subarrays and overwrites values
			2 - overwrites subarrays
	*/
	combine(byref Arr,InsArr,overwrite:=1)	{
		if(this.Linear.isLinear(Arr,InsArr))
			return this.Linear.merge(Arr,InsArr)
		for key,value in InsArr
		{
			if(Arr[key] == "" or  (overwrite == 1 and !isobject(Arr[key])) or overwrite ==2)
				Arr[key]:=value
			else if(isobject(Arr[key]) and isobject(value))
				Arr[key]:=this.combine(Arr[key],value,overwrite)
		}
		return Arr
	}
	Swap(byref arr,Index_Keys,swap_value)	{
		output:=this.get(arr,index_Keys)
		this.Set(arr,Index_Keys,swap_value)
		return output
	}
	Purge(Arr){
		return this.linear.isLinear(Arr)?this.Linear.purge(arr):this.Associative.purge(arr)
	}
	Get(Arr,Index_Keys)	{
		return isobject(Index_Keys)?Arr[Index_Keys*]:Index_Keys
	}
	Set(byref Arr,Index_Keys,Value) {
		if(isobject(Index_Keys))
			Arr[Index_Keys*]:=Value
		else
			Arr[Index_Key]:=Value
	}
	nest(Arr,recursive:=1)	{
		Output:=Array()
		For key,value in Arr
		{
			if(isobject(value))
			{
				output.push(value)
				if(recursive)
					Output:=this.linear.merge(Output,this.get_nested(value,recursive))
			}
		}
		return Output
	}
	Class Associative extends Lib.obj.Array{
		toString(Arr){
			For Key,Value in arr
				output.=", " key ":" base.toString(Value)
			StringTrimLeft output,output,1
			return "{" output "}"
		}
		isAssociative(Arr*)	{
			return !this.linear.isLinear(Arr*)
		}
		Purge(Arr)	{
			For key,value in Arr
				if(value == "")
					Arr.remove(key)
			return Arr
		}
		Regex_KeySearch(arr,NeedleRegEx,recursive:=0,exclude:=0)	{
			Output:=Array()
			For key, value in arr
				if(isobject(value) and recursive)
					val:=this.Regex_Search(value,NeedleRegEx,recursive,exclude),	Output[key]:=this.isEmpty(val)?val:""
				else if(exclude?!RegExMatch(key, NeedleRegEx):RegExMatch(key, NeedleRegEx))
					Output[key]:=value
			return Output
		}
		Keys(Arr) {
			Output:=Array()
			for key,value in Arr
				Output.push(key)
			return output
		}
		Values(Arr) {
			Output:=Array()
			for key,value in Arr
				Output.push(value)
			return output
		}
	}
	Class Linear extends Lib.obj.Array{
		toString(Arr){
			Loop % Arr.Length()
				Output.=", " base.toString(Arr[A_Index])
			StringTrimLeft,Output,Output,1
			return "[" Output "]"
		}
		isLinear(Arr*)	{
				Loop % Arr.Length()
				{
					index:=1
					For key, value in arr[A_Index]
					{
						if(key != index)
							return 0
						index++
					}
				}
				return 1
		}
		purge(Arr)		{
			Output:=Array()
			Loop % Arr.length()
				if(Arr[A_Index] != "")
					Output.push(Arr[A_Index])
			return Output
		}
		merge(byref Arr*)	{
			Output:=Array()
			Loop % Arr.Length()
				Output.push(Arr[A_Index]*)
			return Arr[1]:=Output
		}
		Unique(Arr)	{
			Output:=Array()
			Loop % Arr.Length()
				if(!this.hasValue(Output,Arr[A_Index]))
					Output.push(Arr[A_Index])
			return Output
		}
		Join(Arr,delim:="`n")	{
			Loop % Arr.Length()
				out.=arr[A_Index] delim
			StringTrimRight, out,out, % StrLen(delim)
			return out
		}
		Splice(Arr,start,length:=0)	{
			Output:=Array()
			Loop % length>0?length:Arr.length()-start
				Output.push(Arr.RemoveAt(A_Index + start))
			return Output
		}
		IndexOf(Arr,Value)		{
			return this.hasValue(Arr,Value)
		}
		contains(Arr,Value) {
			return this.hasValue(Arr,Value)
		}
	}

}
