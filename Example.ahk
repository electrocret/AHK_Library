#Include %A_Scriptdir%\AHK_Library\Library_Include.ahk
msgbox % AHK.lang.Func.MinParams(test.test)
testin:=new test()
msgbox % AHK.lang.Func.MinParams(testin.test)


class test{
	
	
	test(test:=5){
		
		
	}
	
}