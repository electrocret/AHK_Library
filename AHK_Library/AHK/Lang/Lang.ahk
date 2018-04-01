Class Lang{
	#Include %A_Scriptdir%\AHK_Library\AHK\Lang\Class\Class.ahk
	#Include %A_Scriptdir%\AHK_Library\AHK\Lang\Func.ahk
	#Include %A_Scriptdir%\AHK_Library\AHK\Lang\Logic.ahk
	#Include %A_Scriptdir%\AHK_Library\AHK\Lang\Cmd.ahk
	Class Var{
		isValidName(Varname){
			return !(Varname == "" or RegExMatch(Varname, "([[:alnum:]]|#|\$|_|@)*(*PRUNE)\D") or StrLen(Varname) >= 253)
		}
		isValidName_Obj(Varname){
			return !(Varname == "" or RegExMatch(Varname, "([[:alnum:]]|#|\$|_|.|@)*(*PRUNE)\D") or StrLen(Varname) >= 253)
		}		
	}

}