Class Interface extends AHK.Lang.Class.Meta.Call_Construct {
	__New(Interface_Definition:="")	{
		this.Definition_Validate(Interface_Definition)
	}
	isImplemented(byref Obj){
		static ID_Enumerator:=0
		if(this.isNotFinal()) ;Checks if Interface is not final, and finalizes it
		{
			this.Definition_Validate() ;Ensures Interface has valid Definition
			,this.Define_Ref(this) ;Defines Interface Reference for Interface Classes (does nothing for Function Interfaces)
			,this.Define_Ref(this.Interface_Definition.Ref) ;Verifies Interface Reference is valid
			if(this.Interface_Definition.Ref_Type == "") ;Stops finalizing because Interface Reference is invalid
			return 0
			ID_Enumerator++ ;Enumerates Interface ID
			,this.ID:=ID_Enumerator ;Records ID to Interface
			,AHK.Helpers.Cache_Save(AHK.Lang.Func.ClassName(A_Thisfunc),this.Interface_Definition,this.ID) ;Writes Interface_Definition to file cache
			,this.C_FuncParam:=this.Interface_Definition.Func_Params
			,this.C_FuncParamBR:=this.Interface_Definition.Func_Params_Byref
			,this.C_FuncParam_Usage:=9
		}
		
		if(!AHK.Obj.Class.isPrototype(Obj)) { ;If Object is not a prototype then check Cache
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
		if(!isobject(this.C_FuncParam)){ ;If Function Cache is not in memory
			Interface_Definition:=AHK.Helpers.Cache_Load(this,{Func_Desc:{},Func_Params:{},Func_Params_Byref:{},Ref:"{Reference is Undefined}",Purpose:"{Purpose is Undefined}"},this.ID) ;Loads Interface Definition into memory
			this.C_FuncParam:=Interface_Definition.Func_Params ;Grabs Function Parameters from Definition
			this.C_FuncParamBR:=Interface_Definition.Func_Params_Byref ;Grabs Function byref parameters from definition
		}
		For function, parameters in this.C_FuncParam ;For each function in interface
		{
			if(!AHK.Lang.Func.willCall(obj[function],Parameters)) ;Check if Function will accept specified # of parameters
			not_implemented:=1,break ;Marks not implemented and exits For Loop
			For i,Param_Index in this.C_FuncParamBR[function] ;Checks if specified parameters are byref
			if(!AHK.Lang.Func.isByref(obj[function],Param_Index))
			not_implemented:=1,break ;Marks not implemented and exits For Loop
			if(not_implemented)
			break
		}
		if(Cache_ID != "") ;If Cache ID for GlobalClass Cache has been generated
		this.C_GlobalClass[Cache_ID]:=!not_implemented ;Store implementation result in GlobalClass Cache
		return !not_implemented
	}
	Definition_Validate(byref Import_Definition:="")	{
		if(this.isNotFinal()){ ;Ensures Interface has not been finalized
			if(Import_Definition == "") ;Checks if a Definition to be imported needs to be validated, if not then validates current Interface_Definition
			Import_Definition:=this.Interface_Definition
			if(!isobject(Import_Definition) and Import_Definition != "") ;Checks if Import_Definition is possibly Object in JSON text format.
			Import_Definition:=AHK.Obj.JSON.Load(Import_Definition) ;Tries converting Interface_Definition from JSON	
			this.Interface_Definition:=isobject(Import_Definition) and isobject(Import_Definition.Func_Desc) and isobject(Import_Definition.Func_Params)and isobject(Import_Definition.Func_Params_Byref)?Import_Definition:{Func_Desc:{},Func_Params:{},Func_Params_Byref:{},Ref:"{Reference is Undefined}",Purpose:"{Purpose is Undefined}"}	;Checks if Interface_Definition parameter is valid. If so then sets it to this. if not sets this to default blank Interface_Definition
		}
	}
	isNotFinal(){
		return this.ID is not digit or this.RTest
	}
	Define_Ref(byref Interface_Reference){
		if(this.isNotFinal()) { ;ensures Interface is not finalized
			if(AHK.Lang.Class.Global.Name(Interface_Reference) != "AHK.Lang.Class.Interface") { ;Ensures Reference isn't global interface class
				this.Definition_Validate() ;Ensures Interface has a valid Definition
				Random, ref_verify ;Generates random # to verify Interface_Reference return
				this.RTest_RVerify:=ref_verify ;Assigns Random # to Interface
				,this.RTest:=1 ;Starts Reference Testing
				if(AHK.Lang.Func.isFunc(Interface_Reference) == 1) { ;Checks if this is a Function interface
					ref_type:=2 ;Marks Ref type as function
					,RTest_Result:=AHK.Lang.Func.Call_Global(Interface_Reference).RTest_RVerify == this.RTest_RVerify ;Verifies Interface_Reference func returns same Interface
					,Ref:=AHK.Lang.Func.Name(Interface_Reference) ;Gets plain text name of function
				}
				else if(isobject(AHK.Lang.Class.Global(Interface_Reference))) { ;Checks if this is a Class Interface
					ref_type:=1 ;Marks Ref type as Class
					,RTest_Result:=AHK.Lang.Class.Global(Interface_Reference).RTest_RVerify == this.RTest_RVerify ;Verifies Interface_Reference is the same
					,Ref:=AHK.Lang.Class.Global.Name(Interface_Reference) ;Gets plain text name of Class
				}
				this.RTest:="",this.RTest_RVerify:="" ;Reference Test Complete - Clears Values from memory
				if(RTest_Result) { ;Checks if reference test was passed
					this.Interface_Definition.Ref:=Ref ;Marks Interface_Definition with new Reference
					this.Interface_Definition.Ref_Type:=Ref_Type ;Marks Interface_Definition with new Reference type
				}
			}
			if(this.Interface_Definition.Ref_Type == ""){ ;Checks if reference has a valid value
				this.Interface_Definition.Ref:="{Reference is Undefined}" ;Marks Interface_Definition reference as undefined
				this.Interface_Definition.Ref_Type:=""
			}
		}
		return RTest_Result
		
	}
	Define_Func(byref Name,byref Description,byref Parameters:=0,byref Params_Byref:="")	{
		if(this.isNotFinal()){ ;Checks if Interface has not been finalized
			this.Definition_Validate() ;Ensures Interface has a valid Definition
			this.Interface_Definition.Func_Desc[Name]:=isobject(Description)?AHK.obj.JSON.Dump(Description):Description
			this.Interface_Definition.Func_Params[Name]:=Parameters is digit?Parameters:0
			Params_BR:=!isobject(Params_Byref)?StrSplit(Params_Byref ,"," A_SPace A_Tab):Params_Byref
			For i,k in Params_BR
			if k is not digit
			Params_BR[i]:=""
			this.Interface_Definition.Func_Params_Byref[Name]:=Params_BR
		}
	}
	Define_Purpose(byref Interface_Purpose)	{
		if(this.isNotFinal()){ ;Checks if Interface has not been finalized
			this.Definition_Validate() ;Ensures Interface has a valid Definition
			this.Interface_Definition.Purpose:=Interface_Purpose
		}
	}
	Cache_Clear(){
		this.Cache_Clear_GlobalClass(),	this.Cache_Clear_FuncParam()
	}
	Cache_Clear_GlobalClass(){
		this.C_GlobalClass:=Array()
	}
	Cache_Clear_FuncParam(){
		this.C_FuncParamBR:="",this.C_FuncParam:="",this.C_FuncParam_Usage:=""
	}
	Definition_Dump(){
		return AHK.Obj.JSON.Dump(this.Interface_Definition)
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
	
}


; Interface_Definition:=AHK.Helpers.Cache_Load(this,{Description:{},Parameters:{}},this.ID) ;Loads Interface_Definition from cache file
; AHK.Helpers.Cache_Save(this,Interface_Definition,this.ID) ;Writes Interface_Definition to cache file				