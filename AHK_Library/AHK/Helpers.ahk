Class Helpers{
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
	Config_Load(Class_Obj,Default_Config:="",Config_Line:=1){
		return AHK.Obj.json.read(A_ScriptDir "\AHK_Library\Config\" AHK.Lang.Class.Global.Name(Class_Obj) ".json",Config_Line,Default_Config)
	}
	Config_Save(Class_Obj,Config_Obj,Config_Line:=1){
		return AHK.Obj.Json.write(A_ScriptDir "\AHK_Library\Config\" AHK.Lang.Class.Global.Name(Class_Obj) ".json",Config_Obj,Config_Line)
	}
	Cache_CacheDir(cdir:=""){
		static cachedir:=0
		if(!cachedir)	{
			if(cdir != ""){
				FileCreateDir, %cdir%
				if(inStr(FileExist(cdir),"D"))
					cachedir:=cdir
			}
			cachedir:=cachedir == 0?A_ScriptDir "\AHK_Library\Cache\":cachedir
			FileCreateDir, %cachedir%
			FileDelete, %cachedir% *.json
		}
		return cachedir
	}
	Cache_Load(Class_Obj,Default_Cache:="",Cache_Line:=1){
		return AHK.Obj.json.read(this.Cache_CacheDir() AHK.Lang.Class.Global.Name(Class_Obj) ".json",Cache_Line,Default_Cache)
	}
	Cache_Save(Class_Obj,Cache_Obj,Cache_Line:=1){
		return AHK.Obj.Json.write(this.Cache_CacheDir() AHK.Lang.Class.Global.Name(Class_Obj) ".json",Cache_Obj,Cache_Line)
	}
	tshoot(variables*)	{	
		output:=""
		Loop % variables.Length()
			output.="Variable" A_Index " :" Ahk.obj.Json.dump(variables[A_Index]) "`n"
		msgbox % output
	}
}