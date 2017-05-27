Class Filter extends Lib.Obj.Array {
	Call(Function,Filter,include_meta:=0,Arr*)	{
		if(!this.isFilter(Filter) or Arr.Length() == 0)
			return
		this.Generic.Helper.Default_Param(Arr,0,include_meta)
		if(include_meta) {
			For i,sArr in Arr {
				Output:=Array()
				For key,Value in sArr {
					if(Filter.Filter({eval:Value,root:sArr,Key_Value:[{key:key,Value:value}],SubF_Parent:[{Filter:filter,eval:value}],SubF_ID:Array()}))
						Output[key]:=Value
				}
				Arr[i]:=Output
			}
		}
		else {
			For i,sArr in Arr {
				Output:=Array()
				For key,Value in sArr {
					if(!Lib.obj.isMetaInfo(key,value)) {
						if(Filter.Filter({eval:Value,root:sArr,Key_Value:[{key:key,Value:value}],SubF_Parent:[{Filter:filter,eval:value}],SubF_ID:Array()}))
							Output[key]:=Value
					}
				}
				Arr[i]:=Output
			}
		}
		return this.Generic.Helper.Return_Format(Arr)
	}
	Keys(Filter,include_meta:=0,Arr*) {
		if(!this.isFilter(Filter) or Arr.Length() == 0)
			return
		this.Generic.Helper.Default_Param(Arr,0,include_meta)
		if(include_meta) {
			For i,sArr in Arr {
				Output:=Array()
				for key,Value in sArr {
					if(Filter.Filter({eval:Value,root:sArr,Key_Value:[{key:key,Value:value}],SubF_Parent:[{Filter:filter,eval:value}],SubF_ID:Array()}))
							Output.push(Key)
						F_Inst.Key_Value.pop()
				}
				Arr[i]:=Output
			}
		}
		else {
			For i,sArr in Arr {
				Output:=Array()
				for key,Value in sArr {
					if(!Lib.obj.isMetaInfo(key,value)) {
							if(Filter.Filter({eval:Value,root:sArr,Key_Value:[{key:key,Value:value}],SubF_Parent:[{Filter:filter,eval:value}],SubF_ID:Array()}))
								Output.push(Key)
					}
				}
				Arr[i]:=Output
			}
		}
		return this.Generic.Helper.Return_Format(Arr)
	}
	Values(Filter,include_meta:=0,Arr*) {
		if(!this.isFilter(Filter) or Arr.Length() == 0)
			return
		this.Generic.Helper.Default_Param(Arr,0,include_meta)
		if(include_meta) {
			For i,sArr in Arr {
				Output:=Array()
				for key,Value in sArr {
					if(Filter.Filter({eval:Value,root:sArr,Key_Value:[{key:key,Value:value}],SubF_Parent:[{Filter:filter,eval:value}],SubF_ID:Array()}))
						Output.push(Value)
				}
				Arr[i]:=Output
			}
		}
		else {
			For i,sArr in Arr {
				Output:=Array()
				for key,Value in sArr {
					if(!Lib.obj.isMetaInfo(key,value)) {
						if(Filter.Filter({eval:Value,root:sArr,Key_Value:[{key:key,Value:value}],SubF_Parent:[{Filter:filter,eval:value}],SubF_ID:Array()}))
								Output.push(Value)
					}
				}
				Arr[i]:=Output
			}
		}
		return this.Generic.Helper.Return_Format(Arr)
	}
	
	isFilter(Filter:="")	{
		static Filter_Interface:=Lib.obj.class.interface({Filter:{Description:"Tests whether value should not be filtered out",MinParamsPlus1:2}})
		return isobject(Filter)?Filter_Interface.isImplemented(Filter):Filter_Interface
	}
	
	;Filter Templates
	Class Template extends Lib.Obj.Array.Filter {
		Call(Self,params*) {
			if(isobject(self))
				return new this(params*)
		}
		Filter(F_Inst) {
			return 0
		}
	}

	#Include %A_Scriptdir%\Library\Object\Array\Filter\Logic.ahk
	#Include %A_Scriptdir%\Library\Object\Array\Filter\Reference.ahk
	#Include %A_Scriptdir%\Library\Object\Array\Filter\Comparison.ahk


	


	;Miscellaneous Filters
	Class isMeta extends Lib.Obj.Array.Filter.Template {
		__New(Depth:=-1)	{
			this.Depth:=depth is digit and depth != "" and depth > 0? depth:-1
		}
		Filter(F_Inst) {
			if(this.depth == -1) {
				For i,kv in F_Inst.Key_Value
					if(Lib.obj.isMetaInfo(kv.Key,kv.Value))
						return 1
			}
			else {
				Loop %depth%
					if(Lib.obj.isMetaInfo(F_Inst.Key_Value[A_Index]Key,F_Inst.Key_Value[A_Index]Value))
						return 1
			}
			return 0
		}
	}
}