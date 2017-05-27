Class Equal extends Lib.Obj.Array.Filter.Template {
	__New(Values*)	{
		this.Values:=Values
	}
	Filter(F_Inst) {
		return this.generic.hasValue(F_Inst.Eval,this.Values)
	}
}
Class NumCompare_Template extends Lib.Obj.Array.Filter.Template {
	__New(Values*) {
		For i,val in Values {
			if val is Number 
				this.Higherbound:=this.Higherbound == "" or val > this.Higherbound?val:this.Higherbound,	this.LowerBound:=this.LowerBound == "" or val < this.LowerBound?val:this.LowerBound
		}
	}
}
Class Between extends Lib.Obj.Array.Filter.NumCompare_Template {
	Filter(F_Inst) {
		return F_Inst.eval is not Number ? 0 : F_Inst.eval > this.LowerBound and F_Inst.eval < this.UpperBound
	}
}
Class BetweenOrEqual extends Lib.Obj.Array.Filter.NumCompare_Template {
	Filter(F_Inst) {
		return F_Inst.eval is not Number ? 0 : F_Inst.eval >= this.LowerBound and F_Inst.eval =< this.UpperBound
	}
}
Class GreaterThan extends Lib.Obj.Array.Filter.NumCompare_Template {
	Filter(F_Inst) {
		return F_Inst.eval is not Number ? 0 : F_Inst.eval > this.UpperBound
	}
}
Class GreaterThanOrEqual extends Lib.Obj.Array.Filter.NumCompare_Template {
	Filter(F_Inst) {
		return F_Inst.eval is not Number ? 0 : F_Inst.eval >= this.UpperBound
	}
}
Class LessThan extends Lib.Obj.Array.Filter.NumCompare_Template {
	Filter(F_Inst) {
		return F_Inst.eval is not Number ? 0 : F_Inst.eval < this.UpperBound
	}
}
Class LessThanOrEqual extends Lib.Obj.Array.Filter.NumCompare_Template {
	Filter(F_Inst) {
		return F_Inst.eval is not Number ? 0 : F_Inst.eval =< this.UpperBound
	}
}