Class Logic{
	in(byref Var,byref Matchlist){
		if Var in %Matchlist%
		return 1
		return 0
	}
	contains(byref Var, byref Matchlist){
		if Var contains %Matchlist%
		return 1
		return 0
	}
	Class isType{
		integer(Byref Variable){
			if Variable is integer
			return 1
			return 0
		}
		float(Byref Variable){
			if Variable is float
			return 1
			return 0
		}
		number(Byref Variable){
			if Variable is number
			return 1
			return 0
		}
		digit(Byref Variable){
			if Variable is digit
			return 1
			return 0
		}
		xdigit(Byref Variable){
			if Variable is xdigit
			return 1
			return 0
		}
		alpha(Byref Variable){
			if Variable is alpha
			return 1
			return 0
		}
		upper(Byref Variable){
			if Variable is upper
			return 1
			return 0
		}
		lower(Byref Variable){
			if Variable is lower
			return 1
			return 0
		}
		alnum(Byref Variable){
			if Variable is alnum
			return 1
			return 0
		}
		space(Byref Variable){
			if Variable is space
			return 1
			return 0
		}
		time(Byref Variable){
			if Variable is time
			return 1
			return 0
		}
	}
	
	
}