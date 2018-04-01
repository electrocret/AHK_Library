#Include %A_Scriptdir%\AHK_Library\Library_Include.ahk

TestImpl_Implements_Interface_Func:=Interface_Function().isImplemented(TestImplementation)
Msgbox TestImplementation class implements Interface_Function? %TestImpl_Implements_Interface_Func%

Interface_Function(){
	static Interface:=new AHK.Lang.Class.Interface()
	if(Interface.isNotFinal())	{
		Interface.Define_Func("testfunc_noparam","Function with no parameters")
		Interface.Define_Func("testfunc_params","Test",5,"TParam1,TParam2,TParam3,TParam4","1,3")
		Interface.Define_Func("testfunc_variadic","Test",5,"TParam1,TParam2,TParam3,TParam4,TParam5",,,1)
		Interface.Define_Inherit(Interface_Class)
		Interface.Define_Name(A_thisfunc)
		Interface.Finalize()
	}
	return Interface
}
Fail_Interface_Function(){
	static Interface:=new AHK.Lang.Class.Interface()
	if(Interface.isNotFinal())	{
		Interface.Define_Func("Fail_testfunc","Testfunction that isn't implemented by TestImplementation")
		Interface.Define_Inherit(Interface_Function)
		Interface.Define_Name(A_thisfunc)
		Interface.Finalize()
	}
	return Interface
}
Class Interface_Class extends AHK.Lang.Class.Interface {
static Interface_Import:="{""Definition"":{""Cache_Usage"":9,""Func"":{""class_testfunc"":1}},""Documentation"":{""Func"":{""class_testfunc"":{""desc"":""Function for Class Interface""}},""Name"":""""}}"
}


Class TestImplementation {
	testfunc_noparam(){
	}
	testfunc_params(byref Param1,param2,byref Param3,param4,byref param5){
	
	}
	testfunc_variadic(param1,param2,param3,param4,param5*){
	
	}
	class_testfunc(){
	}
	
}