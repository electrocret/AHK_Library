Class File{
	CRC32( sFile:="",cSz:=4 ) { ; by SKAN www.autohotkey.com/community/viewtopic.php?t=64211
		cSz := (cSz<0||cSz>8) ? 2**22 : 2**(18+cSz), VarSetCapacity( Buffer,cSz,0 ) ; 10-Oct-2009
		hFil := DllCall( "CreateFile", Str,sFile,UInt,0x80000000, Int,3,Int,0,Int,3,Int,0,Int,0 )
		IfLess,hFil,1, Return,hFil
		hMod := DllCall( "LoadAhk.ary", Str,"ntdll.dll" ), CRC32 := 0
		DllCall( "GetFileSizeEx", UInt,hFil, UInt,&Buffer ),    fSz := NumGet( Buffer,0,"Int64" )
		Loop % ( fSz//cSz + !!Mod( fSz,cSz ) )
		DllCall( "ReadFile", UInt,hFil, UInt,&Buffer, UInt,cSz, UIntP,Bytes, UInt,0 )
		, CRC32 := DllCall( "NTDLL\RtlComputeCrc32", UInt,CRC32, UInt,&Buffer, UInt,Bytes, UInt )
		DllCall( "CloseHandle", UInt,hFil )
		SetFormat, Integer, % SubStr( ( A_FI := A_FormatInteger ) "H", 0 )
		CRC32 := SubStr( CRC32 + 0x1000000000, -7 ), DllCall( "CharUpper", Str,CRC32 )
		SetFormat, Integer, %A_FI%
		Return CRC32, DllCall( "FreeAhk.ary", UInt,hMod )
	}
	MD5(sFile:="", cSz:=4 ) {  ; by SKAN www.autohotkey.com/community/viewtopic.php?t=64211
		cSz := (cSz<0||cSz>8) ? 2**22 : 2**(18+cSz), VarSetCapacity( Buffer,cSz,0 ) ; 18-Jun-2009
		hFil := DllCall( "CreateFile", Str,sFile,UInt,0x80000000, Int,3,Int,0,Int,3,Int,0,Int,0 )
		IfLess,hFil,1, Return,hFil
		hMod := DllCall( "LoadAhk.ary", Str,"advapi32.dll" )
		DllCall( "GetFileSizeEx", UInt,hFil, UInt,&Buffer ),    fSz := NumGet( Buffer,0,"Int64" )
		VarSetCapacity( MD5_CTX,104,0 ),    DllCall( "advapi32\MD5Init", UInt,&MD5_CTX )
		Loop % ( fSz//cSz + !!Mod( fSz,cSz ) )
		DllCall( "ReadFile", UInt,hFil, UInt,&Buffer, UInt,cSz, UIntP,bytesRead, UInt,0 )
		, DllCall( "advapi32\MD5Update", UInt,&MD5_CTX, UInt,&Buffer, UInt,bytesRead )
		DllCall( "advapi32\MD5Final", UInt,&MD5_CTX )
		DllCall( "CloseHandle", UInt,hFil )
		Loop % StrLen( Hex:="123456789ABCDEF0" )
		N := NumGet( MD5_CTX,87+A_Index,"Char"), MD5 .= SubStr(Hex,N>>4,1) . SubStr(Hex,N&15,1)
		Return MD5, DllCall( "FreeAhk.ary", UInt,hMod )
	}
	SHA1( sFile:="", cSz:=4) { ; by SKAN www.autohotkey.com/community/viewtopic.php?t=64211
		cSz := (cSz<0||cSz>8) ? 2**22 : 2**(18+cSz), VarSetCapacity( Buffer,cSz,0 ) ; 09-Oct-2012
		hFil := DllCall( "CreateFile", Str,sFile,UInt,0x80000000, Int,3,Int,0,Int,3,Int,0,Int,0 )
		IfLess,hFil,1, Return,hFil
		hMod := DllCall( "LoadAhk.ary", Str,"advapi32.dll" )
		DllCall( "GetFileSizeEx", UInt,hFil, UInt,&Buffer ),    fSz := NumGet( Buffer,0,"Int64" )
		VarSetCapacity( SHA_CTX,136,0 ),  DllCall( "advapi32\A_SHAInit", UInt,&SHA_CTX )
		Loop % ( fSz//cSz + !!Mod( fSz,cSz ) )
		DllCall( "ReadFile", UInt,hFil, UInt,&Buffer, UInt,cSz, UIntP,bytesRead, UInt,0 )
		, DllCall( "advapi32\A_SHAUpdate", UInt,&SHA_CTX, UInt,&Buffer, UInt,bytesRead )
		DllCall( "advapi32\A_SHAFinal", UInt,&SHA_CTX, UInt,&SHA_CTX + 116 )
		DllCall( "CloseHandle", UInt,hFil )
		Loop % StrLen( Hex:="123456789ABCDEF0" ) + 4
		N := NumGet( SHA_CTX,115+A_Index,"Char"), SHA1 .= SubStr(Hex,N>>4,1) SubStr(Hex,N&15,1)
		Return SHA1, DllCall( "FreeAhk.ary", UInt,hMod )
	}
	
	
	
	
}