	Class ID extends AHK.Lang.Class.Meta.call_functor{
		/*
			Gives Objects an ID.
			
			mode: 
				0 - Returns Object's ID (If Object doesn't have an ID, then one is assigned)
				1 -  Returns Object's ID (If one isn't assigned then blank is returned)
		*/
		Call(self, byref Obj,mode:=0)	{
			static GOID_Ref:="__ID" Ahk.Hash(A_ScriptFullPath "_" A_ScriptHwnd , Ahk.Hash.HashKey(64,8,1))
			if(Ahk.Obj.Class.Tree_Name(Ahk.Obj.Class.Base_Root(Obj)) == "AHK.Lang.Class.Meta.ID.Meta_ID") ;Checks if Object is a meta_ID object
				return Obj.__ID(mode)	;Calls Meta_ID object
			OID_Ref:=GOID_Ref Ahk.obj.class.isGlobal(Obj)
			if(!isobject(Obj[OID_Ref]) or Ahk.Obj.Class.Tree_Name(Obj[OID_Ref]) != "AHK.Lang.Class.Meta.ID.generic_ID") ;Checks if object does not have generic_ID 
				Obj[OID_Ref]:=new AHK.Lang.Class.Meta.ID.generic_ID()	;Gives it a generic_ID 
			if(!isobject(Obj[OID_Ref]) or Ahk.Obj.Class.Tree_Name(Obj[OID_Ref]) != "AHK.Lang.Class.Meta.ID.generic_ID") ;Checks if it still doesn't have a generic_ID
				Ahk.tshoot("Error - Unable to set Object ID",Obj)	;Throws Error because it can't set object ID
			return Obj[OID_Ref].__ID(mode)	;Returns output.
		}
		Retired(objID:="")	{
			static retired:=Array()
			if(objID is digit and objID != "")
				retired.push(objID)
			return retired
		}
		
		Class generic_ID extends AHK.Lang.Class.Meta.ID.meta_ID {
			static __Meta:=1
		}
		Class meta_ID{
				/*
					mode:
						-10	- Enables Check Serializing Bypass
						-9 - Disables Check Serializing Bypass
						-3 - Returns Base Class
						-2 - Returns Object's Class
						-1 - Returns Version of the Object without Object ID Variables
						0 - Returns Object's ID (If Object doesn't have an ID, then one is assigned)
						1 -  Returns Object's ID (If one isn't assigned then blank is returned)
						object - Returns whether set should be bypassed. assumes object is array of keys
				*/
				__ID(mode:=0) 	{
					static ObjID_Enumerator:=2, block:=1,GOID_Ref:="__ID" Ahk.Hash(A_ScriptFullPath "_" A_ScriptHwnd , Ahk.Hash.HashKey(64,8,1)),check_serializing:=0
					if(!isobject(mode))	{
						block:=0 ;Enables Bypass Block
						if(mode == 0 or mode == 1)	{ ;Get ID
							OID_Ref:=GOID_Ref Ahk.obj.class.isGlobal(this)
							ObjID:=this[OID_Ref].ID ;gets stored ObjID
							if(ObjID == "" and mode ==0) { ;Ensures Object has ID
								ObjID:=ObjID_Enumerator++ ;Assigns Object ID
								this[OID_Ref]:=new Ahk.Obj.Tool.Final({ID:ObjID,__Meta:1})
							}
						}
						else if(mode >= -3 and mode <= -1)	
							ObjID:=mode== -1 ?Ahk.Obj.Array.Associative.regex_keyFilter(this,"^__ID"):mode ==-2?this.__Class:mode==-3?this.base:""
						else if(mode == -10 or mode ==-9)	;Enables/DIsables Serializing Bypass
							check_serializing:=mode == -10
						block:=1 ;Disables Bypass block
						return ObjID
					}
					return !block?block:instr(mode[1],"__ID")==1?0:!check_serializing?-1:Ahk.obj.Serialize.isSerializing()!=this.__ID(-2) ;Determines whether action should be blocked. -1 = Doesn't care. 0=Allow Write to object 1=Block Write to object
				}
				__Set(Key*) {
					if(this.__ID(Key) == 1)
						return
				}
				__Call(funct,Key*)	{
					static bypass:=0
					if(funct == "__Delete")
						AHK.Lang.Class.Meta.ID.retired(this.__ID(1))
					else if(funct == "_NewEnum")
						if(!bypass) {
							bypass:=1,	output:=this.__ID(-1),	bypass:=0
							return output._NewEnum()
						}
				}
		}
	}