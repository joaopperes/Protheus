//******************************************
// TESTE 1
//******************************************
User Function xTestMail()

	Local aDados := {}
	
	aAdd(aDados, {'joao.peres@iesb.br','Assunto do e-mail', 'MEnsagem do corpo', ''})
	
	u_xEnvMail(aDados,.t.,.t.)

Return

//******************************************
// TESTE 2 - COM HTML
//******************************************


//******************************************
// TESTE 3 - VARIOS REGISTROS
//******************************************