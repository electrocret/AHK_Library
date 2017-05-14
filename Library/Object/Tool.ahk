	Class Tool{
		Class Final extends Lib.Obj.Meta.Bypass.Object {
			__New(Value)	{
				this.Object("set",Value)
			}
			Object(Call,Function:="",Keys*) {
				static passphrase:=""
				if(Passphrase == "") {
					Random, RandomNum
					Passphrase:=Lib.Hash(RandomNum,Lib.Hash.HashKey(128,8,1))
				}
				storage:=this.__Bypass("get",Passphrase,"__final" Passphrase)
				if(call == "set" and !isobject(Storage))
					Function.__final:=1, this.__Bypass("set",Passphrase,"__final" Passphrase,Function)
				else
					return call == "get"?Lib.Obj.Array.Clone(storage)[Function,Keys*]:call == "call"?storage[Function](Keys*):Call == "newenum"? Lib.Obj.Array.Clone(storage)._NewEnum() :""
			}
		}
		Class Modified extends Lib.Obj.Meta.Bypass.Set {
			__New(Existing_Array:="")		{
				this.Modified(1) ;Records that Object has Modified
				if(isobject(Existing_Array)) ;Checks if Array was inputted
					Lib.Obj.Array.combine(this,Existing_Array) ;Inserts Values
			}
			Set(Keys*)	{
				this.Modified(1) ;Records that Object Modified
				this[Keys*]:=Keys.pop() ;Performs Set
			}
			Modified(state:=0)		{
				static Modified:=Array() ;Holder for Modified status
				objID:=this.__ID() ;Gets Object ID
				,Modified_State:=Modified[objID] ;Gets Current State
				if(state != Modified_state) ;Checks if Modified state differs
					this.__Bypass(state?-1:""),Modified[objID]:=state ;Records new state
				return Modified_State ;returns old state
			}
			__Delete()	{
				this.Modified("") ;Clears Modified state from holder
				base.__Delete()
			}
		}
	}