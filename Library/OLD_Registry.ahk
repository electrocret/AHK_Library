/*
	Key Format:
	Key Starts with _ means it's a meta value
	Key with properties : <properties>#<keyname>
	
	Key Properties: 
		L - Value is locked and can only be changed in registry editor
		F - Value is stored in file
		H - Value is hidden in registry editor
*/

Class Registry {
	static Global_Set:=[Lib.Registry.User.Lib]
	static Global_Get:=[Lib.Registry.User.App,Lib.Registry.User.Lib,Lib.Registry.User.Common,Lib.Registry.System.App,Lib.Registry.System.Lib,Lib.Registry.System.Common]
	static Global_Enum:=[Lib.Registry.User.App,Lib.Registry.User.Lib,Lib.Registry.User.Common,Lib.Registry.System.App,Lib.Registry.System.Lib,Lib.Registry.System.Common]
	Class Global extends Lib.Obj.Meta.Variable {
		Variable(action,r_keys*)		{
			if(action == "set")	{
				value:=r_keys.pop()
				For index, Registry in Lib.Registry.Global_Set
					Registry[r_keys*]:=value
			}
			else if(action == "get")	{
				oValue:=Array()
				For index, Registry in Lib.Registry.Global_Get	{
					Value:=Registry[r_keys*]
					if(isobject(Value))
						oValue.push(Value)
					else if(Value !="")
						return Value
				}
				if(oValue.length() > 0)	{
					Value:=Array()
					For, index, rValue in oValue
						Lib.Obj.Array.Insert_Value(Value,rValue,0,1)
					return Value
				}
			}
			else if(action == "enum")	{
				Global_Array:=Array()
				For index, Registry in Lib.Registry.Global_Enum
					Lib.Obj.Array.Insert_Value(Global_Array,Registry,0,1)
				return Global_Array._NewEnum()
			}
		}
	}
	Class User{
		static Registry_Dir:=A_AppData "\Harmony\Registry"
		Class App extends Lib.Obj.Meta.Variable {
			Variable(action,r_keys*)		{
				static Registry_Store:=Array(),registry_file_timestamp:="",registry_file:=""
				registry_file:=registry_file != ""? registry_file:Lib.Class.Parent(this).Registry_Dir "\App\" Lib.Hash(A_ScriptFullPath) ".json"
				return Lib.Registry.Registry_Func(Registry_Store,registry_file,registry_file_timestamp,action,r_keys*)
			}
		}
		Class Lib extends Lib.Obj.Meta.Variable {
			Variable(action,r_keys*)		{
				static Registry_Store:=Array(),registry_file_timestamp:="",registry_file:=""
				registry_file:=registry_file != ""? registry_file:Lib.Class.Parent(this).Registry_Dir "\Lib\" Lib.Hash(A_LineFile) ".json"
				return Lib.Registry.Registry_Func(Registry_Store,registry_file,registry_file_timestamp,action,r_keys*)
			}
		}
		Class Common extends Lib.Obj.Meta.Variable {
			Variable(action,r_keys*)		{
				static Registry_Store:=Array(),registry_file_timestamp:="",registry_file:=""
				registry_file:=registry_file != ""? registry_file:Lib.Class.Parent(this).Registry_Dir "\Common.json"
				return Lib.Registry.Registry_Func(Registry_Store,registry_file,registry_file_timestamp,action,r_keys*)
			}
		}
	}
	Class System{
		static Registry_Dir:=A_AppDataCommon "\Harmony\Registry"
		Class App extends Lib.Obj.Meta.Variable {
			Variable(action,r_keys*)		{
				static Registry_Store:=Array(),registry_file_timestamp:="",registry_file:=""
				registry_file:=registry_file != ""? registry_file:Lib.Class.Parent(this).Registry_Dir "\App\" Lib.Hash(A_ScriptFullPath) ".json"
				return Lib.Registry.Registry_Func(Registry_Store,registry_file,registry_file_timestamp,action,r_keys*)
			}
		}
		Class Lib extends Lib.Obj.Meta.Variable {
			Variable(action,r_keys*)		{
				static Registry_Store:=Array(),registry_file_timestamp:="",registry_file:=""
				registry_file:=registry_file != ""? registry_file:Lib.Class.Parent(this).Registry_Dir "\Lib\" Lib.Hash(A_LineFile) ".json"
				return Lib.Registry.Registry_Func(Registry_Store,registry_file,registry_file_timestamp,action,r_keys*)
			}
		}
		Class Common extends Lib.Obj.Meta.Variable {
			Variable(action,r_keys*)		{
				static Registry_Store:=Array(),registry_file_timestamp:="",registry_file:=""
				registry_file:=registry_file != ""? registry_file:Lib.Class.Parent(this).Registry_Dir "\Common.json"
				return Lib.Registry.Registry_Func(Registry_Store,registry_file,registry_file_timestamp,action,r_keys*)
			}
		}
	}
	Registry_Func(byref Registry_Store,registry_file,byref registry_file_timestamp, action, r_keys*){
		static overwrite:=1,apply_default:=0,parent_key:=""
		FileGetTime, reg_timestamp , %registry_file%,M
		if(reg_timestamp != registry_file_timestamp)	{ ;Checks if Registry file has changed last load. Reloads registry if it has.
			Lib.Obj.Array.insert_value(Registry_Store,Lib.JSON.Read(registry_file,1),1,1) ;Loads Registry
			FileGetTime, registry_file_timestamp , %registry_file%,M	;Updates File change tracker
		}
		if(action == "get")	{	;Registry get value
			Registry_Key:=this.Format_Subkey(r_keys)
			vArray:=instr(Registry_Key.properties,"f")?Lib.Json.read(registry_file,2):Registry_Store
			Value:=Lib.Obj.Array.get_value(vArray,Registry_Key.keys)
			if(Value == "") {
				Lastkey:=r_keys.pop()
				if(!isobject(lastkey) and RegexMatch(LastKey,"^((?:(?:[^?+*{}()[\]\\|]+|\\.|\[(?:\^?\\.|\^[^\\]|[^\\^])(?:[^\]\\]+|\\.)*\]|\((?:\?[:=!]|\?<[=!]|\?>)?(?1)??\)|\(\?(?:R|[+-]?\d+)\))(?:(?:[?+*]|\{\d+(?:,\d*)?\})[?+]?)?|\|)*)$"))	{ ;Checks if lastkey is a regex
					RRegistry_Key:=this.Format_Subkey(r_keys)
					vArray:=instr(RRegistry_Key.properties,"f") and instr(Registry_Key.properties,"f")?vArray:instr(RRegistry_Key.properties,"f")?Lib.Json.read(registry_file,2):Registry_Store
					if(!instr(RRegistry_Key.properties,"f"))
						Value:=Lib.Obj.Array.regex_Search(Lib.Obj.Array.get_value(Lib.Json.read(registry_file,2),RRegistry_Key.keys),LastKey,1,Value)
					Value:=Lib.Obj.Array.regex_Search(Lib.Obj.Array.get_value(vArray,RRegistry_Key.keys),LastKey,1,Value)
				}
			}
			return Value
		}
		if(action == "set")	{ ;Registry set value
			Value:=r_keys.pop()
			Registry_Key:=this.Format_Subkey(r_keys,parent_key)
			if(!instr(Registry_key.properties,"l") or !Lib.Registry.Editor.lock() or apply_default)	{
				if(!isobject(Value))	{
					file_key:=instr(Registry_key.properties,"f")?1:0
					registry_file_timestamp:=Lib.Json.write(registry_file,Lib.Obj.Array.Insert_Value(file_key?Lib.Json.read(registry_file,2,Array()):Registry_Store,Value,!apply_default,1,Registry_key.keys),1+ file_key)
					if(instr(Registry_key.properties,"_"))		{ ;Checks if Meta Value was set
						if(Registry_Key.keys.pop() == "default_value")	{ ;checks if meta value was a default_value
							key:=Registry_Key.keys.pop()
							if(RegexMatch(key,"(^_|_.*#)")) { ;checks if parent key was a meta value
								while(RegexMatch(key,"(^_|_.*#)")) ;removes meta markers from parent key
									StringReplace, key,key,_
								apply_default:=1,parent_holder:=parent_key, parent_key:=this.Format_subkey(Registry_key.keys), this.Registry_Func(Registry_Store,registry_file,registry_file_timestamp,"set",key,Value), parent_key:=parent_holder,	apply_default:=0 ;applies default value to non-meta key.
							}
						}
					}
				}
				else		{
					parent_holder:=parent_key, parent_key:=Registry_key
					For key,val in Value
						this.Registry_Func(Registry_Store,registry_file,registry_file_timestamp,"set",key,val)
					parent_key:=parent_holder
				}
			}
		}
		if(action == "enum") ;Registry Enum
			return Registry_Store._NewEnum()
	}
	Format_Key(key) {
		if(instr(key,"#")) {
			property_end:=instr(key,"#") ;Gets End of properties in key
			property:=this.Format_Properties(Lib.String.substr.trim(key,1,property_end))
			key:=Lib.String.substr.strip(key,1,property_end,property ) ;Updates the properties in key with formatted properties
		}
		else if(instr(key,"_") == 1)
			property:="_f"
		return {key:key,Properties:property}
	}
	Format_Properties(i_property) {
		Loop, Parse, i_property
			property.="#" A_Loopfield
		sort, property, D# U
		return StrReplace(property,"#")
	}
	Format_Subkey(r_keys,p_output:="")	{
		static Script_ID:=Lib.Hash(A_ScriptFullPath),Lib_ID:=Lib.Hash(A_LineFile)
		output:=isobject(p_output)?p_output:{keys:Array(),properties:""}
		tree_properties:=output.properties
		Loop % r_keys.Length()
		{
			subkey:=StrSplit(Format("{:L}",!isobject(r_keys[A_Index])?r_keys[A_Index]:Lib.Class.Tree(r_keys[A_Index]) != ""?Lib.Class.Tree(r_keys[A_Index]):Lib.Hash(r_keys[A_Index])),".",A_Space A_Tab)
			loop % subkey.Length()
				Key:=this.Format_Key(subkey[A_Index]),	tree_properties.=Key.properties,		output.keys.push(key.key)
		}
		output.properties:=this.Format_Properties(tree_properties)
		return output
	}
	Class Editor extends Lib.Obj.Meta.Call {
		lock()	{	;Enables/Disables locks on registries
			return 1
		}
	}
}