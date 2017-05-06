	Class Class{
		;#Include %A_Scriptdir%\Library\Serial.ahk
		/*
			Method - Base(obj) 
			description - Gets Base object
			Return - Returns inputted object's base object
			Parameters :
			obj - The Object to get the base of.
		*/
		Base(obj)		{
			return isfunc(obj.__ID)?obj.__ID(-3):obj.base
		}
		/*
			Method - Base_Root(obj) 
			description - Gets the Lowest base object
			Return - Returns the Inputted object's lowest base object
			Parameters :
			obj - The Object to get the lowest base of.
		*/
		Base_Root(obj){
			static cache:=Array()
			vname:=this.Tree_VName(obj)
			if(!isobject(cache[vname])) {
				bbase:=this.Base(obj)
				while(isobject(bbase))	{
					obj:=bbase
					bbase:=this.Base(obj)
				}
				cache[vname]:=obj
			}
			return cache[vname]
		}
		/*
			Method - Base_isRoot(obj) 
			description - Checks whether object is the base root object
			Return - Boolean
			Parameters :
			obj - The Object to check if root
		*/
		Base_isRoot(obj){
			return this.Tree_Name(obj) == this.Tree_Name(this.Base_Root(obj))
		}
		/*
			Method - Name(obj)
			Description - gets Object's Class name
			Return -  Returns the inputted object's Class name
			Parameters :
			obj - The object to get the class name of
		*/
		Name(obj*)	{
			obj.push("")
			obj:=this.Tree_Name(obj*)
			obj.pop()
			loop % obj.MaxIndex()
				obj[A_Index]:=substr(obj[A_Index],instr(obj[A_Index],".",,-1)+1)
			return obj.MaxIndex() == 1? obj[1]:obj
		}
		/*
			Method - Tree_Name(obj)
			Description - Gets Object's Class Tree Name.
			Return -  Returns obj.__Class. However it works around some meta functions
			Parameters :
			obj - Object to get the Tree Name of
		*/
		Tree_Name(obj*) {
			Loop % obj.MaxIndex()
				obj[A_Index]:=!isobject(obj[A_Index])?obj[A_Index]:isfunc(obj[A_Index].__ID)?obj[A_Index].__ID(-2):obj[A_Index].__Class
			return obj.MaxIndex() == 1? obj[1]:obj
		}
		/*
			Method - Tree_VName(obj)
			Description - Gets Object's Tree name in a variable friendly format
			Return - Returns Tree_Name with . replaced with #
			Parameters :
			obj - Object to get Tree_VName
		*/
		Tree_VName(obj*) {
			obj.push("")
			obj:=this.Tree_Name(obj*)
			obj.pop()
			Loop % obj.MaxIndex()
				obj[A_Index]:=StrReplace(obj[A_Index],".","#")
			return obj.MaxIndex() == 1? obj[1]:obj
		}
		/*
			Method - Tree_Parent(obj)
			Description - Gets the Object's Global Parent Class Object
			Return - Returns the Global Parent Class Object of obj
			Parameters :
			obj - Object to get the parent of
		*/
		Tree_Parent(obj*)	{
			obj.push("")
			obj:=this.Tree_Name(obj*)
			Loop % obj.MaxIndex()
				obj[A_Index]:=substr(obj[A_Index],1,instr(obj[A_Index],".",,-1) - 1)
			obj:=this.Global(obj*)
			obj.pop()
			return obj.MaxIndex() == 1? obj[1]:obj
		}
		/*
			Method - Tree_Root(obj)
			Description - Gets the Object's Lowest Global Parent Class Object
			Return - Returns the lowest Global Parent Class object of obj
			Parameters :
			obj - Object to get the root parent of.
		*/
		Tree_Root(obj*) {
			obj.push("")
			obj:=this.Tree_Name(obj*)
			Loop % obj.MaxIndex()
			{
				delim:=instr(obj[A_Index],".")
				obj[A_Index]:=substr(obj[A_Index],1,delim==0?strlen(obj[A_Index]):delim-1)
			}
			obj:=this.Global(obj*)
			obj.pop()
			return obj.MaxIndex() == 1? obj[1]:obj
		}
		/*
			Method - Tree_Child_Get(obj,child:="")
			Description - Get's Object's Global Class child CLasses
			Return - Returns either an array listing child class names or the child class itself if child name is provided and exists
			Parameters :
			obj - Object to get the global child classes of
			child - the name of the child class to be returned.
		*/
		Tree_Child_Get(obj,child:="") {
			Name:=this.Tree_Name(Obj)
			Obj:=this.Global(Name)
			return isobject(Obj[child]) and Name "." child == this.Tree_Name(Obj[child])?Obj[child]:this.Tree_Child(obj)
		}
		Tree_Child(obj*) {
			obj.push("")
			Obj:=this.Global(obj*)
			Name:=this.Tree_Name(Obj)
			obj.pop()
			Loop % Obj.MaxIndex()
			{
				tObj:=Obj[A_Index]
				tName:=Name[A_Index]
				out:=Array()
				For key,val in tObj {
					if(isobject(val) and this.Name(val) == key and tName "." key == this.Tree_Name(val))	
						out.push(key)
				}
				Obj[A_Index]:=out
			}
			return obj.MaxIndex() == 1? obj[1]:obj
		}
		isGlobal(obj)	{
			return obj == this.Global(obj)
		}
		/*
			Method - Global(obj)
			Description - Gets Object's Global Class Object
			Return -  Returns Object's Global Class Object
			Parameters :
			obj - object to get the global class of
		*/
		Global(obj*) {
			static cache:=Array()
			obj.push("")
			obj:=this.Tree_Name(obj*)
			vobj:=this.Tree_VName(obj*)
			obj.pop()
			output:=Array()
			Loop % obj.MaxIndex()
			{
				if(isobject(cache[vobj[A_Index]]))
					output.push(cache[vobj[A_Index]])
				else
				{
					oobj:=""
					stree:=StrSplit(obj,".")
					root:=stree.RemoveAt(1)
					if(isobject(%root%)){ ;Checks if root object exists
						root:=%root%	;Gets root object
						oobj:=stree.length() == 0?root:root[stree*] ;gets SubObject
						cache[vobj[A_Index]]:=isobject(oobj)?oobj:"" ;Puts output into cache
					}
					output.push(oobj)
				}
			}
			return output.MaxIndex() == 1? output[1]:output
		}
		/*
			Class - Interface
			Description - Used to define standardized functions in classes
		*/
		Class Interface extends Lib.Obj.Meta.Call_Construct {
		
			/*
				Constructor - (int_functions:="")
				Description -
				Parameters:
					int_functions - Array of Function definition
			*/
			__New(int_functions:="")	{
				if(isobject(int_functions))
					this.int_functions:=int_functions
			}
			/*
				Method - Add(Func_Name,Description:="",MinParamsPlus1:=1)
				Description - Adds Function to Interface
				Return - None
				Parameters:
					Func_Name - Function Name
					Description	- Function Description
					MinParamsPlus1 - Minimum Function Parameters
			*/
			Add(Func_Name,Description:="",MinParamsPlus1:=1){
				if(!this.__final)	{
					this.int_impl_cache:=Array()
					this.int_functions:=isobject(this.int_functions)?this.int_functions:Array()
					this.int_functions[Func_Name]:={Description:Description,MinParamsPlus1:MinParamsPlus1  is digit?MinParamsPlus1:1}
				}
			}
			/*
				Method - Functions()
				Description - Gets Functions defined in this interface
				Return - Array of Functions defined in this interface
			*/
			Functions() {
				return isobject(this.int_functions)?this.int_functions:Array()
			}
			/*
				Method - MissingFunc(Obj)
				Description - Gets Functions that aren't defined by object
				Return - Array of Functions not defined by object
				Parameters:
					Obj - Object to check for functions
			
			*/
			MissingFunc(Obj)	{
				Output:=Array()
				For funct, Info in this.int_functions
					Output[funct]:=isfunc(Obj[funct]) >= Info.MinParamsPlus1?"":Info
				return Output
			}
			/*
				Method - isImplemented(Obj)
				Description -	Tests whether Object implements all of the Interface's Functions
				Return -  Boolean on whether Interface is implemented
				Parameters:
					Obj - Object to test
			
			*/
			isImplemented(Obj) {
				Obj_Tree_Ref:=Lib.Obj.Class.Tree_VName(Obj)
				if(this.int_impl_cache[Obj_Tree_Ref] == "")
					this.int_impl_cache[Obj_Tree_Ref]:=Lib.Obj.Array.isEmpty(this.MissingFunc(Obj))
				return this.int_impl_cache[Obj_Tree_Ref]
			}
		}
}