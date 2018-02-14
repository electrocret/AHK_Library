#Include %A_Scriptdir%\AHK_Library\Library_Include.ahk
msgbox % isfunc("AHK.lang.CLass.Interface")
msgbox % AHK.lang.Func.MinParams(test.test)
testin:=new test()
msgbox % AHK.lang.Func.MinParams(testin.test)


class test{
	
	
	test(test:=5){
		
		
	}
	
}

1(){
	
}