			/*
				;Needs work. 
			*/
			Class Bypass {
				Class Object extends Ahk.Obj.Meta.Bypass.Base{
					__Get(Key*) {
						if(this.__Bypass(Key) == -1)
							return  this.Object("get",Key*)
					}
					__Set(Key*)	{
						bp:=this.__Bypass(Key)
						if(bp)
							return bp == -1?this.Object("set",Key*):""
					}
					__Call(funct,Key*)	{
						if funct not in __ID,__Bypass
							if(this.__Bypass(Key) == -1)	{
								if(funct == "_NewEnum")
									return this.Object("newenum",Key*)
								return this.Object("call",funct,Key*)
							}
					}
				}
				Class Variable extends Ahk.Obj.Meta.Bypass.Base{
					__Get(Key*) {
						if(this.__Bypass(Key) == -1)
							return  this.Variable("get",Key*)
					}
					__Set(Key*)	{
						bp:=this.__Bypass(Key)
						if(bp)
							return bp == -1?this.Variable("set",Key*):
					}
					__Call(funct,Key*)	{
						if(funct == "_NewEnum")
							if(this.__Bypass(Key) == -1)
								return this.Variable("newenum",Key*)
					}
				}
				Class Get extends Ahk.Obj.Meta.Bypass.Base{
					__Get(Key*)	{
						if(this.__Bypass(Key) == -1)
							return this.Get(Key*)
					}
				}
				Class Set extends Ahk.Obj.Meta.Bypass.Base{
					__Set(Key*)	{
						bp:=this.__Bypass(Key)
						if(bp)
							return bp == -1?this.Set(Key*):
					}
				}
				Class Base extends Ahk.Obj.Meta.ID.Meta_ID{
					/*
						bypass_times: 
							object - returns whether to bypass. Assumes object is array of keys
							0  -  current bypass times
							>0 -Increases bypass that many times
							-1 - Continuous bypass
							<blank> - Clears memory for that object
							get -performs bypass __get
							set -performs bypass __set
							newenum -performs bypass _NewEnum
							ID - Gets object ID
							
						Passphrase:
							-A password to secure Object Bypass. Passphrase can only be set before object has received it's Object ID from __ID().
						Keys*:
							Keys to be used for bypass __get and __set
					*/
					__Bypass(bypass_times:=0,Passphrase:="",Keys*)	{
						static obj_bp:=Array() ;Object bypass times holder
						,obj_ph:=Array() ;Object Passphrase holder
						,Internal_BP:=0 ;Function Internal Bypass
						if(isobject(bypass_times)) {
							ID_Bypass:=this.__ID(bypass_times)
							if(ID_Bypass != -1)
								return ID_Bypass
							if(Internal_BP)
								return !Internal_BP
							obj_ID:=this.__ID() ;Gets Object ID
							,bp_time:=obj_bp[obj_ID] is integer?obj_bp[obj_ID]:0 ;Gets object's bypass times
							,obj_bp[obj_ID]:=bp_time > 0?bp_time - 1:bp_time ;Decrements bypass times if greater than 0
							return bp_time != 0?0:-1 ;Returns whether to bypass meta function. 0 - True, -1-False
						}
						Obj_ID:=this.__ID(1)
						if(Obj_ID == "")
							Obj_ID:=this.__ID(),obj_ph[Obj_ID]:=Passphrase
						if(bypass_times == "delete")
									Internal_BP:=1,this:="",obj_bp[obj_ID]:="",obj_ph[obj_ID]:="",Internal_BP:=0
						else if(obj_ph[Obj_ID] == Passphrase) {
							if(bypass_times != "")	{
								if bypass_times is digit
									output:=obj_bp[obj_ID]:=obj_bp[obj_ID] is digit? obj_bp[obj_ID] + bypass_times:bypass_times
								else if(bypass_times == "get")
									Internal_BP:=1,output:=this[Keys*],Internal_BP:=0
								else if(bypass_times == "set")
									Internal_BP:=1,output:=this[Keys*]:=Keys.pop(),Internal_BP:=0
								else if(bypass_times == -1)
									output:=obj_bp[obj_ID]:=-1
								else if(bypass_times == "id")
									output:=Obj_ID
								else if(bypass_times == "newenum")
									Internal_BP:=1,output:=this._NewEnum(),Internal_BP:=0
								else if(bypass_times == -2)
									output:=this.__ID(-2)
								else
									output:=obj_bp[obj_ID]:=""
							}
							else
								output:=obj_bp[obj_ID]:=""
							return output
						}
					}
					__Delete()	{
						this.__Bypass("delete")
					}
				}
			}