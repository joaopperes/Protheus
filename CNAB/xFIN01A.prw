//Biblioteca
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

/*/{Protheus.doc} xFIN01A
//TODO Rotina para facilitar a recepção do arquivo CNAB a pagar
@author João Paulo
@since 08/05/2017
@version undefined

@type function
/*/
User Function xFIN01A()

	Local oBrowse

	//Instanciando a classe do browse
	oBrowse := FWMBrowse():New()

	//Definindo a tabela do browse, cabeçalho do arquivo cnab
	oBrowse:SetAlias('ZS1')

	//Titulo do browse
	oBrowse:SetDescription('Recepção Arquivos CNABs')

	//Ativando a Classe
	oBrowse:Activate()

Return Nil

/*/{Protheus.doc} MenuDef
//TODO Descrição auto-gerada.
@author João Paulo
@since 08/05/2017
@version undefined

@type function
/*/
Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina Title 'Visualizar' 	Action 'ViewDef.xFIN01A' OPERATION 2 ACCESS 0
	ADD OPTION aRotina Title 'Incluir' 		Action 'ViewDef.xFIN01A' OPERATION 3 ACCESS 0

Return aRotina

/*/{Protheus.doc} ModelDef
//TODO Descrição auto-gerada.
@author João Paulo
@since 08/05/2017
@version undefined

@type function
/*/
Static Function ModelDef()

	Local oStruZS1	:= FWFormStruct(1, 'ZS1') 	// Estrutura utilizada no modelo de dados
	Local oModel								//Modelo de dados

	//Cria objeto do modelo de dados
	oModel := MPFormModel():New('xFIN01AM')

	//Componentes do formulário
	oModel:AddFields('ZS1MASTER', /*cOwner*/, oStruZS1)

	oModel:SetPrimaryKey({ "ZS1_FILIAL", "ZS1_DATA" })

	//Descrição do modelo de dados
	oModel:SetDescription('Modelo de dados cabeçalho do arquivo CNAB')

	//Descrição do componente
	oModel:GetModel('ZS1MASTER'):SetDescription("Cabeçalho Arquivo CNAB")

Return oModel

/*/{Protheus.doc} ViewDef
//TODO Descrição auto-gerada.
@author João Paulo
@since 08/05/2017
@version undefined

@type function
/*/
Static Function ViewDef()

	Local oModel 	:= FWLoadModel('xFIN01A')
	Local oStruZS1	:= FWFormStruct(2, 'ZS1')
	Local oView

	//Cria objeto de view
	oView := FWFormView():New()

	//Modelo de dados a ser utilizado
	oView:SetModel(oModel)

	//Adiciona botão para importação do arquivo
	oView:AddUserButton( 'Importar Arquivo', 'CLIPS', {|oView| xFIN01AArq()} )

	//Adiciona um controle do tipo de formulário na view
	oView:AddField('VIEW_ZS1', oStruZS1, 'ZS1MASTER')

	//Cria tela horizontal
	oView:CreateHorizontalBox('TELA', 100)

	oView:SetOwnerView('VIEW_ZS1', 'TELA')

Return oView

/*/{Protheus.doc} xFIN01AArq
//TODO Descrição auto-gerada.
@author João Paulo
@since 08/05/2017
@version undefined

@type function
/*/
Static Function xFIN01AArq()

	Local cFile	//Nome do Arquivo a ser importado

	//Abre tela para seleção do arquivo
	cFile := cGetFile('Arquivo *|*.*|Arquivo TXT|*.txt', 'Selecione Arquivo', 0, 'C:\', .F.,,.F.)

	//Chama rotina que carrega as informações
	xFIN01ACar(cFile,"D:\CNAB\santande.2pr")

Return

/*/{Protheus.doc} xFIN01ACar
//TODO Descrição auto-gerada.
@author João Paulo
@since 09/05/2017
@version undefined
@param cFile, characters, descricao
@param cLayout, characters, descricao
@type function
/*/
Static Function xFIN01ACar(cFile,cLayout)

	Local oFile 		//Arquivo a ser importado
	Local aCabec := {}
	Local aLinha := {}	//Array que vai receber todas as linhas do arquivo

	//Cria objeto de leitura
	oFile := FWFileReader():New(cFile)

	//abre arquivo para leitura
	if (oFile:Open())
		//grava linhas no array
		aLinha := oFile:getAllLines()
		
		aAdd( aCabec,{'ZS1_DATA' , substr(aLinha[1],144,8) } )
		
		oFile:Close()
	endif

Return