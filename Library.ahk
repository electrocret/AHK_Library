/*
test_interface:=new Lib.Obj.tool.Interface()
test_interface.add("dummy")
/*
test_final:=New Lib.Obj.tool.Final(test_interface)
test_final.int_functions.dummy.description:="poop"

test_final:=Lib.obj.Json.load(Lib.obj.Json.Dump(test_interface))
out:=test_final.isImplemented(Lib)
lib.tshoot(test_final,out,test_interface.isImplemented(Lib))
*/

Class Lib{
	__New(Libraries,Check_Update:="",Exec_Script:="")
	{
	}
	Class Manager{

		Documentation(Library:="")
		{
				
		}
		Update(Library:="")
		{
		
		}
	}
	#Include %A_Scriptdir%\Library\Import.ahk
	#Include %A_Scriptdir%\Library\Asynchronous.ahk
	#Include %A_Scriptdir%\Library\Object.ahk
	#Include %A_Scriptdir%\Library\Registry.ahk
	#Include %A_Scriptdir%\Library\Hash.ahk
	#Include %A_Scriptdir%\Library\Github.ahk
	#Include %A_Scriptdir%\Library\String.ahk
	

tshoot(variables*)	{	
	output:=""
	Loop % variables.MaxIndex()
		output.="Variable" A_Index " :" Lib.obj.Json.dump(variables[A_Index]) "`n"
	msgbox % output
}

}