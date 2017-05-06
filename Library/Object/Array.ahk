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
				assoc_output.=", " key ":" val,	arr_output.=" ," val
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
	containsValue(arr,val)	{
		For key, value in arr
			if(value == val)
				return key
		return ""
	}
	containsKey(arr,kv)	{
		For key, value in arr
			if(key == kv)
				return 1
		return 0
	}
	contains(arr,val)	{
		For key, value in arr
			if(key == val or value == val)
				return 1
		return 0
	}
	Insert_Value(arr,value,overwrite:=0,preserve_subArray:=0)
	{
	
	
	}
	Get_Value(arr,keys)
	{
	
	
	}


}