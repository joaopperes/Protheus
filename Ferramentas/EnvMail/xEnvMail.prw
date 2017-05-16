//bibliotecas
#Include 'Protheus.ch'
#Include 'ap5mail.ch'

/*/{Protheus.doc} xEnvMail
//TODO Rotina generica para envio de e-mail
@author joao.peres
@since 16/05/2017
@version undefined
@param aDados, array, descricao
@param lFormat, logical, descricao
@param lAlert, logical, descricao
@example
U_xGEN01A(aDados,lFormat,lAlert)
aDados[1]
[1][1] Destinat�rios, separado por ;
[1][2] Assunto
[1][3] Mensagem
[1][4] Anexo	
@type function
/*/
User Function xEnvMail(aDados,lFormat,lAlert)

	Local cServer		:= GetMv("MV_RELSERV")	//Servidor de e-mail
	Local cAccount		:= GetMv("MV_RELACNT")	//Conta a ser utilizada
	Local lAutentica 	:= GetMv("MV_RELAUTH")  //Servidor com autenticacao?
	Local cPassword		:= GetMv("MV_RELPSW")	//Senha
	Local cResult		:= .F.					//Resultado da conex�o
	Local cError		:= ''					//Controle de erro de conex�o
	Local lEnviado		:= .F.					//Controle de envio
	Local cTo			:= ''					//Destinat�rios das mensagens
	Local cSubject		:= ''					//Assunto
	Local cMensagem		:= ''					//Mensagem
	Local cAttachment	:= ''					//Anexos

	for	nY := 1 To Len(aDados)
		//Carrega informa��es para envio do E-mail
		cTo			:= aDados[nY][1]
		cSubject 	:= aDados[nY][2]
		cMensagem	:= aDados[nY][3]
		cAttachment	:= aDados[nY][4]

		//Conex�o com o servidor de e-mail
		Connect SMTP SERVER	cServer ACCOUNT cAccount PASSWORD cPassword RESULT lResult
		
		if !lResult
			msgalert("n�o conectou.")
		endif
		
		//Verifica se a conex�o foi bem sucedida
		if lResult .and. lAutentica
			//Realiza autentica��o com o e-mail completo
			lResult	:= MailAuth(cAccount,cPassword)	
		endif

		//caso n�o tenha sido realizado a conex�o com o servidor
		if !lResult
			cMsg := "N�o foi possivel estabelecer conex�o com o servidor!!"
			f001(cMsg,lAlert,1)
		else
			//Envia e-mail
			SEND MAIL 				;
			FROM	cAccount		;
			TO		cTo				;
			SUBJECT	cSubject		;
			BODY	cMensagem 		;
			ATTACHMENT cAttachment	;
			RESULT lEnviado

			if !lEnviado
				GET MAIL ERROR cError
				MsgAlert(cError)
			else
				cMsg := "E-mail enviado com sucesso!"
				f001(cMsg,lAlert,2)
			endif
		endif

		//Finaliza conexao com o servidor de E-Mail
		DISCONNECT SMTP SERVER

	next nY

Return lEnviado

/*/{Protheus.doc} f001
//TODO Descri��o auto-gerada.
@author joao.peres
@since 16/05/2017
@version undefined
@param cMsg, characters, mensagem a ser apresentada
@param lAlert, logical, .T. Alert em tela, caso seja .F. mensagem no console
@param nTipo, numeric, 1 = MsgStop, 2=MsgInfo
@type function
/*/
Static Function f001(cMsg,lAlert,nTipo)

	//se for alerta na tela
	if lAlert
		if nTipo == 1
			MsgStop(cMsg,"xGEN01A - Envia E-mail")
		elseif nTipo = 2
			MsgInfo(cMsg,"xGEN01A - Envia E-mail")
		endif
	else
		ConOut("xGEN01A - " + DToC(Date()) + " - " + Time() + " - " + cMsg)
	endif

Return