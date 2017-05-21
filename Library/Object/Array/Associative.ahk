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