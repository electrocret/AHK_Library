/*
	TODO:
	DOCUMENTATION!!!!!!!!
	
	
	Interface_Definition:
	
	Documentation {
	Desc: Interface's Documentation/Purpose/Usage
	Name:Interface's Global Reference
	Func{
	%function_Name%
	{
	Desc:Function Documentation
	Param_names: Names of parameters in function (formatted like how they'd be in a script)
	}
	}
	}
	
	
	Definition {
	Inherit
	Func{
	%function_Name% (Functions w/o parameters have a non-object value)
	{
	Param_Cnt: # of parameters required for function to be called
	Param_Ref: Linear array of whether parameter should be local/byref. (1=Local, 2=Byref, 0=Don't care)
	variadic: boolean on whether function is variadic
	}
	}
	
	}
	
	Impl_Issue {
	Inherit: Inherit Impl_Issues
	func{
	%function_Name% 
	[ ;Linear array of issues
	Issue types:
	-1 -Function does not exist
	0 -Expected no Parameters
	1 -Accepted parameter count is wrong
	2 -Expected Variadic function
	3.x -Expected Param to be byref (x=problem param #)
	4.x -Expected Param to not be Byref (x=problem param #)
	]
	
	
	
	}
	
	}
	
	
	AHK.Helpers.Cache_Obj_Lock(this,"Definition",A_thisfunc,this.ID *2) ;Locks Definition
	AHK.Helpers.Cache_Obj_Unlock(this,"Definition",A_thisfunc) ;Unlocks Definition
	
	
	AHK.Helpers.Cache_Obj_Lock(this,"Documentation",A_thisfunc,this.ID *2-1) ;Locks Documentation
	AHK.Helpers.Cache_Obj_Unlock(this,"Documentation",A_thisfunc) ;Unlocks Documentation
	
	
	
	
*/


Class Interface extends AHK.Lang.Class.Meta.Call_Construct {
	__New(Interface_Dump:="")	{
		this.Validate(Interface_Dump)
	}
	Validate(Import_Dump:="") {
		static testing_import_name:=0
		if(this.isNotFinal(1) and !testing_import_name){ ;Is Interface Not Final and we're not testing an imported interface name?
			if(Import_Dump == "") { ;Was Import_Dump not provided?
				Import_Dump:=this.Documentation == "" and this.Definition == ""?this.Interface_Import:{Documentation:this.Documentation,Definition:this.Definition},this.Interface_Import:="" ;Clears Interface_Import for memory.
				}
			if(!isobject(Import_Dump) and Import_Dump != "") ;Was Import_Dump provided but is not an object?
			Import_Dump:=AHK.Obj.JSON.Load(Import_Dump) ;Try to convert Import_Dump from JSON
			if(!isobject(Import_Dump.Definition) and Import_Dump.hasKey("Definition")) ;Does Import_Dump have a Definition Value but it's not an object?
			Import_Dump.Definition:=AHK.Obj.JSON.Load(Import_Dump.Definition) ;Try converting Import_Dump.Definition from JSON	
			if(!isobject(Import_Dump.Documentation) and Import_Dump.hasKey("Documentation")) ;Does Import_Dump have a Documentation Value but it's not an object?
			Import_Dump.Documentation:=AHK.Obj.JSON.Load(Import_Dump.Documentation) ;Try converting Import_Dump.Documentation from JSON	
			If(isobject(Import_Dump.Documentation) and isObject(Import_Dump.Definition) and isobject(Import_Dump.Documentation.Func) and isobject(Import_Dump.Definition.Func) and (this.isInterface(Import_Dump.Definition.Inherit) or Import_Dump.Definition.Inherit == ""))		{ ;Does Import_Dump have everything to be a valid interface definition/documentation?
				if(This.Documentation.Name == "" and Import_Dump.Documentation.Name != "") ;Does Documentation not have an interface name defined, but Import does?
				{
					testing_import_name:=1 ;Enable Testing Import name
					try 
					this.Define_Name(Import_Dump.Documentation.Name) ;Try Defining Import name as interface name
					catch e
					Import_Dump.Documentation.Name:="" ;Defining Import name as interface name was unsuccessful. 
					testing_import_name:=0 ;Disable Testing Import name
				}
				else
				Import_Dump.Documentation.Name:=This.Documentation.Name ;Copy over Interface name to Import.
				this.Definition:=Import_Dump.Definition ;Copies Definition
				,this.Documentation:=Import_Dump.Documentation ;Copies Documentation
			}
			else	{ ;Invalid Import_Dump so sets Definition/Documentation to default
				this.Definition:={Func:{},Cache_Usage:9}
				,this.Documentation:={Func:{}}
			}
		}
	}
	isNotFinal(byref throw_error:=0){
		if(throw_error and AHK.lang.Logic.isType.digit(this.ID) and this.ID != "") 
		throw Exception("Attempting to alter definition on finalized Interface -" this.ID,this.Doc_Name())
		return this.Self_Temp_Finalize == "" and !(AHK.lang.Logic.isType.digit(this.ID) and this.ID != "")
	}
	
	isInterface(byref Interface_Name,byref Mode:=0){
		if(Interface_Name != "AHK.Lang.Class.Interface") {
			if(!isobject(Interface_Name) and Instr(Interface_Name,"()") == (StrLen(Interface_Name) - 1)) ;Checks for Func Interface Name
			Interface_Type:=2,this.Self_Temp_Finalize:=1,Interface:=AHK.Lang.Func.Global_Call(Substr(Interface_Name,1,StrLen(Interface_Name) - 2)),this.Self_Temp_Finalize:=""
			else if(AHK.Lang.Func.isFunc(Interface_Name) == 1) ;Checks Func Interface Ref
			Interface_Type:=2,this.Self_Temp_Finalize:=1,Interface:=AHK.Lang.Func.Global_Call(Interface_Name),this.Self_Temp_Finalize:=""
			else	;Checks for Class Interface Ref
			Interface_Type:=1,Interface:=AHK.Lang.Class.Global(Interface_Name)
		}
		return !isobject(Interface) or !AHK.lang.Class.Extends(Interface,"Ahk.Lang.Class.Interface")?0:Mode?Interface:Interface_Type
	}
	Name_Generate(byref Interface_Name,byref Interface_Type:="")	{
		return (Interface_Type ?Interface_Type:this.isInterface(Interface_Name)) == 1?AHK.Lang.Class.Global.Name(Interface_Name) :Instr(Interface_Name,"()") == StrLen(Interface_Name) - 1?Interface_Name:AHK.Lang.Func.Name(Interface_Name) "()"
	}
	Finalize(){
		static ID_Enumerator:=0
		if(this.isNotFinal()) {
			this.Validate() ;Ensures Interface has valid Definition/Documentation
			,this.Define_Name(this) ;Defines Interface Name for Interface Classes (does nothing for Function Interfaces)
			,this.Define_Name(this.Documentation.Name) ;Verifies Interface Name returns interface
			if(!this.isInterface(this.Documentation.Name)) ;Verifies Documentation still has valid Interface Name
			throw Exception("Attempting to finalize Interface without a valid Name. '" this.Documentation.Name "'")
			this.Definition.Cache_Usage:=AHK.lang.logic.isType.Digit(this.Definition.Cache_Usage)?this.Definition.Cache_Usage:9 ;Ensures Cache_Usage is valid ( "" - Always Keep Definition in Memory, 0-Never keep definition in memory #>0 - Cache hasn't been used that many times during Implement test the remove from mem.
			,ID_Enumerator++ ;Enumerates new Interface ID
			,This.ID:=ID_Enumerator ;Assigns New Interface ID to this Interface
			,AHK.Helpers.Cache_Save(AHK.Lang.Func.ClassName(A_Thisfunc),this.Documentation,this.ID * 2 - 1) ;Writes Interface Documentation to Cache file
			,AHK.Helpers.Cache_Save(AHK.Lang.Func.ClassName(A_Thisfunc),this.Definition,this.ID * 2) ;Writes Interface Definition  to cache file
			,this.GlobalClass_Cache:=Array() ;Creates global class cache
			,this.Documentation:=""
			if(this.Definition.Cache_Usage == 0)
			this.Definition:=""
			else
			this.Definition_CacheLock:=Array()
			
		}
	}
	
	;### Interface Implementation testing functions section
	Implement_Test(byref Objs*){
		static Inherit_lp_check:=Array()
		Output:=Array() ;Stores Final results
		if(!Inherit_lp_check.hasKey( "I" this.ID)){ ;Inherit Loop Prevention check
			this.Finalize() ;Finalize Interface if it isn't already.
			,Cache_Names:=Array()
			,NeedTesting:=Array() ;Temp array for objects whose implementation results aren't cached
			For i,Obj in Objs
			{
				if(isobject(Obj)){ ;Is Obj actually an object?
					if(!AHK.lang.Class.isPrototype(Obj)) { ;Is object not a prototype ?
						Cache_Names[i]:=StrReplace(AHK.lang.Class.Global.Name(Obj),".","#") ;Generates Cache friendly name for Class's Global Name.
						if(this.GlobalClass_Cache.hasKey(Cache_Names[i])) { ;is Class's Cache friendly name in Cache?
							if(isobject(this.GlobalClass_Cache[Cache_Names[i]]))
							Output[i]:=this.GlobalClass_Cache[Cache_Names[i]] ;Gets Cached result for Class
							continue
						}
					}
					NeedTesting[i]:=Obj
				}
				else ;Adds Non-Object Error to Output
				Output[i]:={Class:"{Non-Object}",Value:Obj}
			}
			if(NeedTesting.MinIndex() != ""){ ;Were there misses in the GlobalClass_Cache?
				AHK.Helpers.Cache_Obj_Lock(this,"Definition",A_thisfunc,this.ID *2) ;Locks Definition
				this.DefCache_Usage:=This.Definition.Cache_Usage ;Marks Cache miss
				if(this.Definition.Inherit != ""){ ;is there an Inherited Interface?
					Inherit_lp_check["I" this.ID]:=1 ;Enables Inherit Loop Prevention
					Inherit_Issues:=this.isInterface(this.Definition.Inherit,1).Implement_Test(NeedTesting*) ;Gets Inherited Interface results
					,Inherit_lp_check.Remove("I" this.ID) ;Disables Inherit Loop Prevention
				}
				Func_Impl_Issues:=Array()
				PerFunc_Impl_Issues:=Array()
				For i,Obj in NeedTesting
				{
					if(this.GlobalClass_Cache.hasKey(Cache_Names[i])){  ;is Class's Cache friendly name in Cache? (recheck)
						if(isobject(this.GlobalClass_Cache[Cache_Names[i]]))
						Output[i]:=this.GlobalClass_Cache[Cache_Names[i]] ;Gets Cached result for Class
					}
					else
					{
						For func_name,func_def in this.Definition.Func ;For each function definition
						{
							if(!AHK.Lang.Func.isfunc(obj[func_name])) ;Function exists?
							PerFunc_Impl_Issues.push(-1) ;Error - Function does not exist
							else if(isobject(func_def)) { ;Function Definition defines parameters
								if(!AHK.Lang.Func.willCall(obj[func_name],func_def.param_cnt)) ;Ensures Obj function will accept specified # of parameters
								PerFunc_Impl_Issues.push(1) ;Error - Will not accepts specified # of parameters
								else if(isobject(func_def.Param_Ref)) ;Checks if Function Definition specifies Parameter's reference
								For p_index, Ref in func_def.Param_Ref
								if(Ref) { ;is Param Ref Specified?
									isBR:=AHK.Lang.Func.isByref(obj[func_name],p_Index) ;Get byref for param in Obj function
									if((isBR and Ref == 2) or (!isBR and Ref == 1)) ;Does Reference match what's specified in Param_Ref?
									PerFunc_Impl_Issues.push( (isBR?4:3) "." p_index) ;Error - Param reference doesn't match what's specified
								}
								if(func_def.variadic and !AHK.lang.Func.isVariadic(obj[func_name])) ;Ensures Obj function is variadic
								PerFunc_Impl_Issues.push(2) ;Error - Func is not variadic
							}
							else if(AHK.lang.func.MinParams(obj[func_name])!=0) ;Function Definition defines no parameters - Ensures function has no parameters
							PerFunc_Impl_Issues.push(0) ;Error - Expecting no Parameters
							if(PerFunc_Impl_Issues.length())	{ ;Was the function not implemented properly?
								if(!isobject(Func_Impl_Issues[i]))
								Func_Impl_Issues[i]:=Array()
								Func_Impl_Issues[i][func_name]:=PerFunc_Impl_Issues ;Marks Function in implementation issues
								,PerFunc_Impl_Issues:=Array() ;Creates blank PerFunc_Impl_Issues array
							}
						}
						if(isobject(Func_Impl_Issues[i]) or isObject(Inherit_Issues[i])) { ;Are there issues with Implementation?
							Impl_Issues:=Array()
							Impl_Issues.func:=Func_Impl_Issues[i]
							Impl_Issues.Inherit:=Inherit_Issues[i]
							Impl_Issues.Class:=AHK.lang.class.isPrototype(Obj)?"{Prototype Object}":AHK.lang.class.Global.Name(Obj)
						}
						else
						Impl_Issues:="" ;Clears Impl_Issues for memory savings
						if(Cache_Names.hasKey(i)) ;Is there a cache ID?
						this.GlobalClass_Cache[Cache_Names[i]]:=Impl_Issues ;Caches Implementation issues
						if(isobject(Impl_Issues))
						Output[i]:=Impl_Issues ;Stores Impl_Issues to Output
					}
				}
			}
			if(this.DefCache_Usage != "")	{
				if(this.DefCache_Usage < 1) ;has cache been hit a defined amount of times?
				this.DefCache_Usage:="",AHK.Helpers.Cache_Obj_Unlock(this,"Definition",A_thisfunc) ;Unlocks Definition
				else
				this.DefCache_Usage-- ;Decrements Definition usage
			}
		}
		return output
	}
	Implement_Exception(byref Impl_Issue,byref Obj)	{
		AHK.Helpers.Cache_Obj_Lock(this,"Documentation",A_thisfunc,this.ID *2-1) ;Locks Documentation
		name:=this.Doc_Name()
		msg:=this.Implement_Exception_Msg(Impl_Issue,Obj)
		AHK.Helpers.Cache_Obj_Unlock(this,"Documentation",A_thisfunc) ;Unlocks Documentation
		throw Exception(msg,name)
	}
	Implement_Exception_Msg(byref Impl_Issue,byref Obj,byref Inherit_msg:=0){
		AHK.Helpers.Cache_Obj_Lock(this,"Documentation",A_thisfunc,this.ID *2-1) ;Locks Documentation
		if(Impl_Issue.Class == "{Non-Object}")	
		msg:= "Interface '"  this.Doc_Name()  "' received Non-Object: '" Obj "'" 
		else
		{
			msg:=!Inherit_msg?"Functions for Interface '" this.Doc_Name() "' are not implemented by '" Impl_Issue.Class "':":isobject(Impl_Issue.func)?"Functions for Inherited Interface '" this.Doc_Name() "' are not implemented by '" Impl_Issue.Class "':":"Inherits Interface '" this.Doc_Inherit() "'"
			if(isobject(Impl_Issue.func)) {
				For func_name, func_issues in Impl_Issue.func
				{
					func_documentation:=this.Documentation.func[func_name]
					msg.="`n " this.Doc_Func_Call(func_name)
					For i,func_issue in func_issues
					msg.=(i==1?"  -":", ") this.Implement_Exception_Func_Msg(func_name,func_issue)
				}
			}
			if(isobject(Impl_Issue.Inherit)) ;Were there issues with inherited Interface?				
			msg.=(isobject(Impl_Issue.func)?"`n`n":"`n") this.isInterface(this.Doc_Inherit(),1).Implement_Exception_Msg(Impl_Issue.Inherit,Obj,1)
		}
		AHK.Helpers.Cache_Obj_Unlock(this,"Documentation",A_thisfunc) ;Unlocks Documentation
		return msg
	}
	Implement_Exception_Func_Msg(byref func_name,byref Issue_Type)	{
		if(Issue_Type == -1)
		return "Does not exist"
		if(Issue_Type == 0)
		return "No required parameters expected"
		if(Issue_Type == 1){
			AHK.Helpers.Cache_Obj_Lock(this,"Definition",A_thisfunc,this.ID *2) ;Locks Definition
			msg:="Expected to accept " this.Definition.func[func_name]["param_cnt"] " parameter/s"
			AHK.Helpers.Cache_Obj_Unlock(this,"Definition",A_thisfunc) ;Unlocks Definition
			return msg
		}
		if(Issue_Type == 2)
		return "Variadic Expected"
		if(InStr(Issue_Type,"3.") == 1)
		return "Expecting Parameter " substr(Issue_Type,3) " to be Byref"
		if(InStr(Issue_Type,"4.") == 1)
		return "Expecting Parameter " substr(Issue_Type,3) " to not be Byref"
		return "Undefined Issue Type: " Issue_Type
	}
	isImplemented(byref Objs*){
		Test_Result:=this.Implement_Test(Objs*)
		if(isObject(Test_Result[Test_Result.MinIndex()])) { ;Are there any implementation issues?
			this.Implement_Exception(Test_Result[Test_Result.MinIndex()],Objs[Test_Result.MinIndex()])
			return 0
		}
		return 1
	}
	Filter(byref Arrs*){
		Empty:=0
		For ai,Arr in Arrs
		{
			for index,impl_isue in this.Implement_Test(Arr*)
			Arrs[ai].remove(index)
			Empty:=Empty or Arrs[ai].MinIndex() == ""
		}
		return !Empty
	}
	
	
	;Defining Functions section
	Define_Name(byref Interface_Name){
		if(this.isNotFinal(1) and AHK.Lang.Class.Global.Name(Interface_Name) != "AHK.Lang.Class.Interface") { ;is Interface Not finalized, and New name isn't Global interface class?
			this.Validate() ;Ensures this Interface has a valid Definition/Documentation
			Ref_Type:=this.isInterface(Interface_Name) ;Ensures Interface reference returns an Interface
			if(Ref_Type)	{
				I_Name:=this.Name_Generate(Interface_Name,Ref_Type) ;Generates Interface Name.
				Random, ref_verify ;Generates random # to verify Interface reference return
				,this.ref_verify:=ref_verify ;Assigns Random # to Interface
				,Ref_Result:=this.isInterface(I_Name,1).ref_verify == this.ref_verify ;Checks if Randomly assigned # is on Referenced Interface Name
				,this.ref_verify:="" ;Removes Random #
				if(Ref_Result) ;Checks if Reference test passed
				this.Documentation.Name:=I_Name ;Stores Reference Name for later lookup.
				else
				throw Exception("Attempting to define Interface name to a reference that does not return the Interface.  Reference: """ Interface_Name """")
				
			}
			else
			throw Exception("Attempting to define Interface name with invalid reference. Reference: """ Interface_Name """")
		}
		return Ref_Result
	}
	Define_Func(byref Func_Name,byref Func_Desc,byref Param_Count:=0,byref Param_Names:="",byref Byref_param_Indexs:="",byref Local_param_Indexs:="",Byref isVariadic:=0)	{
		if(this.isNotFinal(1)){ ;Checks if Interface has not been finalized and Function name is valid
			if(!AHK.lang.Var.isValidName(Func_Name))
			throw Exception("Attempting to define Interface function with invalid name.`nInvalid Name: " Func_Name,this.Doc_Name())
			if(Param_Count is not digit)
			throw Exception("Attempting to define Interface function with invalid Parameter count. '" Func_Name "'",this.Doc_Name())
			this.Validate() ;Ensures Interface has a valid Definition
			,Func_Doc:=Array()
			if(Func_Desc != "")
			Func_Doc.desc:=func_desc
			if(Param_Count > 0)	{
				p_Names:=Array() ;Temp array for Parameter name doc
				,p_Ref:=Array() ;Array for specifying parameter references
				Loop, %Param_Count% ;Builds Parameter name doc array with dummy names and puts default value in param reference array
				p_Names.push("Param" A_Index),p_Ref.push("0")
				Func_Def:={Param_Cnt:Param_Count,Param_Ref:p_Ref,Variadic:isVariadic?1:0} ;Builds Default Function Definition w/ parameters
				skip:=0
				Loop,Parse,Param_Names,CSV ;Parses through Param_Names and replaces dummy names in param doc array
				{
					if(A_Index - skip > Param_Count)
					break
					if(AHK.lang.Var.isValidName(A_LoopField))
					p_Names[A_Index - skip]:=A_LoopField
					else 
					skip++
				}
				Loop,Parse,Local_param_Indexs,CSV ;Parses Local_param_Indexs and ensures they're valid then marks them in function definition
				if(A_LoopField is digit and A_LoopField <= Param_Count) ;Ensures index is valid
				Func_Def.Param_Ref[A_LoopField]:=2, Ref_Specified:=1
				Loop,Parse,Byref_param_Indexs,CSV ;Parses Byref_param_Indexs and ensures they're valid then marks them in param doc array and in function definition
				if(A_LoopField is digit and A_LoopField <= Param_Count) { ;Ensures index is valid
					Func_Def.Param_Ref[A_LoopField]:=1, Ref_Specified:=1
					, P_Names[A_LoopField]:="Byref " P_Names[A_LoopField] ;Marks Parameter Doc Name as byref
				}
				if(!Ref_Specified) ;No SPecific parameter references were made so removing from definition
				Func_Def.Param_Ref:=""
				if(isVariadic) ;If Function is variadic Mark it in Param Doc Array
				P_Names[P_Names.MaxIndex()].="*"
				For i,param in P_Names ;Formats Param name doc array into a string
				Func_Doc.Param_Names.=i==1?param:" ," param
			}
			else
			Func_Def:=1
			this.Documentation.Func[Func_Name]:=Func_Doc
			,this.Definition.Func[Func_Name]:=Func_Def
		}
	}
	Define_Desc(byref Interface_Description)	{
		if(this.isNotFinal(1)){ ;Checks if Interface has not been finalized
			this.Validate() ;Ensures Interface has a valid Definition/Documentation
			,this.Documentation.Desc:=Interface_Description
		}
	}
	Define_Inherit(byref Interface_Name)	{
		if(this.isNotFinal(1)) { ;Checks if this Interface has not been finalized
			if(this.isInterface(Interface_Name)) ;Checks if Interface name is interface
			this.Definition.Inherit:=this.Name_Generate(Interface_Name)
			else
			throw Exception("Attempting to Inherit Interface that cannot be found. `nUnable to find: '" this.Name_Generate(Interface_Name) "'",this.Doc_Name())  
		}
	}
	;Documentation retrieval functions section
	Doc_Func(byref function_name){
		return this.Doc_Func_Call(function_name) "`n Description: " this.Doc_Func_desc(function_name)
	}
	Doc_Func_desc(byref function_name){
		AHK.Helpers.Cache_Obj_Lock(this,"Documentation",A_thisfunc,this.ID *2-1) ;Locks Documentation
		if(this.Documentation.func.hasKey(function_name))
		{
			func_def:=this.Documentation.func[function_name]
			if(func_def.haskey("desc"))
			Output:=func_def.desc
			else
			Output:="Description for '" function_name "' is undefined."
		}
		else
		Output:="Function not found: " function_name
		AHK.Helpers.Cache_Obj_Unlock(this,"Documentation",A_thisfunc) ;Unlocks Documentation
		return Output
	}
	Doc_Func_Call(byref function_name)	{
		AHK.Helpers.Cache_Obj_Lock(this,"Documentation",A_thisfunc,this.ID *2-1) ;Locks Documentation
		func_doc:=this.Documentation.func[function_name]
		output:=this.Documentation.func.hasKey(function_name)?function_name "(" func_doc.Param_Names ")":"Function not found: " function_name
		AHK.Helpers.Cache_Obj_Unlock(this,"Documentation",A_thisfunc) ;Unlocks Documentation
		return output
	}
	Doc_List_Func(){
		AHK.Helpers.Cache_Obj_Lock(this,"Documentation",A_thisfunc,this.ID *2-1) ;Locks Documentation
		Output:=Array()
		For func_name,def in this.Documentation.func
		Output.push(func_name)
		AHK.Helpers.Cache_Obj_Unlock(this,"Documentation",A_thisfunc) ;Unlocks Documentation
		return Output
	}
	Doc_Desc(){
		AHK.Helpers.Cache_Obj_Lock(this,"Documentation",A_thisfunc,this.ID *2-1) ;Locks Documentation
		output:=this.Documentation.haskey("desc")?this.Documentation.desc:"Interface Documentation is undefined"
		AHK.Helpers.Cache_Obj_Unlock(this,"Documentation",A_thisfunc) ;Unlocks Documentation
		return output
	}
	Doc_Name(){
		AHK.Helpers.Cache_Obj_Lock(this,"Documentation",A_thisfunc,this.ID *2-1) ;Locks Documentation
		output:=this.Documentation.haskey("name")?this.Documentation.name:"Interface Name is undefined"
		AHK.Helpers.Cache_Obj_Unlock(this,"Documentation",A_thisfunc) ;Unlocks Documentation
		return output
	}
	Doc_Inherit(){
		AHK.Helpers.Cache_Obj_Lock(this,"Definition",A_thisfunc,this.ID *2) ;Locks Definition
		output:=this.Definition.Inherit
		AHK.Helpers.Cache_Obj_Unlock(this,"Definition",A_thisfunc) ;Unlocks Definition
		return output
	}
	Doc(extended:=0){
		AHK.Helpers.Cache_Obj_Lock(this,"Documentation",A_thisfunc,this.ID *2-1) ;Locks Documentation
		Inherit:=this.Doc_Inherit()
		Output:="Interface Name: " this.Doc_Name() (Inherit ==""?"":"`nInherits Interface: " this.Doc_Inherit()) "`nInterface Description: " this.Doc_Desc() "`nFunctions: "
		For i,func_name in this.Doc_List_Func()
		Output.="`n" this.Doc_Func(func_name)
		AHK.Helpers.Cache_Obj_Unlock(this,"Documentation",A_thisfunc) ;Unlocks Documentation
		if(extended){
			inherit_lp_Prevention:={"I" this.ID:1}
			while(Inherit != "")
			{
				Interface:=this.isInterface(Inherit,1)
				if(!inherit_lp_Prevention.haskey("I" Interface.ID)){
					Interface.Finalize()
					inherit_lp_Prevention["I" Interface.ID]:=1
					Output.="`n*Inherited from " Inherit ":"
					AHK.Helpers.Cache_Obj_Lock(Interface,"Documentation",A_thisfunc,Interface.ID *2-1) ;Locks Documentation
					For i,func_name in Interface.Doc_List_Func()
					Output.="`n" Interface.Doc_Func(func_name)
					Inherit:=Interface.Doc_Inherit()
					AHK.Helpers.Cache_Obj_Unlock(Interface,"Documentation",A_thisfunc) ;Unlocks Documentation
				}
				else
				Inherit:=""
			}
		}
		return output
	}
	Dump(){
		AHK.Helpers.Cache_Obj_Lock(this,"Documentation",A_thisfunc,this.ID *2-1) ;Locks Documentation
		AHK.Helpers.Cache_Obj_Lock(this,"Definition",A_thisfunc,this.ID *2) ;Locks Definition
		Output:=AHK.Obj.JSON.Dump({Definition:this.Definition,Documentation:this.Documentation})
		AHK.Helpers.Cache_Obj_Unlock(this,"Documentation",A_thisfunc) ;Unlocks Documentation
		AHK.Helpers.Cache_Obj_Unlock(this,"Definition",A_thisfunc) ;Unlocks Definition
		return Output
	}
	
}


; Interface_Definition:=AHK.Helpers.Cache_Load(this,{Description:{},Parameters:{}},this.ID) ;Loads Interface_Definition from cache file
; AHK.Helpers.Cache_Save(this,Interface_Definition,this.ID) ;Writes Interface_Definition to cache file																									