/*
	Class - Hash
	Description - Constructed object acts as a Hashtable
	Note - Hashtable is stored on the constructed object prefixing hash keys with # (Value) and _# (Key). Any Key input into functions that starts with # is assumed to already be the hash value.
	
	Method -  Hash(Value,HKey:="")
	Description - Converts Value into a Hash value
	Return - Hash value
	Parameters :
	Value - Value to get a hash of. If blank then Substitution table cache is cleared for specified Hashkey, or for all Hashkeys if no hash key is specified.
	HKey - Hashkey object to use.
	
	Credits: 
		TEA Functions are based off of: https://autohotkey.com/board/topic/14040-fast-64-and-128-bit-hash-functions/ 
		CRC32, MD5, and SHA1 Functions are by SKAN https://autohotkey.com/board/topic/59576-filecrc32-filesha1-filemd5-and-md5/
*/
Class Hash extends AHK.Lang.Class.Meta.Call {
		;#### Functions Related to finding Hash
		Default_HKey:=new this.Hashkey(64,8,0,12,34,56,78,90) ;Default Hashkey
		
		Call(method,HKey:="",Values*)	{
			static TEA_STbl:=Array()	;Cache of TEA Substitution tables
			if(isobject(HKey)?HKey.__Class != this.__Class ".HashKey" : HKey != "") ;Checks if Hashkey was not provided
				Values.InsertAt(1,HKey),HKey:=this.Default_HKey
			;###  Check if call was to Clear TEA Substitution table cache
			if(Values.length() == 0){
				if(isobject(HKey) and HKey.kID != "") ;Clear for specific key
					TEA_STbl[Hkey.kID]:=""
				else if(!isobject(Hkey)) ;Clear completely
					TEA_STbl:=Array()
				return
			}
			;### Begin getting TEA substitution Table
			if(TEA_STbl[HKey.kId] == "")	{	;Checks if TEA substitution table exists for HashKey
				u:=0,v:=0
				LHash:=Array()
				Loop 256	;Builds substitution Table
					index:=A_Index - 1,this.TEA(u,v,HKey),	LHash[index]:=(u<<32) | v
				If(!HKey.onetime_use)
					TEA_STbl[HKey.kId]:=LHash ;Caches Substitution table for later use.
			}
			else	;Gets substitution Table from cache
				LHash:=TEA_STbl[HKey.kId]
			;### Begin Calculating Hashes
			Output:=Array()
			if(HKey.bit == 128)		{ ;Use 128bit TEA algorithm? 
				For i,value in Values		{
					S:=0,R:=-1
					Loop Parse, value	;Loop converts each character to a numeric value and adds characters together
						R := (R << 8) + Asc(A_LoopField) ^ LHASH[(R >> 56) & 255],	S := (S << 8) + Asc(A_LoopField) - LHASH[(S >> 56) & 255]
					Output.push(this.Hex8(R>>32) . this.Hex8(R) . this.Hex8(S>>32) . this.Hex8(S))	;Converts result numbers into 4 8 character long hex strings then concatenates
				}
			}
			else { ;Use 64bit TEA algorithm
				For i,value in Values		{
					R:=0
					Loop Parse, value ;Loop converts each character to a numeric value and adds characters together
						R := (R << 8) + Asc(A_LoopField) ^ LHASH[(R >> 56) & 255]
					output.push(this.Hex8(R>>32) . this.Hex8(R)) ;Converts result number into 2 8 character long hex strings then concatenates
				}
			}
			return AHK.Helpers.Variadic_RTN_FMT_Optional(output*)
		}
		/*
			Method - Call(method,value,HKey:="")
			description - The Hash Function
			Return - Hexadecimal hash string
			Parameters :
			method - not used
			value - The value to be turned into a hash
			HKey - Hash Key
		*/
		Old_Call(method,value,HKey:="")	{
				static TEA_STbl:=Array()	;Cache of TEA Substitution tables
				if(value == "")	{ ;Clear TEA Substitution table cache
					if(isobject(HKey) and HKey.kID != "") 
						TEA_STbl[Hkey.kID]:=""
					else if(!isobject(Hkey))
						TEA_STbl:=Array()
					return
				}
				Hkey:=isobject(HKey)?Hkey:this.Default_HKey ;Ensures a valid Hashkey is used
				if(isobject(value))	;If Object is provided for the value then converts it to a String (via JSON)
					value:=Ahk.obj.Json.Dump(value)
				if(HKey.kId == "")  ;Checks if MD5 Algorithm should be used
					return this.MD5(Value,HKey.cycles)
				;### Begin getting TEA substitution Table
				if(TEA_STbl[HKey.kId] == "")	{	;Checks if TEA substitution table exists for HashKey
					u:=0,v:=0
					LHash:=Array()
					Loop 256	;Builds substitution Table
						index:=A_Index - 1,this.TEA(u,v,HKey),	LHash[index]:=(u<<32) | v
					If(!HKey.onetime_use)
						TEA_STbl[HKey.kId]:=LHash ;Caches Substitution table for later use.
				}
				else	;Gets substitution Table from cache
					LHash:=TEA_STbl[HKey.kId]
				;### Begin Calculating Hash
				if(HKey.bit == 64)		{ ;Use 64bit TEA algorithm?
					R:=0
					Loop Parse, value ;Loop converts each character to a numeric value and adds characters together
						R := (R << 8) + Asc(A_LoopField) ^ LHASH[(R >> 56) & 255]
					return this.Hex8(R>>32) . this.Hex8(R) ;Converts result number into 2 8 character long hex strings then concatenates
				}	
				S:=0,R:=-1 ;Use 128bit TEA Algorithm
				Loop Parse, value	;Loop converts each character to a numeric value and adds characters together
					R := (R << 8) + Asc(A_LoopField) ^ LHASH[(R >> 56) & 255],	S := (S << 8) + Asc(A_LoopField) - LHASH[(S >> 56) & 255]
				return this.Hex8(R>>32) . this.Hex8(R) . this.Hex8(S>>32) . this.Hex8(S)	;Converts result numbers into 4 8 character long hex strings then concatenates
		}
		/*
		
		
		*/
		MD5( ByRef Val,byref Len=0 ) { ; www.autohotkey.com/forum/viewtopic.php?p=275910#275910
			VarSetCapacity( MD5_CTX,104,0 ), DllCall( "advapi32\MD5Init", Str,MD5_CTX )
			DllCall( "advapi32\MD5Update", Str,MD5_CTX, Str,Val, UInt,Len ? Len : StrLen(Val) )
			DllCall( "advapi32\MD5Final", Str,MD5_CTX )
			Loop % StrLen( Hex:="123456789ABCDEF0" )
				N := NumGet( MD5_CTX,87+A_Index,"Char"), MD5 .= SubStr(Hex,N>>4,1) . SubStr(Hex,N&15,1)
			Return MD5
		}
		/*
			Method - Hex8(i)
			description - Converts an integer into hex then truncates it to 8 characters
			Return - 8 character hex string
			Parameters :
			i - Integer to be converted
		*/
		Hex8(i) {
			SetFormat Integer, Hex
			i:= 0x100000000 | i & 0xFFFFFFFF ; mask LS word, set bit32 for leading 0's --> hex
			SetFormat Integer, D
			Return SubStr(i,-7)              ; 8 LS digits = 32 unsigned bits
		}
		/*
			Method - TEA(ByRef y,ByRef z, Key)
			Description - Tiny Encryption Algorithm. This function is used by the hash function to create substitution tables
			Return - None
		*/
		TEA(ByRef y,ByRef z, Key) {
			s := 0, d := 0x9E3779B9
			Loop % Key.cycles
			{
				y := 0xFFFFFFFF & (y + ((z << 4 ^ z >> 5) + z  ^  s + Key["k" . s & Key.kNum]))
				s := 0xFFFFFFFF & (s + d)
				z := 0xFFFFFFFF & (z + ((y << 4 ^ y >> 5) + y  ^  s + Key["k" . s >> 11 & Key.kNum]))
			}
		}
				/*
			Class - HashKey(hash_bit:=64,cycles:=64,Keys*)
			description - HashKey for use by the hash function or a Hashtable.
			Parameters :
			hash_bit - How many bits the hash should be. 64 or 128. The Higher bitrate reduces the chances of a hash collision however requires more processing.
			cycles - The cycles the encryption algorithm should go through. Recommended for TEA is 32, however fewer can be used if security is not an issue.
			onetime_use - Tells Hash function whether it should expect to see this Hashkey again.  0 - Tells it to cache the substitution table.
			Keys* - The Key numbers to be used. If omitted or non-numbers are provided then random numbers will be generated.
		*/
		Class HashKey extends AHK.Lang.Class.Meta.Call_Construct{
			__New(hash_bit:=64,cycles:=0,onetime_use:=0,Keys*)	{
				if(hash_bit == 64 or hash_bit == 128){ ; Should use Tea algorithm?
					this.bit:=hash_bit,this.cycles:=cycles?cycles:32,this.kId:=this.cycles,this.onetime_use:=onetime_use,this.kNum:=keys.length() - 1
					if(keys.length() == 0)	{ ;No Keys were input so Keys are randomly generated
						Loop, 4
						{
							Random, key
							this["k"	A_Index -1]:=Round(key), this.kId.="_" Round(key)
						}
						this.kNum:=3
					}
					else	{ ;Keys were in input so they are formatted for Hash function
						loop, % keys.Length()
						{
							key:=keys[A_Index]
							if key is not number
								Random,key
							this["k" A_Index - 1]:=Round(key),	this.kId.="_" Round(key)
						}
					}
				}
				else ;Use MD5 Algorithm
					this.bit:=hash_bit,this.cycles:=cycles
			}
		}
		;#### Functions Related to Hashtable
		/*
			__New(Store_Key:=0,Key:="")
			Description - Constructor for a Hashtable
			Return - Void
			Parameters :
			Store_Key - Tells whether to store original key values (uses more memory).
			HKey - HashKey to be used by the Hashtable
		*/
		__New(HKey:="",Store_Key:=0)	{
			this["__#store_key"]:=Store_Key,this.setHashKey(HKey)
		}
		/*
			Method - setHashKey(HKey)
			Description - Sets the HashKey to be used by the Hashtable. if store key is not enabled Hashtable must be empty.
			Return - Void
			Parameters :
			HKey - HashKey to be used by table
		*/
		setHashKey(HKey)	{
			if(HKey.__Class == this.__Class ".Hashkey")			{
			if(this["__#store_key"])	{
				temp_table:=this.Remove(this.Keys(0)*)
				this["__#key"]:=HKey
				Keys:=temp_table.Keys()
				hKeys:=temp_table.Keys(0)
				Loop % Keys.Length()
					this.put(Keys[A_Index],temp_table.get(hKeys[A_Index]))
			}
			else
				this["__#key"]:=this.isEmpty()?HKey:this["__#key"]
			}
		}
		/*
			Method - Put(Key_Vals*)
			Description - Puts Key Values into Hashtable
			Return - a Hashtable containing the old Values for the Keys
			Parameters :
			Key_Vals* - Key then Value to be put into Hashtable
			
			Example: example.put(Key1,Value1,Key2,Value2)
		*/
		Put(Key_Vals*)	{
			Output:=new this(this["__#store_key"],this["__#key"])
			loop, % Key_Vals.Length()
				if(mod(A_Index,2) == 1)
					key:=this.Table_Key(Key_Vals[A_Index],0),this["_" key]:=!this["__#store_key"]?"":Key_Vals[A_Index] == key?this["_" key]:Key_Vals[A_Index]
				else
					Output[key]:=this[key], this[key]:=Key_Vals[A_Index]
			return output
		}
		/*
			Method - putAll(Hashtable_or_Obj)
			Description - Inserts a Hashtable into this Hashtable. Hashkeys must match unless store_key is enabled on the table being inserted. Also copies over non-Hashtable related values.
			Return - Boolean whether Hashtable was inserted.
			Parameters :
			Hashtable_or_Obj - The Hashtable or Object to be inserted into this Hashtable. 
		*/
		putAll(Hashtable_or_Obj)		{
			hash_insert:=0
			if(Hashtable_or_Obj.__Class == this.__Class)	{ ;Checks if Input is Hashtable
				if(Hashtable_or_Obj["__#key"] == this["__#key"])	{	;Checks if keys match
					hash_insert:=1
					for key, value in Hashtable_or_Obj
						this[key]:=value
				}
				else if(Hashtable_or_Obj["__#store_key"]){	;Checks if Input has stored keys.
					hash_insert:=1
					Keys:=Hashtable_or_Obj.Keys()
					hKeys:=Hashtable_or_Obj.Keys(0)
					Loop % Keys.Length()
						this.put(Keys[A_Index],Hashtable_or_Obj.get(hKeys[A_Index]))
				}
			}
			for key, value in Hashtable_or_Obj	;Copies over non hashtable specific Values
				if(key != "__#key" or key != "__#store_key" or Instr(key,"#") != 1 or Instr(key,"_#") != 1)
					this[key]:=value
			return hash_insert
		}
		/*
			Method - Get(Keys*)
			Description - Returns the value to which the specified key/s are mapped, or null if this map contains no mapping for the key.
			Return - Value mapped to key. If multiple keys were input then an array of the values.
			Parameters :
			Keys* - Key/s to be retrieve out of the Hashtable. if Multiple keys are input then the output is an array of the values.
		*/
		Get(Keys*)	{
			if(Keys.length() <= 1)
				return this.Table_Key(Keys[1],1)
			Output:=Array()
			Loop % Keys.Length()
				Output.push(this.Table_Key(Keys[A_Index],1))
			return Output
		}
		/*
			Method - Remove(Keys*)
			Description - Removes the key/s (and their corresponding value) from this Hashtable.
			Return - A Hashtable of the removed Keys
			Parameters :
			Keys* - Keys to be removed
		*/
		Remove(Keys*)	{
			Output:=new this(this["__#store_key"],this["__#key"])
			Loop, % Keys.Length()
				key:=this.Table_Key(Keys[A_Index],0),Output[key]:=this[key],Output["_" key]:=this["_" key],this[key]:="",this["_" key]:=""
			return Output
		}
		/*
			Method - clear()
			Description - Clears this hashtable so that it contains no keys.
			Return - void
		*/
		clear()	{
			For key, value in this
				this[key]:=Instr(key,"#") == 1 or Instr(key,"_#") == 1?"":this[key]
		}
		/*
			Method - Keys(original_key:=1)
			Description - Creates an Array of the keys in the Hashtable
			Return - An array of the keys in the Hashtable
			Parameters:
			original_key - boolean whether to return original key or just the hash assuming store_key is enabled. (If original key is used and the key is going to be later updated in the hashtable the hash calculation will need to be repeated)
		*/
		Keys(original_key:=1)	{
			Output:=Array()
			key_prefix:=this["__#store_key"] and original_key?"_#":"#"
			For key, value in this
				if(Instr(key,key_prefix) == 1)
					Output.push(this["__#store_key"] and original_key? value : key)
			return output
		}
		/*
			Method - Values()
			Description - Creates an Array of the values in the Hashtable
			Return - An array of the values in the Hashtable
		*/
		Values()	{
			Output:=Array()
			For key, value in this
				if(Instr(key,"#") == 1)
					Output.push(value)
			return output
		}
		/*
			Method - ContainsKey(Key)
			Description - Tests if the specified object is a key in this hashtable.
			Return - Boolean
			Parameters :
			Key - Key to check
		*/
		ContainsKey(Key)	{
			return this.Table_Key(Key,1) != ""
		}
		/*
			Method - ContainsValue(Value)
			Description - Tests if this hashtable maps one or more keys to this value.
			Return - Key that holds the value or blank if not found
			Parameters :
			Value - Value to check
			original_key - boolean whether to return original key or just the hash assuming store_key is enabled. (If original key is used then if the key is going to be updated in the hashtable the hash calculation will need to be repeated)
		*/
		ContainsValue(Value,original_key:=1)	{
			For key, tvalue in this
				if(Instr(key,"#") == 1 and tvalue == Value)
					return this["__#store_key"] and original_key? this["_" key] : key
		}
		/*
			Method - Size()
			Description - Returns the number of keys in this hashtable.
			Return - Integer
		*/
		Size()	{
			Output:=0
			For key, value in this
				Output+=Instr(key,"#") == 1
			return Output
		}
		/*
			Method - isEmpty()
			Description - Tests if this hashtable maps no keys to values.
			Return - Boolean
		*/
		isEmpty()		{
			For key, value in this
				if(Instr(key,"#") == 1 or Instr(key,"_#") == 1)
					return 1
			return 0
		}
		/*
			Method - toString()
			Description - Returns this object in JSON format
			Return - String
		*/
		toString()		{
			return this.JSON.Dump(this)
		}
		/*
			Method - Table_Key(Key,return_val:=0)
			Description - Returns the table formatted key for a key, or its value.
			Return - Table Key or Value associated with inputted key
			
			Key - Key to be formatted
			return_val - Boolean whether to return formatted key, or key's value
		*/
		Table_Key(Key,return_val:=0)		{
			key:=Instr(key,"#") == 1 ? key : "#" this.call("",key,this["__#key"])
			return return_val?this[key]:key
		}
	}
	