Class Interface extends AHK.Lang.Class.Meta.Call_Construct {
	Test(){
		static test:=new AHK.Obj.Interface()
		if(test.isNotBuilt(A_Thisfunc))
		{
			test.define("blah","blah",1)
		
		}
	
	}
	__New(Interface_Definition:="")	{
		if(!isobject(Interface_Definition) and Interface_Definition != "") ;Checks if Interface_Definition is possibly Object in text format.
			Interface_Definition:=AHK.Obj.JSON.Load(Interface_Definition) ;Tries converting Interface_Definition from JSON
		this.Interface_Definition:=isobject(Interface_Definition) and isobject(Interface_Definition.Description) and isobject(Interface_Definition.Parameters)?Interface_Definition:{Purpose:"Undefined",Description:{},Parameters:{}}	;Checks if Interface_Definition parameter is valid. If so then sets it to this. if not sets this to default blank Interface_Definition
	}
	
	isNotBuilt(Interface_Reference){
		static ID_Enumerator:=1
		if(this.ID is not digit){ ;Checks if Interface has not been built and set to file cache
			if(AHK.Lang.Func.isFunc(Interface_Reference)== 1){ ;Checks if this is a Function interface
				if(this.Interface_Ref_Test == Interface_Reference) {
					this.Interface_Ref_Test:=""
					return 0
				}
				this.Interface_Ref_Test:=Interface_Reference
				Random, verify_return
				this.verify_return:=verify_return
				if(AHK.Lang.Func.Call_Global(Interface_Reference).verify_return == this.verify_return) ;Verifies Interface_Reference Function returns this interface
					this.verify_return:="",this.Interface_Reference:=Interface_Reference,return 1 ;Clears unneeded var, Holds onto Interface_Reference for later use, and Returns true 
			}
			else if(isObject(Interface_Reference))	{
				 ;Needs to finalize Interface
			}
		}
		return 0
	}
	isImplemented(byref Obj){
		this.isNotBuilt(this)
		if(!AHK.Obj.Class.isPrototype(Obj)) { ;If Object is not a prototype
			Cache_ID:=StrReplace(AHK.Obj.Class.Global.Name(Obj),".","#") ;Generates Var friendly name for Class's Global Name.
			if(this.Cache_GlobalClass.hasKey(Cache_ID)) { ;Checks if GlobalClass cache has value for class's implementation of interface in it.
				if(isobject(this.Cache_FuncParam)){ ;Checks if Function Parameters are in memory
					this.Cache_FuncParam_Usage-- ;Decrements Function Parameter cache usage
					if(this.Cache_FuncParam_Usage<1) ;If Function Parameter cache usage hasn't been used 9 times in a row then
						this.ClearCache_FuncParam() ;Clear Function Parameter cache from memory
				}
				return this.Cache_GlobalClass[Cache_ID] ;Returns GlobalClass Cache value
			}
		}
		this.Cache_FuncParam_Usage:=9 ;Mark Function Parameter cache as being used, and start counter over.
		if(!isobject(this.Cache_FuncParam)) ;Checks if Function Parameters are in memory
			this.Cache_FuncParam:=AHK.Helpers.Cache_Load(this,{Description:{},Parameters:{}},this.ID).Parameters ;Loads Function Parameters into memory
		For function, parameters in this.Cache_FuncParam ;For each function in interface
			If(parameters != isfunc(obj[function]) - 1) ;Check if Object doesn't have function defined or doesn't have specified number of parameters
					not_implemented:=1,break ;Marks not implemented and exits For Loop
		if(Cache_ID != "") ;If Cache ID for GlobalClass Cache has been generated
			this.Cache_GlobalClass[Cache_ID]:=!not_implemented ;Store implementation result in GlobalClass Cache
		return !not_implemented
	}
	
	
	___New(Interface_Definition:="",Make_Cache_FuncParam:=1){
		static ID_Enumerator:=0 ;Defines ID ENumerator to ensure each Interface has its own ID.
		ID_Enumerator++ ;Enumerates Interface ID
		this.ID:=ID_Enumerator ;Records ID to Interface
		this.Cache_GlobalClass:=Array() ;Defines GlobalClass Implementation cache
		if(!isobject(Interface_Definition) and Interface_Definition != "") ;Checks if Interface_Definition is possibly Object in text format.
		Interface_Definition:=AHK.Obj.JSON.Load(Interface_Definition) ;Tries converting Interface_Definition from JSON
		if(isobject(Interface_Definition) and isobject(Interface_Definition.Description) and isobject(Interface_Definition.Parameters)) ;Checks Interface_Definition validity
			this.Cache_FuncParam:=Make_Cache_FuncParam?Interface_Definition.Parameters:"" ;Interface_Definition is valid. Keeps Function Parameters cached in memory for initial implementation testing.
		else
			Interface_Definition:={Purpose:"Undefined",Description:{},Parameters:{}}	;Sets Interface_Definition to default
		AHK.Helpers.Cache_Save(this,Interface_Definition,this.ID) ;Writes Interface_Definition to file cache
	}

	ClearCache(){
		this.ClearCache_GlobalClass(),	this.ClearCache_FuncParam()
	}
	ClearCache_GlobalClass(){
		this.Cache_GlobalClass:=Array()
	}
	ClearCache_FuncParam(){
		this.Cache_FuncParam:="",this.Cache_FuncParam_Usage:=""
	}
	Define(byref Function_Name,byref Description,Parameters:=0,Make_Cache_FuncParam:=1){
		Interface_Definition:=AHK.Helpers.Cache_Load(this,{Description:{},Parameters:{}},this.ID) ;Loads Interface_Definition from cache file
		Interface_Definition.Parameters[Function_Name]:=Parameters ;Sets expected Parameters for function
		Interface_Definition.Description[Function_Name]:=Description ;Sets Function description
		AHK.Helpers.Cache_Save(this,Interface_Definition,this.ID) ;Writes Interface_Definition to cache file
		if(Make_Cache_FuncParam) ;Checks if FuncParam cache should be created
			this.ClearCache_GlobalClass(),this.Cache_FuncParam:=Interface_Definition.Parameters ;Clears GlobalClass Cache and updates FuncParam cache
		else
			this.ClearCache() ;Clears both FuncParam and GlobalClass Cache
	}
	Purpose(Interface_Purpose){
		Interface_Definition:=AHK.Helpers.Cache_Load(this,{Description:{},Parameters:{}},this.ID) ;Loads Interface_Definition from cache file
		Interface_Definition.Purpose:=Interface_Purpose ;Sets Interface Purpose
		AHK.Helpers.Cache_Save(this,Interface_Definition,this.ID) ;Writes Interface_Definition to cache file
	}
	
	Definition(Display_Msgbox:=1,Function:="",info_type:=0){
		if(!isobject(this.Cache_Interface_Definition)) ;Checks if Interface Definition has been loaded into memory
			Original_Loader:=1, this.Cache_Interface_Definition:=AHK.Helpers.Cache_Load(this,{Description:{},Parameters:{}},this.ID) ;Marks this function call as original definition loader and Loads Interface_Definition from cache file
		if(function == ""){
		
		
		}
		else
		{
		
		
		}
		if(Original_Loader) ;Checks if this function call was original Interface_Definition loader
			this.Cache_Interface_Definition:="" ;Clears Interface_Definition from memory
	}
	Definition_Dump(){
		return AHK.Obj.JSON.Dump(AHK.Helpers.Cache_Load(this,{Description:{},Parameters:{}},this.ID))
	}
}


; Interface_Definition:=AHK.Helpers.Cache_Load(this,{Description:{},Parameters:{}},this.ID) ;Loads Interface_Definition from cache file
; AHK.Helpers.Cache_Save(this,Interface_Definition,this.ID) ;Writes Interface_Definition to cache file