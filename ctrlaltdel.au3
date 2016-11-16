#include <inet.au3>
#include <string.au3>

$url = 'http://www.cad-comic.com/cad/'
Global $yr = 2006
Global $mo = 06
Global $day = 04
Global $date = $yr & $mo & $day
$i = 1

DirCreate(@ScriptDir & "\comics")

While $yr < @YEAR
	TraySetToolTip("CtrlAltDel" & @CRLF & $i & "...")
	if (_SizeToMB(DirGetSize(@ScriptDir & "\comics")) > 500) then Exit
	$source = _INetGetSource($url & $date, True)
	If StringInStr($source, "404 - Page not found") Then
		ConsoleWrite($date & ": Skipping [404]" & @CRLF)
	if $day >= 31 Then
		$day = 01
		if $mo >= 12 Then
			$mo = 01
			$yr = $yr + 1
		Else
			$mo = $mo + 1
		EndIf
	Else
		$day = $day + 1
	EndIf
	$day = StringFormat ( "%.2d" , $day)
	$mo = StringFormat ( "%.2d" , $mo)
	$date = $yr & $mo & $day
		$i = $i + 1
	Else
		If StringInStr($source, '"http://cdn2.cad-comic') Then
			$data = _StringBetween($source, '>Next</a></div> <img', 'alt="')
			If IsArray($data) Then
				$img = _StringBetween($data[0], 'http://', '"')
				If IsArray($img) Then
					$name = _StringBetween($img[0], "comics/", ".")
					If IsArray($name) Then
						$ext = StringRight($img[0], 4)
						$name[0] = StringReplace($name[0], "/", " ")
						$name[0] = StringReplace($name[0], "\", " ")
						$name[0] = StringReplace($name[0], "&", "")
						$name[0] = StringReplace($name[0], "*", "")
						$name[0] = StringReplace($name[0], "?", "")
						$name[0] = StringReplace($name[0], ")", "")
						$name[0] = StringReplace($name[0], "(", "")
						If Not FileExists(@ScriptDir & "\comics\" & $i & " " & $name[0] & $ext) Then
							ConsoleWrite($date & ": " & $name[0] & $ext & @CRLF)
							InetGet('http://' & $img[0], @ScriptDir & "\comics\" & $i & " " & $name[0] & $ext, 3, 0)
						Else
							ConsoleWrite($date & ": Skipping [DUPE]" & @CRLF)
						EndIf
					Else
						ConsoleWrite($date & ": Skipping [NAME]" & @CRLF)
					EndIf
				EndIf
			EndIf
		Else
			ConsoleWrite($date & ": Skipping [INVALID]" & @CRLF)
		EndIf
	EndIf
	if $day >= 31 Then
		$day = 01
		if $mo >= 12 Then
			$mo = 01
			$yr = $yr + 1
		Else
			$mo = $mo + 1
		EndIf
	Else
		$day = $day + 1
	EndIf
	$day = StringFormat ( "%.2d" , $day)
	$mo = StringFormat ( "%.2d" , $mo)
	$date = $yr & $mo & $day
	$i = $i + 1
	;sleep(Random(1000,2400,1))
WEnd

Func _SizeToMB ($s)
	$Equal = $s / 1048576
	$Round = Round ($Equal, '2')
	Return $Round
EndFunc