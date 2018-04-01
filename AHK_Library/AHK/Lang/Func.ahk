Class Func{
	isFunc(function){
		return !isfunc(function)?0:instr(isobject(function)?function.name:function,".")?isfunc(function)-1:isfunc(function)
	}
	isVariadic(function){
		return isobject(function)?function.isVariadic:Func(function).isVariadic
	}
	MinParams(function){
		return instr(isobject(function)?function.name:function,".")?(isobject(function)?function.MinParams-1:Func(function).MinParams-1):(isobject(function)?function.MinParams:Func(function).MinParams)
	}
	MaxParams(function){
		return instr(isobject(function)?function.name:function,".")?(isobject(function)?function.MaxParams-1:Func(function).MaxParams-1):(isobject(function)?function.MaxParams:Func(function).MaxParams)
	}
	isByRef(function,ParamIndex:=""){
		return instr(isobject(function)?function.name:function,".")?(isobject(function)?function.isByRef(ParamIndex+1):Func(function).isByRef(ParamIndex+1)):(isobject(function)?function.isByRef(ParamIndex):Func(function).isByRef(ParamIndex))
	}
	isOptional(function,ParamIndex:=""){
		return instr(isobject(function)?function.name:function,".")?(isobject(function)?function.isOptional(ParamIndex+1):Func(function).isOptional(ParamIndex+1)):(isobject(function)?function.isOptional(ParamIndex):Func(function).isOptional(ParamIndex))
	}
	willCall(function,Parameter_Count){
		minparam:=this.isFunc(function)
		return minparam and Parameter_Count >= minparam-1 and (this.MaxParams(function) >= Parameter_Count or this.isVariadic(Function))	
	}
	Global_Call(function,byref Parameters*)	{
		return !isfunc(function)?"":isobject(function)?(Parameters.length()?function.Call(Parameters*):function.Call()):instr(function,".")?(Parameters.length()?%Function%(AHK.Lang.Class.Global(substr(function,1,instr(function,".",,-1)-1)),Parameters*):%Function%(AHK.Lang.Class.Global(substr(function,1,instr(function,".",,-1)-1)))):(Parameters.length()?%Function%(Parameters*):%Function%())
	}
	ClassName(byref function){
		Name:=this.FullName(Function)
		return substr(name,1,instr(name,".",,-1)-1)
	}
	FullName(byref function){
		return isobject(function)?function.name:function
	}
	Name(function){
		FName:=this.FullName(Function)
		return instr(FName,".")?substr(FName,instr(FName,".",,0)+1):FName
	}
}