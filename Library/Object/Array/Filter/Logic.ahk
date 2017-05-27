	;Logic Filters
	Class Template_Logic extends Lib.Obj.Array.Filter.Template_SubFilter {
		__New(Filters*) {
			Loop % Filters.Length()
				Filters[A_Index]:=this.isFilter(Filters[A_Index])?Filters[A_Index]:""
			this.Generic.Purge(Filters),	this.Filters:=Filters
		}
	}
	Class AND extends Lib.Obj.Array.Filter.Template_Logic{
		Filter(byref F_Inst) {
			Loop % this.Filters.Length()
				if(!this.subFilter(F_Inst,this.Filters[A_Index],A_Index))
					return 0
			return 1
		}
	}
	Class OR extends Lib.Obj.Array.Filter.Template_Logic {
		Filter(byref F_Inst) {
			Loop % this.Filters.Length()
				if(this.subFilter(F_Inst,this.Filters[A_Index],A_Index))
					return 1
			return 0
		}
	}
	Class XOR extends Lib.Obj.Array.Filter.Template_Logic {
		Filter(byref F_Inst) {
			Filter_True:=0
			Loop % this.Filters.Length()
				if(this.subFilter(F_Inst,this.Filters[A_Index],A_Index))		{
					Filter_True++
					if(Filter_True >= 2)
						return 0
				}
			return Filter_True
		}
	}
	Class NOT extends Lib.Obj.Array.Filter.Template_Logic { ;Does NOR if Multiple Filters are provided
		Filter(byref F_Inst) {
			Loop % this.Filters.Length()
				if(this.subFilter(F_Inst,this.Filters[A_Index],A_Index))
					return 0
			return 1
		}
	}
	
	;Constants
	Class True extends Lib.Obj.Array.Filter.Template{
		Filter(byref F_Inst) {
			return 1
		}
	}
	Class False extends Lib.Obj.Array.Filter.Template{
		Filter(byref F_Inst) {
			return 0
		}
	}