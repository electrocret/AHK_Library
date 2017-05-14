	/*
		Serializable classes can contain a Serialize class which is an extension of Lib.Obj.Serializable and custom Dump/Load/Salt functions will be use
		
		Variables can be set as well and generic serializing will be done
		Serializer - Boolean on whether class is serializable
		Serializer_Exclude - An array of keys that will be excluded from serializing
		Serializer_Include - an Array of keys that will be included in serializing
		Serializer_Params - Contstructor parameter keys
	
	*/

	Class Serialize {
		;If Is serializing then it returns the class name of the object being serialized
		isSerializing()	{
			load_serializing:=this.Load("",1),	dump_serializing:=this.Dump("",1)
			return load_serializing == ""?dump_serializing:load_serializing
		}
		Dump(value,mode:=0)	{
			static serializing:=""
			if(value == "" and mode == 1)	
				return serializing
		}
		Load(value,mode:=0)	{
			static serializing:=""
			if(value == "" and mode == 1)	
				return serializing
		}
		Class Serializer {
			Dump(global_cls,serial_obj) {
				if(global_cls.Serializer != 0)	{
					if(isobject(global_cls.Serializer) and Lib.obj.class.Tree_Name(Lib.obj.class.base_root(global_cls.Serializer)) == "Lib.obj.Serial.Serializer")
						return global_cls.Serializer.Dump(global_cls,serial_obj)
					output:=Array()
					if(isobject(global_cls.Serializer_Include)	{
						Loop % global_cls.Serializer_Include.Length()
							output[global_cls.Serializer_Include[A_Index]]:=serial_obj[global_cls.Serializer_Include[A_Index]]
					}
					else	{
						for key,val in serial_obj
							if(!Lib.obj.array.hasValue(global_cls.Serializer_Exclude,key))
								output[key]:=val
					}
					if(isobject(global_cls.Serializer_Params))
						Loop % global_cls.Serializer_Params.Length()
							output[global_cls.Serializer_Params[A_Index]]:=serial_obj[global_cls.Serializer_Params[A_Index]]
					return output
				}
			}
			Load(global_cls,serial_obj) {
				if(global_cls.Serializer != 0)	{
					if(isobject(global_cls.Serializer) and Lib.obj.class.Tree_Name(Lib.obj.class.base_root(global_cls.Serializer)) == "Lib.obj.Serial.Serializer")
						return global_cls.Serializer.Load(global_cls,serial_obj)
					
				
				
				}
			}
			Salt()	{
				return !Lib.Obj.Serialize.isSerializing()?"":
			}
		}
	}