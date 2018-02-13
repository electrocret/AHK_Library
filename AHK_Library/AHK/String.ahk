Class String{
	occurrence_count(String,Char)	{
			counter:=1
			while(instr(String,isobject(Char)?Char.char:Char,,,counter))
				counter++
			return counter
	}
	Class Index extends AHK.Lang.Class.Meta.Call_Construct{
		__New(index_num,index_str,search_str:="",CaseSensitive:=false,StartingPos:=1,Occurrence:=1)		{
			if index_num is digit
				this.Index:=index_num,this.char:=isobject(index_str)?index_str[1]:index_str,return
			if(isobject(index_str))	{
				search_i:=0
				Loop, % index_str.Length()
				{
					ts_i:=Instr(search_str,index_str[A_Index],CaseSensitive,isobject(StartingPos)?StartingPos.Index + StrLen(StartingPos.Char):StartingPos,Occurrence)
					if((search_i == 0 and ts_i != 0) or (ts_i <= search_i and ts_i != 0))
						search_c:=ts_i < search_i?index_str[A_Index]:StrLen(index_str[A_Index]) > StrLen(search_c)?index_str[A_Index]:search_c, search_i:=ts_i
				}
			}
			else
				search_i:=Instr(search_str,index_str,CaseSensitive,isobject(StartingPos)?StartingPos.Index + StrLen(StartingPos.Char):StartingPos,Occurrence),search_c:=index_str
			this.char:=search_c,this.index:=search_i
		}
	}
	Instr(Haystack,Needle,CaseSensititve:=false,StartingPos:=1,Occurrence:=1)	{
		Index:=new Ahk.String.Index("",Needle,Haystack,CaseSensititve,StartingPos,Occurrence)
		return Index.Index != 0?Index:""
	}
	Class Substr extends AHK.Lang.Class.Meta.Call_Functor{
		Call(self,String,StartingPos:=1,Length:="")		{
			StartingPos:=isobject(StartingPos)?StartingPos.Index:StartingPos
			return substr(String,StartingPos,isobject(Length)?Length.Index - StartingPos:Length)
		}
		Trim(String,Start_Index:=1,End_Index:=""){
			return substr(String	,isobject(Start_Index)?Start_Index.Index+StrLen(Start_Index.char):Start_Index	,isobject(End_Index) and isobject(Start_Index)?End_Index.index-(Start_Index.Index+StrLen(Start_Index.char)):isobject(Start_Index) and !isobject(End_Index)?End_Index-(Start_Index.Index+StrLen(Start_Index.char)):!isobject(Start_Index) and isobject(End_Index)?End_Index.Index-Start_Index:End_Index-Start_Index)
		}
		Delimited(String,delimiter:=",",Start_delim:=1,Value_count:=1,StartingPos:=1)		{
			return this.trim(String,Ahk.String.InStr(String,delimiter,true,StartingPos,Start_Delim),Ahk.String.InStr(String,delimiter,true,StartingPos,Start_Delim + Value_count))
		}
		Class Strip extends AHK.Lang.Class.Meta.Call_Functor{
			Call(self,String,Start_Index,End_Index,Replace:="")		{
				Start_Index:=isobject(Start_Index)?Start_Index.index:Start_Index
				End_Char:=isobject(End_Index)?End_Index.char:""
				End_Index:=isobject(End_Index)?End_Index.index:End_Index
				String:=End_Index == 0 ? substr(String,1,Start_Index-1) Replace: substr(String,1,Start_Index-1) Replace substr(String,End_Index + strlen(End_Char))
				return String
			}
			bychar(byref String, Start_Char,End_Char,Replace:="",Strip_All:=0,byref Relative_String:="")	{
				s_start:=Ahk.String.inStr(String,Start_Char)
				if(s_start.index != 0)	{
					s_end:=Ahk.String.inStr(String,End_Char,,s_start)
					if(Relative_String != "")
						Relative_String:=this.call("",Relative_String,s_start,s_end,Replace)
					String:=this.call("",String,s_start,s_end,Replace)
					if(Strip_All)
						this.bychar(String,Start_Char,End_Char,Strip_All,Relative_String,Replace)
				}
				return String
			}
		}
	}
}