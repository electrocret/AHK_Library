Class Obj{
	#Include %A_Scriptdir%\AHK_Library\AHK\Object\JSON.ahk
	#Include %A_Scriptdir%\AHK_Library\AHK\Object\Array\Array.ahk
	#Include %A_Scriptdir%\AHK_Library\AHK\Object\KeyReference.ahk
	/*
		Checks whether a Key-Value is meta info about an object
		Meta Info either has a key that starts with __ or is an object with a key value of __Meta
	*/
	isMetaInfo(Key,Value){
		return instr(Key,"__") == 1 or (isobject(Value) and Value.__Meta == 1)
	}
	hasKey(byref Obj,byref Keys*){
		haskeys:=1
		For i,Key in Keys
		{
			if(isobject(Key) )
			{
			
			
			}
		
		}
		
	}
}