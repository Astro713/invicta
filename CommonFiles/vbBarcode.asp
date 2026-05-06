<%
Function DrawBarcode ( oPDFObject, byVal strInput, byVal intStartX, byVal intStartY, byVal intWidth, byVal intHeight, byVal intScale )
  Dim strCode, intPos
  strCode = BarcodeEncode( strInput )
  Dim i
  'Select which algorithm to use
  If (Len(strInput) Mod 2)=0 And IsNumeric(strInput) Then
    'Code 128c is more efficient here
    strCode = code128c(strInput)
  Else
    strCode = code128b(strInput)
  End If
  If intWidth>0 Then
    intSize = 0
    For i = 1 to Len(strCode)
      intSize = intSize + Mid(strCode, i, 1)
    Next
    intScale = intWidth/intSize
  End If
  intPos = intStartX
  oPDFObject.save
  For i = 1 to Len(strCode)
    If (i Mod 2)=1 Then
      'Odd - a black space
      'oPDFObject.setcolor "fill","gray",0,0,0,0
      oPDFObject.rect intPos, intStartY, Mid(strCode, i, 1)*intScale, intHeight
      oPDFObject.fill
    Else
      'Even - a white space
    End If
    intPos = intPos + Mid(strCode, i, 1)*intScale
  Next
  oPDFObject.restore
End Function

'-------------------------------------------------
Function BarcodeWidth (byVal strInputCode )
  Dim intWidth, strCode, p
  intWidth = 0
  strCode = BarcodeEncode(strInputCode)
  For p = 1 to Len(strCode)
    intWidth = intWidth + Mid(strCode, p, 1)
  Next
  BarcodeWidth = intWidth
End Function

'-------------------------------------------------
Function BarcodeEncode (byVal strInputCode )
  'Select which algorithm to use
  Dim strCode
  If (Len(strInput) Mod 2)=0 And IsNumeric(strInput) Then
    'Code 128c is more efficient here
    strCode = code128c(strInput)
  Else
    strCode = code128b(strInput)
  End If
  BarcodeEncode = strCode 
End Function

'-------------------------------------------------
function code128c(ByVal InputString)
	Const MinValidAscii	= 32
	Const MaxValidAscii	= 126
	' Encode the input String
	InputString	= Trim(InputString)
	InvalidCharsFound	= vbFalse
	For CharPos	= 1 To Len(InputString)
		CharAscii		= Asc(Mid(InputString, CharPos, 1))
		if (CharAscii < MinValidAscii) OR (CharAscii > MaxValidAscii) Then
			CharAscii			= Asc("?")
			InvalidCharsFound	= vbTrue
		End if
	Next
  If Not IsNumeric(InputString) Then
    'Must be numeric
    InvalidCharsFound = vbTrue
  End If
  If (Len(InputString) Mod 2) <> 0 Then
    'Must be even number of digits
    InvalidCharsFound = vbTrue
  End If
  If InvalidCharsFound Then
    code128c = ""
    Exit Function
  End If
  Dim BarcodePattern(107)
BarcodePattern(0) = "212222"  ' SP 	SP 	00 
BarcodePattern(1) = "222122"  ' ! 	! 	01 
BarcodePattern(2) = "222221"  ' "	"	02 
BarcodePattern(3) = "121223"  ' # 	# 	03 
BarcodePattern(4) = "121322"  ' $ 	$ 	04 
BarcodePattern(5) = "131222"  ' % 	% 	05 
BarcodePattern(6) = "122213"  ' & 	& 	06 
BarcodePattern(7) = "122312"  ' ' 	' 	07 
BarcodePattern(8) = "132212"  ' ( 	( 	08 
BarcodePattern(9) = "221213"  ' ) 	) 	09 
BarcodePattern(10) = "221312"  ' * 	* 	10 
BarcodePattern(11) = "231212"  ' + 	+ 	11 
BarcodePattern(12) = "112232"  ' , 	, 	12 
BarcodePattern(13) = "122132"  ' - 	- 	13 
BarcodePattern(14) = "122231"  ' . 	. 	14 
BarcodePattern(15) = "113222"  ' / 	/ 	15 
BarcodePattern(16) = "123122"  ' 0 	0 	16 
BarcodePattern(17) = "123221"  ' 1 	1 	17 
BarcodePattern(18) = "223211"  ' 2 	2 	18 
BarcodePattern(19) = "221132"  ' 3 	3 	19 
BarcodePattern(20) = "221231"  ' 4 	4 	20 
BarcodePattern(21) = "213212"  ' 5 	5 	21 
BarcodePattern(22) = "223112"  ' 6 	6 	22 
BarcodePattern(23) = "312131"  ' 7 	7 	23 
BarcodePattern(24) = "311222"  ' 8 	8 	24 
BarcodePattern(25) = "321122"  ' 9 	9 	25 
BarcodePattern(26) = "321221"  ' : 	: 	26 
BarcodePattern(27) = "312212"  ' ; 	; 	27 
BarcodePattern(28) = "322112"  ' < 	< 	28 
BarcodePattern(29) = "322211"  ' = 	= 	29 
BarcodePattern(30) = "212123"  ' > 	> 	30 
BarcodePattern(31) = "212321"  ' ? 	? 	31 
BarcodePattern(32) = "232121"  ' @ 	@ 	32 
BarcodePattern(33) = "111323"  ' A 	A 	33 
BarcodePattern(34) = "131123"  ' B 	B 	34 
BarcodePattern(35) = "131321"  ' C 	C 	35 
BarcodePattern(36) = "112313"  ' D 	D 	36 
BarcodePattern(37) = "132113"  ' E 	E 	37 
BarcodePattern(38) = "132311"  ' F 	F 	38 
BarcodePattern(39) = "211313"  ' G 	G 	39 
BarcodePattern(40) = "231113"  ' H 	H 	40 
BarcodePattern(41) = "231311"  ' I 	I 	41 
BarcodePattern(42) = "112133"  ' J 	J 	42 
BarcodePattern(43) = "112331"  ' K 	K 	43 
BarcodePattern(44) = "132131"  ' L 	L 	44 
BarcodePattern(45) = "113123"  ' M 	M 	45 
BarcodePattern(46) = "113321"  ' N 	N 	46 
BarcodePattern(47) = "133121"  ' O 	O 	47 
BarcodePattern(48) = "313121"  ' P 	P 	48 
BarcodePattern(49) = "211331"  ' Q 	Q 	49 
BarcodePattern(50) = "231131"  ' R 	R 	50 
BarcodePattern(51) = "213113"  ' S 	S 	51 
BarcodePattern(52) = "213311"  ' T 	T 	52 
BarcodePattern(53) = "213131"  ' U 	U 	53 
BarcodePattern(54) = "311123"  ' V 	V 	54 
BarcodePattern(55) = "311321"  ' W 	W 	55 
BarcodePattern(56) = "331121"  ' X 	X 	56 
BarcodePattern(57) = "312113"  ' Y 	Y 	57 
BarcodePattern(58) = "312311"  ' Z 	Z 	58 
BarcodePattern(59) = "332111"  ' [ 	[ 	59 
BarcodePattern(60) = "314111"  ' \ 	\ 	60 
BarcodePattern(61) = "221411"  ' ] 	] 	61 
BarcodePattern(62) = "431111"  ' ^ 	^ 	62 
BarcodePattern(63) = "111224"  ' _ 	_ 	63 
BarcodePattern(64) = "111422"  ' NUL 	` 	64 
BarcodePattern(65) = "121124"  ' SOH 	a 	65 
BarcodePattern(66) = "121421"  ' STX 	b 	66 
BarcodePattern(67) = "141122"  ' ETX 	c 	67 
BarcodePattern(68) = "141221"  ' EOT 	d 	68 
BarcodePattern(69) = "112214"  ' ENQ 	e 	69 
BarcodePattern(70) = "112412"  ' ACK 	f 	70 
BarcodePattern(71) = "122114"  ' BEL 	g 	71 
BarcodePattern(72) = "122411"  ' BS 	h 	72 
BarcodePattern(73) = "142112"  ' HT 	i 	73 
BarcodePattern(74) = "142211"  ' LF 	j 	74 
BarcodePattern(75) = "241211"  ' VT 	k 	75 
BarcodePattern(76) = "221114"  ' FF 	I 	76 
BarcodePattern(77) = "413111"  ' CR 	m 	77 
BarcodePattern(78) = "241112"  ' SO 	n 	78 
BarcodePattern(79) = "134111"  ' SI 	o 	79 
BarcodePattern(80) = "111242"  ' DLE 	p 	80 
BarcodePattern(81) = "121142"  ' DC1 	q 	81 
BarcodePattern(82) = "121241"  ' DC2 	r 	82 
BarcodePattern(83) = "114212"  ' DC3 	s 	83 
BarcodePattern(84) = "124112"  ' DC4 	t 	84 
BarcodePattern(85) = "124211"  ' NAK 	u 	85 
BarcodePattern(86) = "411212"  ' SYN 	v 	86 
BarcodePattern(87) = "421112"  ' ETB 	w 	87 
BarcodePattern(88) = "421211"  ' CAN 	x 	88 
BarcodePattern(89) = "212141"  ' EM 	y 	89 
BarcodePattern(90) = "214121"  ' SUB 	z 	90 
BarcodePattern(91) = "412121"  ' ESC 	{ 	91 
BarcodePattern(92) = "111143"  ' FS 	| 	92 
BarcodePattern(93) = "111341"  ' GS 	} 	93 
BarcodePattern(94) = "131141"  ' RS 	~ 	94 
BarcodePattern(95) = "114113"  ' US 	DEL 	95 
BarcodePattern(96) = "114311"  ' FNC 3 	FNC 3 	96 
BarcodePattern(97) = "411113"  ' FNC 2 	FNC 2 	97 
BarcodePattern(98) = "411311"  ' SHIFT 	SHIFT 	98 
BarcodePattern(99) = "113141"  ' CODE C 	CODE C 	99 
BarcodePattern(100) = "114131"  ' CODE B 	FNC 4 	CODE B 
BarcodePattern(101) = "311141"  ' FNC 4 	CODE A 	CODE A 
BarcodePattern(102) = "411131"  ' FNC 1 	FNC 1 	FNC 1 
BarcodePattern(103) = "211412"  ' Start A 	Start A 	Start A 
BarcodePattern(104) = "211214"  ' Start B 	Start B 	Start B 
BarcodePattern(105) = "211232"  ' Start C 	Start C 	Start C 
BarcodePattern(106) = "2331112"  ' Stop 	Stop 	Stop  2
  OutputString = InputString ' & Chr(CheckDigitAscii) & Chr(206)
	OutputPattern	= ""
  intCheckValue = 105
	For CharPos		= 1 To Len(OutputString) Step 2
    'strChar = Mid(OutputString, CharPos, 1)
    intValue = CInt(Mid(OutputString, CharPos, 2)) 'Asc(strChar)-32
		ThisPattern	= BarcodePattern(intValue)
    intCheckValue = (intCheckValue + intValue*((CharPos+1)/2)) Mod 103
    OutputPattern = OutputPattern & ThisPattern
	Next
	code128c	= BarcodePattern(105) & OutputPattern & BarcodePattern(intCheckValue) & BarcodePattern(106)
End function
'-------------------------------------------------
function code128b(ByVal InputString)
	Const MinValidAscii	= 32
	Const MaxValidAscii	= 126
	' Encode the input String
	InputString	= Trim(InputString)
	InvalidCharsFound	= vbFalse
	For CharPos	= 1 To Len(InputString)
		CharAscii		= Asc(Mid(InputString, CharPos, 1))
		if (CharAscii < MinValidAscii) OR (CharAscii > MaxValidAscii) Then
			CharAscii			= Asc("?")
			InvalidCharsFound	= vbTrue
		End if
	Next
  If InvalidCharsFound Then
    code128b = ""
    Exit Function
  End If
	Dim BarcodePattern(255)
BarcodePattern(0) = "212222"  ' SP 	SP 	00 
BarcodePattern(1) = "222122"  ' ! 	! 	01 
BarcodePattern(2) = "222221"  ' "	"	02 
BarcodePattern(3) = "121223"  ' # 	# 	03 
BarcodePattern(4) = "121322"  ' $ 	$ 	04 
BarcodePattern(5) = "131222"  ' % 	% 	05 
BarcodePattern(6) = "122213"  ' & 	& 	06 
BarcodePattern(7) = "122312"  ' ' 	' 	07 
BarcodePattern(8) = "132212"  ' ( 	( 	08 
BarcodePattern(9) = "221213"  ' ) 	) 	09 
BarcodePattern(10) = "221312"  ' * 	* 	10 
BarcodePattern(11) = "231212"  ' + 	+ 	11 
BarcodePattern(12) = "112232"  ' , 	, 	12 
BarcodePattern(13) = "122132"  ' - 	- 	13 
BarcodePattern(14) = "122231"  ' . 	. 	14 
BarcodePattern(15) = "113222"  ' / 	/ 	15 
BarcodePattern(16) = "123122"  ' 0 	0 	16 
BarcodePattern(17) = "123221"  ' 1 	1 	17 
BarcodePattern(18) = "223211"  ' 2 	2 	18 
BarcodePattern(19) = "221132"  ' 3 	3 	19 
BarcodePattern(20) = "221231"  ' 4 	4 	20 
BarcodePattern(21) = "213212"  ' 5 	5 	21 
BarcodePattern(22) = "223112"  ' 6 	6 	22 
BarcodePattern(23) = "312131"  ' 7 	7 	23 
BarcodePattern(24) = "311222"  ' 8 	8 	24 
BarcodePattern(25) = "321122"  ' 9 	9 	25 
BarcodePattern(26) = "321221"  ' : 	: 	26 
BarcodePattern(27) = "312212"  ' ; 	; 	27 
BarcodePattern(28) = "322112"  ' < 	< 	28 
BarcodePattern(29) = "322211"  ' = 	= 	29 
BarcodePattern(30) = "212123"  ' > 	> 	30 
BarcodePattern(31) = "212321"  ' ? 	? 	31 
BarcodePattern(32) = "232121"  ' @ 	@ 	32 
BarcodePattern(33) = "111323"  ' A 	A 	33 
BarcodePattern(34) = "131123"  ' B 	B 	34 
BarcodePattern(35) = "131321"  ' C 	C 	35 
BarcodePattern(36) = "112313"  ' D 	D 	36 
BarcodePattern(37) = "132113"  ' E 	E 	37 
BarcodePattern(38) = "132311"  ' F 	F 	38 
BarcodePattern(39) = "211313"  ' G 	G 	39 
BarcodePattern(40) = "231113"  ' H 	H 	40 
BarcodePattern(41) = "231311"  ' I 	I 	41 
BarcodePattern(42) = "112133"  ' J 	J 	42 
BarcodePattern(43) = "112331"  ' K 	K 	43 
BarcodePattern(44) = "132131"  ' L 	L 	44 
BarcodePattern(45) = "113123"  ' M 	M 	45 
BarcodePattern(46) = "113321"  ' N 	N 	46 
BarcodePattern(47) = "133121"  ' O 	O 	47 
BarcodePattern(48) = "313121"  ' P 	P 	48 
BarcodePattern(49) = "211331"  ' Q 	Q 	49 
BarcodePattern(50) = "231131"  ' R 	R 	50 
BarcodePattern(51) = "213113"  ' S 	S 	51 
BarcodePattern(52) = "213311"  ' T 	T 	52 
BarcodePattern(53) = "213131"  ' U 	U 	53 
BarcodePattern(54) = "311123"  ' V 	V 	54 
BarcodePattern(55) = "311321"  ' W 	W 	55 
BarcodePattern(56) = "331121"  ' X 	X 	56 
BarcodePattern(57) = "312113"  ' Y 	Y 	57 
BarcodePattern(58) = "312311"  ' Z 	Z 	58 
BarcodePattern(59) = "332111"  ' [ 	[ 	59 
BarcodePattern(60) = "314111"  ' \ 	\ 	60 
BarcodePattern(61) = "221411"  ' ] 	] 	61 
BarcodePattern(62) = "431111"  ' ^ 	^ 	62 
BarcodePattern(63) = "111224"  ' _ 	_ 	63 
BarcodePattern(64) = "111422"  ' NUL 	` 	64 
BarcodePattern(65) = "121124"  ' SOH 	a 	65 
BarcodePattern(66) = "121421"  ' STX 	b 	66 
BarcodePattern(67) = "141122"  ' ETX 	c 	67 
BarcodePattern(68) = "141221"  ' EOT 	d 	68 
BarcodePattern(69) = "112214"  ' ENQ 	e 	69 
BarcodePattern(70) = "112412"  ' ACK 	f 	70 
BarcodePattern(71) = "122114"  ' BEL 	g 	71 
BarcodePattern(72) = "122411"  ' BS 	h 	72 
BarcodePattern(73) = "142112"  ' HT 	i 	73 
BarcodePattern(74) = "142211"  ' LF 	j 	74 
BarcodePattern(75) = "241211"  ' VT 	k 	75 
BarcodePattern(76) = "221114"  ' FF 	I 	76 
BarcodePattern(77) = "413111"  ' CR 	m 	77 
BarcodePattern(78) = "241112"  ' SO 	n 	78 
BarcodePattern(79) = "134111"  ' SI 	o 	79 
BarcodePattern(80) = "111242"  ' DLE 	p 	80 
BarcodePattern(81) = "121142"  ' DC1 	q 	81 
BarcodePattern(82) = "121241"  ' DC2 	r 	82 
BarcodePattern(83) = "114212"  ' DC3 	s 	83 
BarcodePattern(84) = "124112"  ' DC4 	t 	84 
BarcodePattern(85) = "124211"  ' NAK 	u 	85 
BarcodePattern(86) = "411212"  ' SYN 	v 	86 
BarcodePattern(87) = "421112"  ' ETB 	w 	87 
BarcodePattern(88) = "421211"  ' CAN 	x 	88 
BarcodePattern(89) = "212141"  ' EM 	y 	89 
BarcodePattern(90) = "214121"  ' SUB 	z 	90 
BarcodePattern(91) = "412121"  ' ESC 	{ 	91 
BarcodePattern(92) = "111143"  ' FS 	| 	92 
BarcodePattern(93) = "111341"  ' GS 	} 	93 
BarcodePattern(94) = "131141"  ' RS 	~ 	94 
BarcodePattern(95) = "114113"  ' US 	DEL 	95 
BarcodePattern(96) = "114311"  ' FNC 3 	FNC 3 	96 
BarcodePattern(97) = "411113"  ' FNC 2 	FNC 2 	97 
BarcodePattern(98) = "411311"  ' SHIFT 	SHIFT 	98 
BarcodePattern(99) = "113141"  ' CODE C 	CODE C 	99 
BarcodePattern(100) = "114131"  ' CODE B 	FNC 4 	CODE B 
BarcodePattern(101) = "311141"  ' FNC 4 	CODE A 	CODE A 
BarcodePattern(102) = "411131"  ' FNC 1 	FNC 1 	FNC 1 
BarcodePattern(103) = "211412"  ' Start A 	Start A 	Start A 
BarcodePattern(104) = "211214"  ' Start B 	Start B 	Start B 
BarcodePattern(105) = "211232"  ' Start C 	Start C 	Start C 
BarcodePattern(106) = "2331112"  ' Stop 	Stop 	Stop  2
  OutputString = InputString ' & Chr(CheckDigitAscii) & Chr(206)
	OutputPattern	= ""
  intCheckValue = 104
	For CharPos		= 1 To Len(OutputString)
    strChar = Mid(OutputString, CharPos, 1)
    intValue = Asc(strChar)-32
		ThisPattern	= BarcodePattern(intValue)
    intCheckValue = (intCheckValue + intValue*CharPos) Mod 103
    OutputPattern = OutputPattern & ThisPattern
	Next
	code128b	= BarcodePattern(104) & OutputPattern & BarcodePattern(intCheckValue) & BarcodePattern(106)
End function
%>
