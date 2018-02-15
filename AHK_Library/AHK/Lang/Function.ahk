Class Func{
	isFunc(function){
		return instr(isobject(function)?function.name:function,".")?isfunc(function)-1:isfunc(function)
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
		return isobject(function) and isfunc(function)?function.Call(Parameters*):instr(function,".")?%Function%(AHK.Lang.Class.Global(substr(function,1,instr(function,".",,-1)-1)),Parameters*):%Function%(Parameters*)
	}
	ClassName(function){
		Name:=this.Name(Function)
		return substr(name,1,instr(name,".",,-1)-1)
	}
	Name(function){
		return isobject(function)?function.name:function
	}
}