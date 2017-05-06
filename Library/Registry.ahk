/*
	
	File - array with root_key as key and value {File_Ref,Timestamp}
	Storage - Array that contains mem values
	Properties - generated on file load. contains properties about variable
	
	properties:
	L - locked (can only be edited in Registry editor)
	F - File - Value stored in file
	H - Hidden - Hidden in Registry Editor
	
*/
Class Reg extends Lib.Obj.Meta.Variable{
	Variable(action,r_keys*) {

	}

	/*
		Class - Key(i_Keys*)
		description - Parses Keys into a standardized object for registry use. Also processes variable keys
		Parameters :
		
	*/
	Class Key extends Lib.Obj.Meta.Call_Construct{
		__New(i_Keys*) {
		
		
		}
	}
	Class Root_Key{
		Class Base{
		
		}
		Class File{
		
		}
		Class Alias{
		
		}
	}
}