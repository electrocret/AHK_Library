Class NumCompare_Template extends Lib.Obj.Array.Filter.Template {
	__New(Values*) {
		For i,val in Values {
			if val is Number 
				this.Higherbound:=this.Higherbound == "" or val > this.Higherbound?val:this.Higherbound,	this.LowerBound:=this.LowerBound == "" or val < this.LowerBound?val:this.LowerBound
		}
	}
}
Class Equal extends Lib.Obj.Array.Filter.Template {
	__New(Values*)	{
		this.Values:=Values
	}
	Filter(F_Inst) {
		return this.generic.hasValue(F_Inst.Eval,this.Values)
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
Class Matchlist_Template extends Lib.Obj.Array.Filter.Template {
	__New(Values*) {
		For i,val in Values 
			Matchlist.=isObject(val) or val == ""?"":"," Val
		this.Matchlist:=Substr(Matchlist,2)
	}
}
Class contains extends Lib.Obj.Array.Filter.Matchlist_Template {
	Filter(F_Inst) {
		if(!isobject(F_Inst.Eval))	
			Matchlist:=this.Matchlist,	return F_Inst.Eval contains %Matchlist%
		return 0
	}
}
Class in extends Lib.Obj.Array.Filter.Matchlist_Template {
	Filter(F_Inst) {
		if(!isobject(F_Inst.Eval))	
			Matchlist:=this.Matchlist,	return F_Inst.Eval in %Matchlist%
		return 0
	}
}
Class isType extends Lib.Obj.Array.Filter.Template {
	__New(Types*) {
		this.Types:=Array()
		this.Not_Types:=Array()
		For i,T in Types {
			if(T == "object")
				this.obj:=1
			if(T == "not empty")
				this.Not_Empty:=1
			else if T in integer,float,number,digit,xdigit,alpha,upper,lower,alnum,space,time
				this.Types.push(T)
			else if T in not integer,not float,not number,not digit,not xdigit,not alpha,not upper,not lower,not alnum,not space,not time
				this.Not_Types.push(T)
		}
	}
	Filter(F_Inst) {
		if(this.obj)
			if(isobject(F_Inst.eval))
				return 1
		if(this.Not_Empty)
			if(F_Inst.eval == "")
				return 0
		For i,T in this.Types
			if F_Inst.eval is %T%
				return 1
		For i,T in this.Not_Types 
			if F_Inst.eval is not %T%
				return 1
		return 0
	}
}