Class Class{
	#Include %A_Scriptdir%\AHK_Library\AHK\Lang\Class\Interface.ahk
	#Include %A_Scriptdir%\AHK_Library\AHK\Lang\Class\Meta.ahk
	hasBase(byref Obj){
		return !isobject(this.Base(Obj))
	}
	isGlobal(byref Obj){
		return Obj == this.Global(Obj)
	}
	isPrototype(Obj){
		if(!isObject(Obj))
		return 0
		While(isObject(Obj)){
			if(isobject(this.Global(Obj)))
				return 0
			Obj:=this.Base(Obj)
		}
		return 1
	}
	Name(byref Obj){
		clsname:=this.Global.Name(Obj)
			return instr(clsname,".")?substr(clsname,instr(clsname,".",,0)+1):clsname
	}
	Class Base extends AHK.Lang.Class.Meta.Call_Functor{
		Call(byref self, byref Obj){
			return Obj.base
		}
		Root(Obj){
			while(isobject(this.Base(Obj)))
			Obj:=this.Call("",Obj)
			return Obj
		}
		Ancestry(Obj){
			Anc:=Array()
			if(isobject(Obj)){
				Anc.push(Obj)
				while(isobject(this.Call("",Obj))) {
					Obj:=this.Call("",Obj)
					Anc.push(Obj)
				}
			}
			return Anc
		}
	}
	Class Global extends AHK.Lang.Class.Meta.Call_Functor {
		/*
			Method - Global(Obj)
			Description - Gets Global Class Object
			Return -  Returns Global Class Object
			Parameters :
			Obj - Instance Object or class name of the global class object to retrieve
		*/
		Call(byref self,byref Obj) {
			cls:=this.Name(Obj)
			if(cls != ""){
				stree:=StrSplit(cls,".")
				root:=stree.RemoveAt(1)
				try{
					root:=%root%	;Gets root object
					return !isobject(root)?"":stree.length() == 0?root:root[stree*] ;gets SubObject
				}
			}
		}
		Name(byref Obj){
			return isobject(obj)?obj.__Class:obj
		}
		Ascend(byref Obj,Levels:=1){
			clsname:=this.Name(Obj)
			return instr(clsname,".")? this.Call("",substr(clsname,1,instr(clsname,".",,-1,Levels)-1)):""
		}
		Root(byref Obj){
			cls:=this.Name(Obj)
			if(cls != ""){
				stree:=StrSplit(cls,".")
				try{
					root:=% stree[1]	;Gets root object
					return root
				}
			}
		}
		
	}
}						