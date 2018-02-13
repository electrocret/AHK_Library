Class Linear extends Ahk.obj.Array.Generic{
		/*
			Clone(Arr*)
			Creates a clone of the array with meta values absent.
		*/
		Clone(Arr*)	{
				For i, sArr in Arr {
					tOut:=Array()
					For index,value in sArr
						if(!Ahk.obj.isMetaInfo(index,value))
							tOut.push(value)
					Arr[i]:=tOut
				}
				return AHK.Helpers.Variadic_RTN_FMT_Optional(Arr)
		}

		join(delim:=",",Arr*) {
			AHK.Helpers.Variadic_PARAM_DEF_VAL(Arr,",",delim)
			For i,sArr in Arr {
				For si,Val in sArr
					Out.=delim (isobject(Val)?Ahk.Obj.Array.ToString(Val):Val)
				Arr[i]:=SubStr(Out,StrLen(delim) + 1), Out:=""
			}
			return AHK.Helpers.Variadic_RTN_FMT_Optional(Arr)
		}
		/*
		 Shuffle(byref Arr*)
		 Shuffles the index of values in array
		*/
		Shuffle(byref Arr*)	{
			SetFormat, IntegerFast, d
			for i, sArr in Arr{
				Output:=Array()
				While(sArr.length() > 0)	{
					Random ran,1,sArr.Length()
					Output.push(sArr.RemoveAt(ran))
				}
				Arr[i]:=Output
			}
			return AHK.Helpers.Variadic_RTN_FMT_Optional(Arr)
		}
		/*
		Reverse(byref Arr*)
		Reverses the order of the values in the Array.
		*/
		Reverse(byref Arr*){
		
			for i, sArr in Arr{
				Output:=Array()
				While(sArr.Length() > 0)
					Output.push(sArr.RemoveAt(1))
				Arr[i]:=Output
			}
			return Arr
		}
		/*
		Merge(byref Arr*)
		Merges all linear arrays into a single array.
		*/
		Merge(byref Arr*)	{
			Output:=Array()
			Loop % Arr.Length()
				Output.push(Arr[A_Index]*)
			return Arr[1]:=Output
		}
		/*
			Split(byref Split_Index, Arr*)
			Splits an array into 2 at a specified index. Output is a subarray with [1] as everything before the index and [2] is the index value and everything after.
		*/
		Split(Split_Index,byref Arr*) {
			Output:=Array()
			For i,sArr in Arr	{
				Output[i]:=[sArr.clone(),sArr.Clone()]
				Output[i][1].removeAt(Split_Index,sArr.Length())
				Output[i][2].removeAt(1,Split_Index - 1)
			}
			return AHK.Helpers.Variadic_RTN_FMT_Optional(Output)
		}

	/*
		removeAll(value,Arr*)
		Returns Array with all keys with specified value removed.
	*/
		removeAll(value, Arr*)		{
			For i,sArr in Arr		{
				rval_index:=""
				Loop % sArr.length()
					if(sArr[A_Index] == value)
						rval_index.="|" A_Index
				StringTrimLeft, Purge,Purge,1
				Sort rval_index, N R D|
				Loop, Parse, rval_index ,|
					Arr[i].removeAt(A_LoopField)
			}
			return AHK.Helpers.Variadic_RTN_FMT_Optional(Arr)
		}
	/*
		toString(Arr*)
		Returns the Array in an AHK compatible string format.
	*/
		toString(Arr*){
			for i,sArr in Arr	{
				Loop % sArr.length()
					if(!Ahk.obj.isMetaInfo(A_Index,sArr[A_Index]))
						sOut.= ", " Ahk.Obj.Array.toString(sArr[A_Index])
				StringTrimLeft,sOut,sOut,1
				Arr[i]:="[" sOut "]"
			}
			return AHK.Helpers.Variadic_RTN_FMT_Optional(Arr)
		}
	}