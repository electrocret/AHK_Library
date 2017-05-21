Class Filter extends Lib.Obj.Array {
	Call(Function,Filter,include_meta:=0,Arr*)	{
		if(!this.isFilter(Filter) or Arr.Length() == 0)
			return
		this.Generic.Helper.Default_Param(Arr,0,include_meta)
		if(include_meta) {
			For i,sArr in Arr {
				Output:=Array(),	F_Array:=[sArr]
				For key,Value in sArr {
					F_Array.insertAt(1,Value,key)
					if(Filter.Filter(F_Array))
						Output[key]:=Value
					F_Array.removeAt(1,2)
				}
				Arr[i]:=Output
			}
		}
		else {
			For i,sArr in Arr {
				Output:=Array(),	F_Array:=[sArr]
				For key,Value in sArr {
					if(!Lib.obj.isMetaInfo(key,value)) {
						F_Array.insertAt(1,Value,key)
						if(Filter.Filter(F_Array))
							Output[key]:=Value
						F_Array.removeAt(1,2)
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
				Output:=Array(),	F_Array:=[sArr]
				for key,Value in sArr {
					F_Array.insertAt(1,Value,key)
						if(Filter.Filter(F_Array))
							Output.push(Key)
					F_Array.removeAt(1,2)
				}
				Arr[i]:=Output
			}
		}
		else {
			For i,sArr in Arr {
				Output:=Array(),	F_Array:=[sArr]
				for key,Value in sArr {
					if(!Lib.obj.isMetaInfo(key,value)) {
						F_Array.insertAt(1,Value,key)
							if(Filter.Filter(F_Array))
								Output.push(Key)
						F_Array.removeAt(1,2)
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
				Output:=Array(),	F_Array:=[sArr]
				for key,Value in sArr {
					F_Array.insertAt(1,Value,key)
						if(Filter.Filter(F_Array))
							Output.push(Value)
					F_Array.removeAt(1,2)
				}
				Arr[i]:=Output
			}
		}
		else {
			For i,sArr in Arr {
				Output:=Array(),	F_Array:=[sArr]
				for key,Value in sArr {
					if(!Lib.obj.isMetaInfo(key,value)) {
						F_Array.insertAt(1,Value,key)
							if(Filter.Filter(F_Array))
								Output.push(Value)
						F_Array.removeAt(1,2)
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
		Filter(F_Array) {
			return 0
		}
	}
	Class Template_Logic extends Lib.Obj.Array.Filter.Template {
		__New(Filters*) {
			Loop % Filters.Length()
				Filters[A_Index]:=this.isFilter(Filters[A_Index])?Filters[A_Index]:""
			this.Generic.Purge(Filters),	this.Filters:=Filters
		}
	}
	;Logic Filters
	Class AND extends Lib.Obj.Array.Filter.Template_Logic{
		Filter(F_Array) {
			Loop % this.Filters.Length()
				if(!this.Filters[A_Index].Filter(F_Array))
					return 0
			return 1
		}
	}
	Class OR extends Lib.Obj.Array.Filter.Template_Logic {
		Filter(F_Array) {
			Loop % this.Filters.Length()
				if(this.Filters[A_Index].Filter(F_Array))
					return 1
			return 0
		}
	}
	Class XOR extends Lib.Obj.Array.Filter.Template_Logic {
		Filter(F_Array) {
			Filter_True:=0
			Loop % this.Filters.Length()
				if(this.Filters[A_Index].Filter(F_Array))		{
					Filter_True++
					if(Filter_True >= 2)
						return 0
				}
			return Filter_True
		}
	}
	Class NOT extends Lib.Obj.Array.Filter.Template_Logic { ;Does NOR if Multiple Filters are provided
		Filter(F_Array) {
			Loop % this.Filters.Length()
				if(this.Filters[A_Index].Filter(F_Array))
					return 0
			return 1
		}
	}




	;Miscellaneous Filters
	Class Keys extends Lib.Obj.Array.Filter.Template_Logic { ;Does Or on Key if Multiple Filters are provided
		Filter(F_Array) {
			if(F_Array.Length() < 2) 
				return 0
			Value:=F_Array.RemoveAt(1)
			Output:=0
			Loop % this.Filters.Length()
				if(this.Filters[A_Index].Filter(F_Array))
					Output:=1,break
			F_Array.InsertAt(1,Value)
			return Output
		}
	}
	Class isMeta extends Lib.Obj.Array.Filter.Template {
		Filter(F_Array) {
			return Lib.obj.isMetaInfo(F_Array[2],F_Array[1])
		}
	}
}