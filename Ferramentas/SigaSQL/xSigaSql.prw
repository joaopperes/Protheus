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
	Private oDlg
	Private oSize
	Private aStru	:= {}
	Private oGetD
	//Calcula as dimensões do objeto
	oSize := FwDefSize():New()

	//Dispara o calculo
	oSize:Process()

	DEFINE MSDIALOG oDlg TITLE 'Exporta Query SQL' From oSize:aWindSize[1],oSize:aWindSize[1] ;
	TO oSize:aWindSize[3], oSize:aWindSize[4] OF oMainWnd PIXEL

	@ 010,010 SAY "Digite a Query: " SIZE 55,07 OF oDlg PIXEL
	@ 020,010 GET oQuery VAR cQuery MEMO SIZE 400,100 OF oDlg PIXEL
	@ 030,500 BUTTON "Executar" SIZE 080,047 PIXEL OF oDlg ACTION xExecQry(cQuery)

	//Monta GetDados
	xfGetD()

	ACTIVATE MSDIALOG oDlg CENTERED //ON INIT

Return

Static Function xfGetD()

	Local aHeader 	:= {}
	Local aCols		:= {}
	Local aCpoGDa	:= {}

	//Carrega informações do aHeader
	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))	//CAMPO
	if Len(aStru) > 0
		For nY := 1 To Len(aStru)
			if SX3->(DbSeek(aStru[nY][1]))
				aAdd(aHeader, { Alltrim(X3Titulo()), x3_campo, x3_picture, ;
				 				x3_tamanho, x3_decimal,"AllwaysTrue()",;
				 				x3_usado, x3_tipo, x3_arquivo, x3_context})	
			endif
		Next nY
	endif

	//Carega inforçãoes do aCols
	
	
	
	//Monta getDados
	oGetD := MsNewGetDados():New(150,004,300,600,0,"AllwaysTrue","AllwaysTrue","","",000,000,"AllwaysTrue","","AllwaysTrue",oDlg,aHeader,aCols)

Return

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
	//posiciona no inicio do arquivo
	cTRB1->(DbGoTop())

//	While !cTRB->(Eof())
//
//		cTRB->(DbSkip())
//	EndDo

	oGetD:oBrowse:Refresh()
	oDlg:Refresh()

Return aStru