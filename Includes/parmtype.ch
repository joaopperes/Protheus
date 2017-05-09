#xcommand PARAMEXCEPTION [ PARAM <param> VAR ] <varname> TEXT <text> MESSAGE <message> ;
	=> ;
	UserException(<message>) 

#xcommand PARAMEXCEPTION PARAM <param> VAR <varname> TEXT <text>  ;
	=> ;
	UserException("argument #"+<"param">+", parameter "+<"varname">+" error, expected "+<text>) 

#xcommand PARAMEXCEPTION <varname> TEXT <text>  ;
	=> ;
	UserException("argument error in parameter "+<"varname">+", expected "+<text>)

#xcommand CLASSEXCEPTION <varname> MESSAGE <message> ;
	=> ;
	UserException("error in parameter "+<"varname">+": "+<message>)

#xcommand CLASSPARAMEXCEPTION [ PARAM <param> VAR ] <varname> TEXT <text,...> [ MESSAGE <message> ] ;
	=> ;
	[ UserException(<message>) ] ;;
	[ UserException("argument #"+<"param">+", parameter "+<"varname">+" error, class expected "+\"<text>\") ] ;;
	UserException("argument error in parameter "+<"varname">+", class expected "+\"<text>\")

#xcommand BLOCKPARAMEXCEPTION [ PARAM <param> VAR ] <varname> TEXT <text> [ MESSAGE <message> ] ;
	=> ;
	[ UserException(<message>) ] ;;
	[ UserException("argument #"+<"param">+" error , return expected "+<text>) ] ;;
	UserException("argument error in block "+<"varname">+", return expected "+<text>)
	
#xcommand PARAMTYPE [ <param> VAR ] <varname> AS <type: ARRAY, BLOCK, CHARACTER, DATE, NUMERIC, LOGICAL, OBJECT> ;
	[ , <typeN: ARRAY, BLOCK, CHARACTER, DATE, NUMERIC, LOGICAL, OBJECT> ] ;
	[ MESSAGE <message> ] ;
	=> ;
	If !(ValType(<varname>) $ Subs(<"type">,1,1) [ + Subs(<"typeN">,1,1) ]) ;;
		PARAMEXCEPTION [ PARAM <param> VAR ] <varname> TEXT Subs(<"type">,1,1) [ + "," + Subs(<"typeN">,1,1) ]+"->"+ValType(<varname>) [ MESSAGE <message> ] ;;
	EndIf ;;

// Optional sem default 
#xcommand PARAMTYPE [ <param> VAR ] <varname> AS <type: ARRAY, BLOCK, CHARACTER, DATE, NUMERIC, LOGICAL, OBJECT> ;
	[ , <typeN: ARRAY, BLOCK, CHARACTER, DATE, NUMERIC, LOGICAL, OBJECT> ] ;
	[ MESSAGE <message> ] ;
	<optional: OPTIONAL> ;
	=> ;
	If <varname> != NIL .and. !(ValType(<varname>) $ Subs(<"type">,1,1) [ + Subs(<"typeN">,1,1) ]) ;;
		PARAMEXCEPTION [ PARAM <param> VAR ] <varname> TEXT Subs(<"type">,1,1) [ + "," + Subs(<"typeN">,1,1) ]+"->"+ValType(<varname>) [ MESSAGE <message> ] ;;
	EndIf ;;

// Optional com default 
#xcommand PARAMTYPE [ <param> VAR ] <varname> AS <type: ARRAY, BLOCK, CHARACTER, DATE, NUMERIC, LOGICAL, OBJECT> ;
	[ , <typeN: ARRAY, BLOCK, CHARACTER, DATE, NUMERIC, LOGICAL, OBJECT> ] ;
	[ MESSAGE <message> ] ;
	[<optional: OPTIONAL>];
	DEFAULT <uVar> ;
	[<optional: OPTIONAL>];
	=> ;
	If <varname> != NIL .and. !(ValType(<varname>) $ Subs(<"type">,1,1) [ + Subs(<"typeN">,1,1) ]) ;;
		PARAMEXCEPTION [ PARAM <param> VAR ] <varname> TEXT Subs(<"type">,1,1) [ + "," + Subs(<"typeN">,1,1) ]+"->"+ValType(<varname>) [ MESSAGE <message> ] ;;
	EndIf ;;
	<varname> := If(<varname> == nil,<uVar>,<varname>)

#xcommand PARAMTYPE [ <param> VAR ] <varname> AS BLOCK EXPECTED <expected: ARRAY, BLOCK, CHARACTER, DATE, NUMERIC, LOGICAL, OBJECT> ;
	[ MESSAGE <message> ] ;
	[ <optional: OPTIONAL> ] ;
	=> ;
	If ValType(<varname>) == "B" ;;
		__block := Eval(<varname>)  ;;
		If ValType(__block) <> Subs(<"expected"> ,1,1)  ;;
			BLOCKPARAMEXCEPTION [ PARAM <param> VAR ] <varname> TEXT Subs(<"expected">,1,1) + "->"+ValType(__block) [ MESSAGE <message> ] ;;
		EndIf  ;;
	ElseIf !(<.optional.> .and. <varname> == NIL) ;;
		PARAMEXCEPTION [ PARAM <param> VAR ] <varname> TEXT "B->"+ValType(<varname>) [ MESSAGE <message> ] ;;
	EndIf
	
#xcommand PARAMTYPE [ <param> VAR ] <varname> AS OBJECT CLASS <classname,...> ;
	[ MESSAGE <message> ] ;
	[ <optional: OPTIONAL> ] ;
	=> ;
	If ValType(<varname>) == "O" ;;
		__erro := ErrorBlock({|| "UNDEFINED"}) ;;
		BEGIN SEQUENCE ;;
		__classname := Upper(<varname>:ClassName()) ;;
		END SEQUENCE ;;
		ErrorBlock(__erro)  ;;
		If !(__classname $ Upper(\"<classname>\")) ;;
			CLASSPARAMEXCEPTION [ PARAM <param> VAR ] <varname> TEXT <classname> [ MESSAGE <message> ] ;;
		EndIf ;;
	ElseIf !(<.optional.> .and. <varname> == NIL) ;;
		PARAMEXCEPTION [ PARAM <param> VAR ] <varname> TEXT "O->"+ValType(<varname>) [ MESSAGE <message> ] ;;
	EndIf

#xcommand PARAMTYPE [ <param> VAR ] <varname> AS <type: ARRAY, BLOCK, CHARACTER, DATE, NUMERIC, LOGICAL> ;
	[ , <typeN: ARRAY, BLOCK, CHARACTER, DATE, NUMERIC, LOGICAL> ] ;
	OR OBJECT CLASS <classname,...> ;
	[ MESSAGE <message> ] ;
	[ <optional: OPTIONAL> ] ;
	=> ;
	If ValType(<varname>) == "O" ;;
		PARAMTYPE [ <param> VAR ] <varname> AS OBJECT CLASS <classname> [ MESSAGE <message> ] [ <optional> ] ;;
	Else ;;
		PARAMTYPE [ <param> VAR ] <varname> AS <type> [, <typeN>] [ MESSAGE <message> ] [ <optional> ] ;;
	EndIf
