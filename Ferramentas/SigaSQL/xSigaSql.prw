//Bibliotecas
#Include 'Protheus.ch'

/*/{Protheus.doc} xSigaSQL
//TODO Descrição auto-gerada.
@author João Paulo
@since 16/05/2017
@version undefined

@type function
/*/
User Function xSigaSQL()

	Local oQuery
	Local cQuery	:= ""
	Local aButtons  := {}
	Local oGroup1
	Private oDlg
	Private oSize
	Private aStru	:= {}
	Private oGetD

	//Calcula as dimensões do objeto
	oSize := FwDefSize():New(.T.) //Com enchoicebar

	oSize:AddObject( "CABECALHO", 100, 40, .T., .T.)
	oSize:AddObject( "GETDADOS", 100, 60, .T., .T.)

	oSize:lProp := .T.

	//Dispara o calculo
	oSize:Process()

	//Monta Tela
	DEFINE MSDIALOG oDlg TITLE 'Exporta Query SQL' From oSize:aWindSize[1],oSize:aWindSize[1] ;
	TO oSize:aWindSize[3], oSize:aWindSize[4] PIXEL

	//Monta grupo 1 - cabeçalho
	oGroup1 := TGroup():New( oSize:GetDimension("CABECALHO","LININI"),;
	oSize:GetDimension("CABECALHO","COLINI"),;
	oSize:GetDimension("CABECALHO","LINEND"),;
	oSize:GetDimension("CABECALHO","COLEND"),;
	'',oDlg,,,.T.)

	oQuery := tMultiget():new(oSize:GetDimension("CABECALHO","LININI")+5,oSize:GetDimension("CABECALHO","COLINI")+5,{| u | if( pCount() > 0, cQuery := u, cQuery )},oGroup1,400,90,,,,,,.T.)
	
	oTButton1 := TButton():New( 030, 500, "Executar (F5)",oGroup1,{|| xExecQry(cQuery)}, 40,10,,,.F.,.T.,.F.,,.F.,,,.F. ) 
	//	@ 010,010 SAY "Digite a Query: " SIZE oSize:GetDimension("CABECALHO","LININI")+20,oSize:GetDimension("CABECALHO","COLINI")+20 OF oGroup1 PIXEL
	//	@ 020,010 GET oQuery VAR cQuery MEMO SIZE 400,100 OF oGroup1 PIXEL
//	@ 030,500 BUTTON "Executar (F5)" SIZE 080,015 PIXEL OF oDlg ACTION xExecQry(cQuery)

	//Monta GetDados
	xfGetD()

	//Tecla F5 de atalho para execução
	SetKey(VK_F5, {|| xExecQry(cQuery)})

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT (EnchoiceBar(oDlg,{||lOk:=.T.,oDlg:End()},{||oDlg:End()},,@aButtons))

	SetKey(VK_F5, Nil)
Return

/*/{Protheus.doc} xfGetD
//TODO Descrição auto-gerada.
@author João Paulo
@since 16/05/2017
@version undefined

@type function
/*/
Static Function xfGetD(aStru)

	Local aHeader 	:= {}
	Local aCols		:= {}
	Local aPosGetD := { 3, 3, oSize:GetDimension("GETDADOS","YSIZE") - 16, oSize:GetDimension("GETDADOS","XSIZE") - 4 }

	//Só carrega aHeader e aCols quando o array aStru estiver preenchido
	If ValType(aStru) == "A"
		//Carrega informações do aHeader                                                                                                               
		DbSelectArea("SX3")                                                                                                             
		SX3->(DbSetOrder(2)) //X3_CAMPO                                                                                                 
		For nX := 1 to Len(aStru)      
			//Verifica se o campo existe na SX3
			If SX3->(DbSeek(aStru[nX,1]))
				Aadd(aHeader,{ AllTrim(X3Titulo()), x3_campo, x3_picture,;
				x3_tamanho, x3_decimal,"AllwaysTrue()",;
				x3_usado, x3_tipo, x3_arquivo, x3_context } )                                                                                                      
			Else //Se não exister pega as informações do array da estrutura de dados
				Aadd(aHeader,{ aStru[nX,1], aStru[nX,1], "",;                                                                                                       
				aStru[nX,3], aStru[nX,4], "AllwaysTrue()"	,;                                                                                                       
				""	, aStru[nX,2], "",""})                                                                                                       
			Endif                                                                                                                         
		Next nX                             

	EndIf

	//Monta getDados
//	oGetD := MsNewGetDados():New(150,004,aPosGetD[3],aPosGetD[4],0,"AllwaysTrue","AllwaysTrue","","",000,000,"AllwaysTrue","","AllwaysTrue",oDlg,aHeader,aCols)
	oGetD := MsNewGetDados():New(150,004,300,650,0,"AllwaysTrue","AllwaysTrue","","",000,000,"AllwaysTrue","","AllwaysTrue",oDlg,aHeader,aCols)

Return

/*/{Protheus.doc} xExecQry
//TODO Descrição auto-gerada.
@author João Paulo
@since 16/05/2017
@version undefined
@param cQuery, characters, descricao
@type function
/*/
Static Function xExecQry(cQuery)

	Local cTRB1 := GetNextAlias()

	//Valida se a Query está correta
	if TcSqlExec(cQuery) <> 0
		MsgStop("Query Invalida!!" + TCSQLError(),'Query Invalida!!')
		Return(.F.)
	endif
	//verifica se já existe um area aberta, se existir finaliza
	if select("cTRB1") > 0
		cTRB1->(DbCloseArea())
	endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"cTRB1",.T.,.T.)

	//Grava a estrutura do arquivo de dados no array
	aStru := cTRB1->(dbStruct())

	//carrega cabeçalho do getdados
	xfGetD(aStru)

	oGetD:aCols := {}
	
	//Carrega o aCols
	cTRB1->(DbGoTop())
	While !cTRB1->(Eof())
		_aResult := {}
		For nG := 1 To Len(aStru)
			Aadd(_aResult,cTRB1->&(aStru[nG,1]))
		Next
		Aadd(_aResult,.F.)
		Aadd(oGetD:aCols,_aResult)
		cTRB1->(DbSkip())
	EndDo

	//Atualiza GetDados
	oGetD:oBrowse:Refresh()
	oDlg:Refresh()

Return(aStru)