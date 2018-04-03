#Include %A_Scriptdir%\AHK_Library\Library_Include.ahk


documentation:=Interface_Function().Doc(1) ;Get extended Documentation of Interface_Function
msgbox Interface_Function Documentation:`n%documentation% ;Display Documentation
dump:=Interface_Function().dump() ;Generate Dump of Interface_Function (used for defining Interface during Construction, or can be set to var Interface_Import in Interface Classes).
msgbox Interface_Function Dump:`n%dump% ;Display Dump

Obj_Array:=[new TestImplementation(),new TestImplementation()]

try{
	;Example Successful Implementation
	TestImpl_Implements_Interface_Func:=Interface_Function().isImplemented(Obj_Array*)?"True":"False" ;Boolean Test Whether all objects in Obj_Array implements Interface_Function.
	Msgbox Classes of Objects in Obj_Array implement Interface_Function? %TestImpl_Implements_Interface_Func% ;Display Result
	
	Msgbox Add to Obj_Array an Object whose class doesn't implement Interface_Function.
	Obj_Array.push(new FailImplementation()) ;Add Obj that doesn't implement Interface
	
	;Example Failure (Exactly the same scripting as Successful)
	TestImpl_Implements_Interface_Func:=Interface_Function().isImplemented(Obj_Array*)?"True":"False" ;Boolean Test Whether all objects in Obj_Array implements Interface_Function.
	Msgbox Classes of Objects in Obj_Array implement Interface_Function? %TestImpl_Implements_Interface_Func% ;Display Result (Not executed because of Exception thrown)
}
catch e
{
	exception_msg:="Interface: " e.what " had an error.`n Message:`n" e.Message
	msgbox % exception_msg
}
Array_has_Implementation:=Interface_Function().Filter(Obj_Array)?"True":"False" ;Filter out Objects that don't implement Interface
msgbox Filtering out objects that don't implement Interface_Function from Obj_Array.`nDoes Obj_Array have Objects that implement Interface_Function? %Array_has_Implementation% ;Display Result

TestImpl_Implements_Interface_Func:=Interface_Function().isImplemented(Obj_Array*)?"True":"False" ;Boolean Test Whether all objects in Obj_Array implements Interface_Function.
Msgbox Classes of Objects in Obj_Array implement Interface_Function? %TestImpl_Implements_Interface_Func% ;Display Result



Fail_Interface_Function().isImplemented(TestImplementation)


Class TestImplementation {
	testfunc_noparam(){
	}
	testfunc_params(byref Param1,param2,byref Param3,param4,byref param5){
	}
	testfunc_variadic(param1,param2*){
	}
	class_testfunc(){
	}
}
Class FailImplementation {
}


Interface_Function(){
	static Interface:=new AHK.Lang.Class.Interface()
	if(Interface.isNotFinal())	{
		Interface.Define_Desc("Example Interface Defined in a function.")
		Interface.Define_Func("testfunc_noparam","Test Function with no parameters")
		Interface.Define_Func("testfunc_params","Test Function with 5 parameters, and paramerter 1&3 are byref, while 4 is specifically Local.",5,"TParam1,TParam2,TParam3,TParam4","1,3","4")
		Interface.Define_Func("testfunc_variadic","Test Function with 2 Parameters that is Variadic.",2,"TParam1,TParam2,TParam3,TParam4,TParam5",,,1)
		Interface.Define_Inherit("Interface_Class")
		Interface.Define_Name(A_thisfunc)
		Interface.Finalize()
	}
	return Interface
}
Fail_Interface_Function(){
	static Interface:=new AHK.Lang.Class.Interface()
	if(Interface.isNotFinal())	{
		Interface.Define_Desc("Example Interface that isn't Implemented by TestImplementation.")
		Interface.Define_Func("Fail_testfunc","Testfunction that isn't implemented by TestImplementation")
		Interface.Define_Inherit("Interface_Function")
		Interface.Define_Name(A_thisfunc)
		Interface.Finalize()
	}
	return Interface
}
Class Interface_Class extends AHK.Lang.Class.Interface {
	static Interface_Import:="{""Definition"":{""Cache_Usage"":9,""Func"":{""class_testfunc"":1}},""Documentation"":{""desc"":""Example Interface Defined in a Class."",""Func"":{""class_testfunc"":{""desc"":""Example Function for Class Interface""}}}}"
}


