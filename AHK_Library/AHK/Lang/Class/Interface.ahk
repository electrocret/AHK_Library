Class Interface extends AHK.Lang.Class.Meta.Call_Construct {
	Test(){
		static test:=new AHK.Obj.Interface()
		if(test.isNotFinal(A_Thisfunc))
		{
			test.define("blah","blah",1)
			
		}
		
	}
	__New(Interface_Definition:="")	{
		this.Definition_Validate(Interface_Definition)
	}
	Definition_Validate(Import_Definition:="")	{
		if(this.ID is not digit){ ;Ensures Interface has not been finalized
			if(this.RTest is digit)	
			this.RTest++,return 0
			if(Import_Definition == "") ;Checks if a Definition to be imported needs to be validated, if not then validates current Interface_Definition
			Import_Definition:=this.Interface_Definition
			if(!isobject(Import_Definition) and Import_Definition != "") ;Checks if Import_Definition is possibly Object in JSON text format.
			Import_Definition:=AHK.Obj.JSON.Load(Import_Definition) ;Tries converting Interface_Definition from JSON	
			this.Interface_Definition:=isobject(Import_Definition) and isobject(Import_Definition.Func_Desc) and isobject(Import_Definition.Func_Params)?Import_Definition:{Purpose:"Interface Purpose is Undefined",Func_Desc:{},Func_Params:{}}	;Checks if Interface_Definition parameter is valid. If so then sets it to this. if not sets this to default blank Interface_Definition
		}
	}
	isNotFinal(Interface_Reference:="AHK.Lang.Class.Interface"){
		if(this.ID is not digit){ ;Checks if Interface has not been finalized
			if(this.RTest is digit)	{
				if(Interface_Reference != this.RTest_Reference)
				this.RTest++
				return 0
			}
			this.Definition_Validate() ;Ensures Interface has a valid Definition
			if(AHK.Lang.Func.isFunc(Interface_Reference)== 1){ ;Checks if this is a Function interface
				Random, return_verify ;Generates random # to verify Interface_Reference return
				this.RTest:=0 ;Starts Reference Testing
				,this.RTest_Reference:=Interface_Reference 
				,this.RTest_RVerify:=return_verify ;Assigns Random # to Interface
				,this.RTest+=AHK.Lang.Func.Call_Global(Interface_Reference).RTest_RVerify != this.RTest_RVerify ;Verifies Interface_Reference function returns same Interface
				,RTest_Result:=this.RTest == 0 ;Checks if any Unauthorized functions were called during the Reference test
				,this.RTest:="",this.RTest_RVerify:="" ;Reference Test Complete - Clears Values from memory
				,this.Interface_Definition.Ref:=RTest_Result?Interface_Reference "()":this.Interface_Definition.Ref
				,return RTest_Result ;Clears unneeded var, Saves Interface Reference to Definition, and Returns true 
			}
		}
		return 0
	}
	Finalize(make_cache:=0)	{
		static ID_Enumerator:=0
		if(this.ID is not digit){ ;Checks if Interface has not been finalized
			this.Definition_Validate() ;Ensures Interface has a valid Definition
			this.Interface_Definition.Ref:=AHK.Lang.Func.isFunc(this.Interface_Definition.Ref)== 1?this.Interface_Definition.Ref:this.__Class != "AHK.Lang.Class.Interface"?this.__Class:"ERROR - Unable to determine Interface Reference" ;Determines Final Interface Reference
			ID_Enumerator++ ;Enumerates Interface ID
			this.ID:=ID_Enumerator ;Records ID to Interface
			AHK.Helpers.Cache_Save(AHK.Lang.Func.ClassName(A_Thisfunc),this.Interface_Definition,this.ID) ;Writes Interface_Definition to file cache
			this.C_FuncParam:=make_cache?this.Interface_Definition.Func_Params:"" ;Checks if cache should be made
			this.Interface_Definition:="" ;Clears Interface_Definition from memory
		}
	}
	Cache_Clear(){
		this.Cache_Clear_GlobalClass(),	this.Cache_Clear_FuncParam()
	}
	Cache_Clear_GlobalClass(){
		this.C_GlobalClass:=Array()
	}
	Cache_Clear_FuncParam(){
		this.C_FuncParam:="",this.C_FuncParam_Usage:=""
	}
	
	
	isImplemented(byref Obj){
		this.Finalize(1)
		if(!AHK.Obj.Class.isPrototype(Obj)) { ;If Object is not a prototype
			Cache_ID:=StrReplace(AHK.Obj.Class.Global.Name(Obj),".","#") ;Generates Var friendly name for Class's Global Name.
			if(this.C_GlobalClass.hasKey(Cache_ID)) { ;Checks if GlobalClass cache has value for class's implementation of interface in it.
				if(isobject(this.C_FuncParam)){ ;Checks if Function Parameters are in memory
					this.C_FuncParam_Usage-- ;Decrements Function Parameter cache usage
					if(this.C_FuncParam_Usage<1) ;If Function Parameter cache usage hasn't been used 9 times in a row then
					this.Cache_Clear_FuncParam() ;Clear Function Parameter cache from memory
				}
				return this.C_GlobalClass[Cache_ID] ;Returns GlobalClass Cache value
			}
		}
		this.C_FuncParam_Usage:=9 ;Mark Function Parameter cache as being used, and start counter over.
		if(!isobject(this.C_FuncParam)) ;Checks if Function Parameters are in memory
		this.C_FuncParam:=AHK.Helpers.Cache_Load(this,{Description:{},Parameters:{}},this.ID).Parameters ;Loads Function Parameters into memory
		For function, parameters in this.C_FuncParam ;For each function in interface
		If(parameters != isfunc(obj[function]) - 1) ;Check if Object doesn't have function defined or doesn't have specified number of parameters
		not_implemented:=1,break ;Marks not implemented and exits For Loop
		if(Cache_ID != "") ;If Cache ID for GlobalClass Cache has been generated
		this.C_GlobalClass[Cache_ID]:=!not_implemented ;Store implementation result in GlobalClass Cache
		return !not_implemented
	}
	
	
	___New(Interface_Definition:="",Make_C_FuncParam:=1){
		static ID_Enumerator:=0 ;Defines ID ENumerator to ensure each Interface has its own ID.
		ID_Enumerator++ ;Enumerates Interface ID
		this.ID:=ID_Enumerator ;Records ID to Interface
		this.C_GlobalClass:=Array() ;Defines GlobalClass Implementation cache
		if(!isobject(Interface_Definition) and Interface_Definition != "") ;Checks if Interface_Definition is possibly Object in text format.
		Interface_Definition:=AHK.Obj.JSON.Load(Interface_Definition) ;Tries converting Interface_Definition from JSON
		if(isobject(Interface_Definition) and isobject(Interface_Definition.Description) and isobject(Interface_Definition.Parameters)) ;Checks Interface_Definition validity
		this.C_FuncParam:=Make_C_FuncParam?Interface_Definition.Parameters:"" ;Interface_Definition is valid. Keeps Function Parameters cached in memory for initial implementation testing.
		else
		Interface_Definition:={Purpose:"Undefined",Description:{},Parameters:{}}	;Sets Interface_Definition to default
		AHK.Helpers.Cache_Save(this,Interface_Definition,this.ID) ;Writes Interface_Definition to file cache
	}
	
	Define(byref Function_Name,byref Description,Parameters:=0,Make_C_FuncParam:=1){
		Interface_Definition:=AHK.Helpers.Cache_Load(this,{Description:{},Parameters:{}},this.ID) ;Loads Interface_Definition from cache file
		Interface_Definition.Parameters[Function_Name]:=Parameters ;Sets expected Parameters for function
		Interface_Definition.Description[Function_Name]:=Description ;Sets Function description
		AHK.Helpers.Cache_Save(this,Interface_Definition,this.ID) ;Writes Interface_Definition to cache file
		if(Make_C_FuncParam) ;Checks if FuncParam cache should be created
		this.Cache_Clear_GlobalClass(),this.C_FuncParam:=Interface_Definition.Parameters ;Clears GlobalClass Cache and updates FuncParam cache
		else
		this.Cache_Clear() ;Clears both FuncParam and GlobalClass Cache
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