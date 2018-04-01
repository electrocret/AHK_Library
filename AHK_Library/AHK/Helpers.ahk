
Class Helpers{
	Dir_CFG(dir_name){
		static directories:="",Last_avail_check:=0,Dir_Available_Check_Frequency:=15*60000
		,Default_Directories:={Dir_Available_Check_Frequency:15*60000
			,Config:A_ScriptDir "\AHK_Library\Config\"
		,Cache:{dir:A_ScriptDir "\AHK_Library\Cache\",OnExit:{Delete:"*_" A_ScriptHWND ".json"}}}
		
		if(!isobject(directories)){ ;If Directories has not been initialized
			directories:=isobject(dir_name)?dir_name:Default_Directories ;If Dir_Name is a directories db then use it otherwise use default
			For dir, dir_def in Default_Directories ;Ensures Directories contains all default directories
			{
				if(!directories.hasKey(dir))
				directories[dir]:=dir_def
			}
			Default_Directories:="" ;Clears Default directories from mem
			if(directories.hasKey("Dir_Available_Check_Frequency"))	{ ;If Directories defines Dir_Available_Check_Frequency
				if(AHK.lang.Logic.isType.digit(directories.Dir_Available_Check_Frequency)) ;If Dir_Available_Check_Frequency is valid
				Dir_Available_Check_Frequency:=directories.Dir_Available_Check_Frequency ;Load Dir_Available_Check_Frequency into Dir_CFG settings
				directories.Delete("Dir_Available_Check_Frequency") ;Clear Dir_Available_Check_Frequency from Directories definition
			}
			hasOnexit:=0
			For dir, dir_def in directories
			{
				if(isobject(dir_def))	{
					AHK.Lang.cmd.CreateDir(dir_def.dir) ;Creates Config directory 
					if(!inStr(FileExist(dir_def.dir),"D")) ;Ensures Config directory exists
					throw Exception("Unable to reach " dir " directory. Directory: " dir_def.dir ) ;Error - directory doesn't exist.
					hasOnexit:=hasOnexit or dir_def.hasKey("OnExit")
					if(dir_def.hasKey("AutoExec"))
					{
						if(dir_def.AutoExec.hasKey("Delete"))
						AHK.lang.cmd.File.Delete(dir_def.dir dir_def.AutoExec.Delete)
						if(dir_def.AutoExec.hasKey("Copy"))	{
							if(isObject(dir_def.AutoExec.Copy))
							AHK.lang.cmd.File.Copy(dir_def.AutoExec.Copy.SourcePattern,dir_def.AutoExec.Copy.DestPattern)
							else
							AHK.lang.cmd.File.Copy(dir_def.AutoExec.Copy,dir_def.dir)
						}
					}
				}
				else	{
					AHK.Lang.cmd.CreateDir(dir_def) ;Creates Config directory 
					if(!inStr(FileExist(dir_def),"D")) ;Ensures Config directory exists
					throw Exception("Unable to reach " dir " directory. Directory: " dir_def ) ;Error - directory doesn't exist.
				}
			}
			Last_avail_check:=A_TickCount
			if(hasOnexit)
			OnExit(A_thisfunc)
			if(isobject(dir_name))
				return
		}
		if(AHK.lang.logic.istype.integer(dir_name) and dir_name != "") { ;Checks if OnExit is called
			For dir, dir_def in directories
			{
				if(isobject(dir_def))	{
					if(dir_def.hasKey("OnExit"))
					{
						if(dir_def.OnExit.hasKey("Delete"))
						AHK.lang.cmd.File.Delete(dir_def.dir dir_def.OnExit.Delete)
						if(dir_def.OnExit.hasKey("Copy"))	{
							if(isObject(dir_def.OnExit.Copy))
							AHK.lang.cmd.File.Copy(dir_def.OnExit.Copy.SourcePattern,dir_def.OnExit.Copy.DestPattern)
							else
							AHK.lang.cmd.File.Copy(dir_def.OnExit.Copy,dir_def.dir)
						}
					}
				}
			}
			return
		}
		else if((A_TickCount - Last_avail_check) > Dir_Available_Check_Frequency) { ;Checks if it's time to check directories accessibility
			For dir, dir_def in directories
			{
				if(!inStr(FileExist(isobject(dir_def)?dir_def.dir:dir),"D")) ;Ensures Config directory exists
				throw Exception("Unable to reach " dir " directory. Directory: " isobject(dir_def)?dir_def.dir:dir ) ;Error - directory doesn't exist.
			}
			Last_avail_check:=A_TickCount
		}
		return directories.hasKey(dir_name)?(isobject(directories[dir_name])?directories[dir_name].dir:directories[dir_name]):directories
	}
	
	/*
		Return helper for functions that have the option to be variadic. If the Values array has more than 1 value it returns Values. If Values array has only 1 value it returns just that 1 value.
		
		For examples of use look at:
		AHK.Obj.Array.Linear -Multiple Functions
		AHK.Obj.Array.Associative -Multiple Functions
		AHK.Obj.Array.Generic -Multiple Functions
	*/
	Variadic_RTN_FMT_Optional(byref Values){
		return Values.length() == 1?Values[1]:Values
	}
	/*
		Helper for functions that have optional parameters but are also optionally variadic. Note- Variadic values must be Objects and Parameters cannot be Objects
		
		For examples of use look at:
		AHK.Obj.Array.Generic.Sort_Group
		AHK.Obj.Array.Linear.Join
	*/
	Variadic_PARAM_DEF_VAL(Byref Vari,Byref Params*) {
		For i,Val in Params
		if(isObject(Val)) 
		Vari.push(Params[i]),	Params[i]:=Default_Value
		else
		Default_Value:=Val
	}

	Config_Load(byref Class_Obj,byref Default_Config:="",Config_Line:=1){
		return AHK.Obj.json.read(this.Dir_CFG("Config") AHK.Lang.Class.Global.Name(Class_Obj) ".json",Config_Line,Default_Config)
	}
	Config_Save(byref Class_Obj,byref Config_Obj,byref Config_Line:=1){
		return AHK.Obj.Json.write(this.this.Dir_CFG("Config") AHK.Lang.Class.Global.Name(Class_Obj) ".json",Config_Obj,Config_Line)
	}
	Cache_Load(byref Class_Obj,byref Default_Cache:="",Cache_Line:=1){
		return AHK.Obj.json.read(this.Dir_CFG("Cache") AHK.Lang.Class.Global.Name(Class_Obj) "_" A_ScriptHWND ".json",Cache_Line,Default_Cache)
	}
	Cache_Save(byref Class_Obj,byref Cache_Obj,Cache_Line:=1){
		return AHK.Obj.Json.write(this.Dir_CFG("Cache") AHK.Lang.Class.Global.Name(Class_Obj) "_" A_ScriptHWND ".json",Cache_Obj,Cache_Line)
	}
	Cache_Obj_Lock(byref ContainerObj,byref CacheObj_VarName, byref Lock_Func, byref CacheObj_Line:=1){
		if(!isObject(ContainerObj[CacheObj_VarName])) { ;Is CacheObj not Loaded into memory?
			ContainerObj[CacheObj_VarName]:=this.Cache_Load(AHK.Lang.Func.ClassName(Lock_Func),Array(),CacheObj_Line) ;Loads CacheObj into memory
			if(!isobject(ContainerObj[CacheObj_VarName "_CacheLock"])) ;Does CacheObj's Lock array not exist?
				ContainerObj[CacheObj_VarName "_CacheLock"]:=Array() ;Creates CacheObj's Lock Array
		}
		ContainerObj[CacheObj_VarName "_CacheLock"][Substr(Lock_Func,".","#")]:=1 ;Marks Lock_Func in Lock Array
	}
	Cache_Obj_Unlock(byref ContainerObj,byref CacheObj_VarName, byref Lock_Func){
		if(isobject(ContainerObj[CacheObj_VarName "_CacheLock"]))	{ ;Does Cachelock exist?
			ContainerObj[CacheObj_VarName "_CacheLock"].remove(Substr(Lock_Func,".","#")) ;Removes Lock_Func from Lock array
			if(ContainerObj[CacheObj_VarName "_CacheLock"].MinIndex() == "") ;is Lock array empty?
				ContainerObj[CacheObj_VarName "_CacheLock"]:="",ContainerObj[CacheObj_VarName]:="" ;Remove Lock array and Cached Object from memory
		}
	}
	tshoot(variables*)	{	
		output:=""
		Loop % variables.Length()
		output.="Variable" A_Index " :" Ahk.obj.Json.dump(variables[A_Index]) "`n"
		msgbox % output
	}
}			