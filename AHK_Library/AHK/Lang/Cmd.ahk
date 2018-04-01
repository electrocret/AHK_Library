Class Cmd {
	
	Class File{
		Append(byref Text:="",byref Filename:="",byref Encoding:="")	{
			FileAppend, %Text%,%Filename%,%Encoding%
			return ErrorLevel
		}
		Copy(byref SourcePattern,byref DestPattern,byref Flag:=0){
			FileCopy,%SourcePattern%,%DestPattern%,%Flag%
			return ErrorLevel
		}
		CopyDir(byref Source,byref Dest,byref Flag:=0){
			FileCopyDir,%Source%,%Dest%,%Flag%
			return ErrorLevel
		}
		CreateDir(byref DirName){
			FileCreateDir,%DirName%
			return ErrorLevel
		}
		CreateShortcut(byref Target,byref  LinkFile ,byref  WorkingDir:="",byref  Args:="",byref  Description:="",byref  IconFile:="",byref  ShortcutKey:="", byref IconNumber:="", byref RunState:="")		{
			FileCreateShortcut, %Target%, %LinkFile% , %WorkingDir%, %Args%, %Description%, %IconFile%, %ShortcutKey%, %IconNumber%, %RunState%
			return ErrorLevel
		}
		Delete(byref FilePattern){
			FileDelete, %FilePattern%
			return ErrorLevel
		}
		Encoding(byref Encoding:=""){
			FileEncoding, %Encoding%
			return ErrorLevel
		}
		GetShortcut(byref LinkFile ,byref OutTarget:="",byref OutDir:="",byref OutArgs:="", byref OutDescription:="",byref OutIcon:="",byref OutIconNum:="",byref OutRunState:="")	{
			FileGetShortcut, %LinkFile% , OutTarget, OutDir, OutArgs, OutDescription, OutIcon, OutIconNum, OutRunState
			return ErrorLevel
		}
		GetSize(byref OutputVar, byref FileName:="",byref Units:=""){
			FileGetSize, OutputVar, %FileName%,%Units%
			return ErrorLevel
		}
		GetTime(byref OutputVar, byref FileName:="",byref WhichTime:="M"){
			FileGetTime, OutputVar,%FileName%,%WhichTime%
			return ErrorLevel
		}
		GetVersion(byref OutputVar,byref FileName:=""){
			FileGetVersion, OutputVar,%FileName%
			return ErrorLevel
		}
		Move(byref SourcePattern,byref DestPattern,byref Flag:=0){
			FileMove, %SourcePattern%,%DestPattern%,%Flag%
			return ErrorLevel
		}
		MoveDir(byref Source,byref Dest, byref Flag:=0){
			FileMoveDir, %Source%,%Dest%,%Flag%
			return ErrorLevel
		}
		Read(byref OutputVar,byref FileName){
			Fileread, OutputVar,%FileName%
			return ErrorLevel
		}
		ReadLine(byref OutputVar,byref Filename,byref LineNum){
			FIleReadLine, OutputVar,%FileName%,%LineNum%
			return ErrorLevel
		}
		Recycle(byref FilePattern){
			FileRecycle, %FilePattern%
			return ErrorLevel
		}
		RecycleEmpty(byref DriveLetter:=""){
			FileRecycleEmpty, %DriveLetter%
			return ErrorLevel
		}
		RemoveDir(byref DirName,byref Recurse:=0){
			FileRemoveDIr,%DirName%,%Recurse%
			return ErrorLevel
		}
		SelectFile(byref OutputVar,byref Options:=0,byref RootDir_FileName:="",byref Prompt:="Select File",byref Filter:="*.*"){
			FileSelectFile, OutputVar, %Options%,%RootDir_FileName%,%Prompt%,%Filter%
			return ErrorLevel
		}
		SelectFolder(byref Output,byref StartingFolder:="",byref Options:=1,byref Prompt:="Select Folder"){
			FileSelectFolder, OutputVar, %StartingFolder%,%Options%,%Prompt%
			return ErrorLevel
		}
		SetAttrib(byref Attributes,byref FilePattern:="",byref OperateOnFolders:=0,byref Recurse:=0){
			FileSetAttrib %Attributes%,%FilePattern%,%OperateOnFolders%,%Recurse%
			return ErrorLevel
		}
		SetTime(byref YYYYMMDDHH24MISS:="",byref FilePattern:="",byref WhichTime:="M",byref OperateOnFolders:=0,byref Recurse:=0){
			FileSetTime, %YYYYMMDDHH24MISS%,%FilePattern%,%WhichTime%,%OperateOnFolders%,%Recurse%
			return ErrorLevel
		}
	}
	Class Control extends AHK.Lang.Class.Meta.Call_Functor {
		Call(byref self, byref Cmd, byref Value:="",byref Contrl:="",byref WinTitle:="",byref WinText:="",byref ExcludeTitle:="",byref ExcludeText:=""){
			if(WinText == "")
			Control, %Cmd%,%Value%,%Contrl%,%WinTitle%,,%ExcludeTitle%,%ExcludeText%
			else
			Control, %Cmd%,%Value%,%Contrl%,%WinTitle%,%WinText%,%ExcludeTitle%,%ExcludeText%
			return ErrorLevel
		}
		
	}
	
	
	
	
}