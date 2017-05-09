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
	oView:AddUserButton( 'Importar Arquivo', 'CLIPS', {|oView| xFIN01AImp()} )
	
	//Adiciona um controle do tipo de formulário na view
	oView:AddField('VIEW_ZS1', oStruZS1, 'ZS1MASTER')
	
	oView:CreateHorizontalBox('TELA', 100)
	
	oView:SetOwnerView('VIEW_ZS1', 'TELA')
	
Return oView

/*/{Protheus.doc} xFIN01AImp
//TODO Descrição auto-gerada.
@author João Paulo
@since 08/05/2017
@version undefined

@type function
/*/
Static Function xFIN01AImp()

	

Return