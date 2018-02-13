	Class Meta {
			/*
				Meta Class that is to be treated as a function. Each call creates a new Instance so properties used across sub-methods are not stored in function object.
				Examples: Ahk.Obj.JSON.Dump, Ahk.Obj.JSON.Load
			*/
			class Call_Functor{
				__Call(method, ByRef args*)		{
				; When casting to Call(), use a new instance of the "function object"
				; so as to avoid directly storing the properties(used across sub-methods)
				; into the "function object" itself.
						return isObject(method)? (new this).Call(method, args*):method == ""?(new this).Call(args*):""
				}
			}
			/*
				Meta Class that constructs a new class object when class is called as a function.
			*/
			Class Call_Construct{
				__Call(method, Byref args*) {
					if(isobject(method))
						return new this(args*)
				}
			}
			/*
				Meta Class that passes all undefined functions onto Call Function
			*/
			class Call{
				__Call(method, ByRef args*)	{
						return this.Call(method, args*)
				}
			}
			/*
				
			*/
			Class Variable {
				__Get(Key*)	{
					return  this.Variable("get",Key*)
				}
				__Set(Key*)	{
					return this.Variable("set",Key*)
				}
				_NewEnum(){
					return this.Variable("NewEnum")
				}
			}
			/*
				
			*/
			Class Get {
				__Get(Key*)	{
					return this.Get(Key*)
				}
			}
			/*
				
			*/
			Class Set {
				__Set(Key*)	{
					return this.Set(Key*)
				}
			}

		}