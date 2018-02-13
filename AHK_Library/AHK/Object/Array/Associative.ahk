Class Associative extends Ahk.obj.Array.Generic {
	/*
			Clone(Arr*)
			Creates a clone of the array with meta values absent.
	*/
	Clone(Arr*)	{
		For i,sArr in Arr {
			tOut:=Array()
			For key,value in sArr
				if(!Ahk.obj.isMetaInfo(Key,value))
					tOut[key]:=value
			Arr[i]:=tOut
		}
		return AHK.Helpers.Variadic_RTN_FMT_Optional(Arr)
	}
	/*
		removeAll(value,Arr*)
		Returns Array with all keys with specified value removed.
	*/
	removeAll(value,Arr*)	{
		For i,sArr in Arr	{
			For key,val in sArr
				if(value == val)
					Arr[i].remove(key)
		}
		return AHK.Helpers.Variadic_RTN_FMT_Optional(Arr)
	}
	/*
		toString(Arr*)
		Returns the Array in an AHK compatible string format.
	*/
	toString(Arr*){
		For i,sArr in Arr	{
			sOut:=""
			For Key,Value in sArr
				if(!Ahk.obj.isMetaInfo(Key,value))
					sOut.=", " key ":" Ahk.obj.Array.toString(Value)
			StringTrimLeft sOut,sOut,1
			Arr[i]:="{" sOut "}"
		}
		return AHK.Helpers.Variadic_RTN_FMT_Optional(Arr)
	}
}