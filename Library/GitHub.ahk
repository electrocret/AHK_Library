Class Github extends Lib.Obj.Meta.Call{
	static github_API:="https://api.github.com/"
	static github:="https://github.com/"
	Call(self,Call:="")	{
		static cache:=new Lib.Hash(),requestor:= ComObjCreate("WinHttp.WinHttpRequest.5.1"),API_Token:=Lib.config(this,"API_Token")
		call:=isobject(self)?Call:self
		if(instr(Call,this.github_API) != 1)		{	;Validates API call
			message:="Invalid API call. `nAPI Call must start with " this.github_API "`nCall Received: '" Call "'"
			MsgBox, 16, GitHub API - Error, %message%
			return
		}
		TKey:=cache.Table_Key(Call)
		cvalue:=cache.get(TKey)	;Checks if Call is in Cache
		if(cvalue != "")	
			return cvalue
		if(API_Token == "" and !Lib.config(this,"SkipToken",,0))	{	;Checks for API Authentication token
			Prompt:="To raise the number of requests per hour to Github, a Personal access token is needed. Without the token you can only make 60 requests per hour versus 5000 requests per hour.`n`nTo generate a Personal access token:`n1. Login to github.com`n2. Go to Settings`n3. Under 'Developer settings' select 'Personal access token'`n4. Select 'Generate new token'`n5. Enter a 'Harmony' as your description`n6. Check the 'public_repo' scope`n7. Select 'Generate token'`n8. Copy token into this window and select OK"
			InputBox, Outputvar , GitHub API - Personal access token, %Prompt%,,,360
			if(Errorlevel)	{
				MsgBox, 36, GitHub API - Personal access token, Would you like to be prompted for a Personal access token next time the GitHub API is called?
				ifmsgbox, no
					Lib.config(this,"SkipToken",1)
			}
			else
				API_Token:=Outputvar,Lib.config(this,"API_Token",API_Token)
		}
		requestor.Open("GET", API_Token ==""?Call:Call "?access_token=" API_Token, true)	;Build API Request
		requestor.Send()	;Send API Request
		requestor.WaitForResponse()	;Wait for API Response
		if(requestor.status == 200)		{	;Validate API response
			response:=Lib.obj.Json.Load(requestor.ResponseText)	;Convert API Response to object
			if(instr(response.message,"API rate limit exceeded"))	{	;Check API response for call rate limit notification
				if(instr(response.message,"Authenticated requests get a higher rate limit"))	{ ;Check API response for unauthenticated call rate limit notification
					MsgBox, 20, GitHub API - Unauthenticated call limit reached, You have reached the call limit for an unauthenticated user (60 calls/hour). `nWould you like to provide a Personal access token to authenticate your requests? (This will raise your call limit to 5000 calls/hour)`n`nIf you are receiving this message and have provided a Personal access token, it may be incorrect.
					ifmsgbox, yes
					{
						Lib.config(this,"SkipToken","","",1)
						return this.Call(Call)
					}
					else
						return
				}
				else		{
					MsgBox, 16, GitHub API - Call limit reached, You have reached your authenticated call limit (5000 calls/hour).
					return
				}
			}
			cache.put(TKey,response)
			return response
		}
		else	{ ;Bad API response
			message:="GitHub gave a bad response. `nStatus: " requestor.status "`nStatus Text: " requestor.statustext
			MsgBox, 16, GitHub API - Bad response,%message%
		}
	}
	Info(Keys*)	{
		info:=this.call(this.github_API this.info_id)
		Loop % Keys.Length()
		{
			if(subcall != "")	{
				if(instr(subcall,"{"))
					subcall:=Lib.String.Substr.Strip.byChar(subcall,"{","}",Keys[A_Index])
				if(!instr(subcall,"{"))
					info:=this.call(subcall),subcall:=""
			}
			else if(info[Keys[A_Index]] != "")
				info:=Info[Keys[A_Index]]
			else if(info[Keys[A_Index] "_url"] != "")
				subcall:=info[Keys[A_Index] "_url"]
			else
				return
		}
		if(subcall != "")
			info:=this.call(subcall)
		return info
	}
	Class Repository extends Lib.GitHub{
		__New(Repository_Ref,Repository_Author:="",Repository_Name:="")		{
			if(Repository_Author != "" and Repository_Name != "")
				this.info_id:="repos/" Repository_Author "/" Repository_Name
			else		{
				if(instr(Repository_Ref,"repos/") == 1)	;Info_ID is provided
					this.info_id:=Repository_Ref
				if(Instr(Repository_Ref,this.github) == 1)	;Github URL is provided
					this.info_id:="repos/" Lib.String.Substr.Delimited(Repository_Ref,"/",3,2)
				if(Instr(Repository_Ref,this.github_API) == 1)	;Github API URL is provided
					this.info_id:=Lib.String.Substr.Delimited(Repository_Ref,"/",3,3)
			}
		}
	}
	Class Author extends Lib.GitHub{
		__New(Author_Ref){
				if(instr(Repository_Ref,"users/") == 1)	;Info_ID is provided
					this.info_id:=Repository_Ref
				if(Instr(Repository_Ref,this.github) == 1)	;Github URL is provided
					this.info_id:="users/" Lib.String.Substr.Delimited(Repository_Ref,"/",3,1)
				if(Instr(Repository_Ref,this.github_API) == 1)	;Github API URL is provided
					this.info_id:=Lib.String.Substr.Delimited(Repository_Ref,"/",3,2)
		}
	}
	Class Commit extends Lib.GitHub{
		__New(Commit_Ref,Repository_Author:="",Repository_Name:="",Commit_Sha:="")
		{
			if(Repository_Author != "" and Repository_Name != "" and Commit_Sha != "")
				this.info_id:="repos/" Repository_Author "/" Repository_Name "/commits/" Commit_Sha
			else		{
				if(instr(Commit_Ref,"repos/") == 1 and instr(Commit_Ref, "/commits/"))	;Info_ID is provided
					this.info_id:=Commit_Ref
				if(Instr(Commit_Ref,this.github) == 1)	;Github URL is provided
					this.info_id:="repos/" Lib.String.Substr.Delimited(Commit_Ref,"/",3,2) "/commits/" Lib.String.Substr.Delimited(Commit_Ref,"/",6,1)
				if(Instr(Commit_Ref,this.github_API) == 1)	;Github API URL is provided
					this.info_id:=Lib.String.Substr.Delimited(Commit_Ref,"/",3,5)
			}
		
		}
	
	}
}