Class Array{
	toString(arr)	{
		if(!isobject(arr))	{
			if arr is number
				return arr
			return """" arr """"
		}
		assoc_output:="{"
		arr_output:="[ "
		isarr:=1
		For key, value in arr
		{
			val:=this.toString(value)
			if(isarr == 1)	
				assoc_output.=key ":" val,	arr_output.=val
			else
				assoc_output.=", " key ":" val,	arr_output.=", " val
			if(isarr)	{
				if(key == isarr)
					isarr++
				else
					isarr:=0
			}
		}
		return isarr ? arr_output "]":assoc_output "}"
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
	Regex_Search(arr,NeedleRegEx,recursive:=0,exclude:=0)	{
		Output:=Array()
		For key, value in arr
			if(isobject(value) and recursive)
				val:=this.Regex_Search(value,NeedleRegEx,recursive,exclude),	Output[key]:=this.isEmpty(val)?val:""
			else if(exclude?!RegExMatch(key, NeedleRegEx):RegExMatch(key, NeedleRegEx))
				Output[key]:=value
		return Output
	}
	isEmpty(arr)	{
		For key, value in arr
				return 1
		return 0
	}
	hasValue(arr,val)	{
		For key, value in arr
			if(value == val)
				return key
		return ""
	}
	/*
		Overwrite:
			0 - does not overwrite values in Arr or its subarrays.
			1 - combines subarrays and overwrites values
			2 - overwrites subarrays
	
	*/
	combine(Arr,InsArr,overwrite:=1)	{
		for key,value in InsArr
		{
			if(Arr[key] == "" or  (overwrite == 1 and !isobject(Arr[key])) or overwrite ==2)
				Arr[key]:=value
			else if(isobject(Arr[key]) and isobject(value))
				Arr[key]:=this.combine(Arr[key],value,overwrite)
		}
		return Arr
	}
	
}
