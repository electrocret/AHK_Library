Class Lang{
		#Include %A_Scriptdir%\AHK_Library\AHK\Lang\Class\Class.ahk
		#Include %A_Scriptdir%\AHK_Library\AHK\Lang\Function.ahk
		Class Var{
			isValidName(Varname){
				return !(Varname == "" or RegExMatch(Varname, "([[:alnum:]]|#|\$|_|@)*(*PRUNE)\D") or StrLen(Varname) >= 253)
			}
		}
}