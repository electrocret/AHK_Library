Class KeyRef {
	__New(byref Keys*){
		this.KRef:=Array()
		For i,Key in Keys
		{
			if(isObject(Key)){
				if(AHK.Obj.Class.Global.Name(Key) == AHK.Obj.Class.Global.Name(this))
					this.KRef.push(Key.KRef*)
			}
			else if(!(Key == "" or RegExMatch(Key, "([[:alnum:]]|#|\$|_|@)*(*PRUNE)\D") or StrLen(Key) >= 253))
				this.KRef.push(Key)
		}
	}
	Root(){
		return this.KRef[1]
	}
	Ascend(byref Ascend_Lvls:=1){
		newKRef:=this.KRef.Clone()
		Loop, % Ascend_Lvls
			newKRef.pop()
		output:=new AHK.Obj.KeyRef()
		output.KRef:=newKRef
		return output
	}
	Descend(byref Descendant_Keys*){
		return new AHK.Obj.KeyRef(this,Descendant_Keys*)
	}
	Level(){
		return this.KRef.length()
	}
	Ancestry(){
		return this.KRef.clone()
	}
	Get(byref Obj)	{
		return Obj[this.KRef*]
	}
	Set(byref Obj, byref Value)	{
		return Obj[this.KRef*]:=Value
	}
	hasKey(byref Obj)	{
	
	
	}
	}