Class Obj{
	/*
	
	*/
	#Include %A_Scriptdir%\Library\Object\Class.ahk
	#Include %A_Scriptdir%\Library\Object\Tool.ahk
	#Include %A_Scriptdir%\Library\Object\JSON.ahk
	#Include %A_Scriptdir%\Library\Object\ID.ahk
	#Include %A_Scriptdir%\Library\Object\Meta.ahk
	#Include %A_Scriptdir%\Library\Object\Array.ahk
	isMetaInfo(Key,Value){
		return instr(Key,"__") == 1 or (isobject(Value) and Value.__Meta == 1)
	}
}