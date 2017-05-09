
//-------------------------------------------------------------------
// Vari�veis utilizadas no array retornado pela fun��o FWLoadSM0()
//-------------------------------------------------------------------
#DEFINE SM0_GRPEMP   1 // C�digo do grupo de empresas
#DEFINE SM0_CODFIL   2 // C�digo da filial contendo todos os n�veis (Emp/UN/Fil)
#DEFINE SM0_EMPRESA  3 // C�digo da empresa
#DEFINE SM0_UNIDNEG  4 // C�digo da unidade de neg�cio
#DEFINE SM0_FILIAL   5 // C�digo da filial
#DEFINE SM0_NOME     6 // Nome da filial
#DEFINE SM0_NOMRED   7 // Nome reduzido da filial
#DEFINE SM0_SIZEFIL  8 // Tamanho do campo filial
#DEFINE SM0_LEIAUTE  9 // Leiaute do grupo de empresas
#DEFINE SM0_EMPOK   10 // Empresa autorizada
#DEFINE SM0_USEROK  11 // Usu�rio tem permiss�o para usar a empresa/filial
#DEFINE SM0_RECNO   12 // Recno da filial no SIGAMAT
#DEFINE SM0_LEIAEMP 13 // Leiaute da empresa (EE)
#DEFINE SM0_LEIAUN  14 // Leiaute da unidade de neg�cio (UU)
#DEFINE SM0_LEIAFIL 15 // Leiaute da filial (FFFF)
#DEFINE SM0_STATUS  16 // Status da filial (0=Liberada para manuten��o,1=Bloqueada para manuten��o)
#DEFINE SM0_NOMECOM 17 // Nome Comercial
#DEFINE SM0_CGC     18 // CGC
#DEFINE SM0_DESCEMP 19 // Descricao da Empresa
#DEFINE SM0_DESCUN  20 // Descricao da Unidade
#DEFINE SM0_DESCGRP 21 // Descricao do Grupo
#DEFINE SM0_IDMID   22 // C�digo no Identity Manager

#DEFINE SM0_SIZEARRAY  22 // Tamanho do Array da fun��o FWLoadSM0(), sempre dever� ter o tamanho m�ximo dos defines acima

//-------------------------------------------------------------------
// Retorna o tamanho do campo filial
//-------------------------------------------------------------------
#xtranslate FWGETTAMFILIAL => Iif ( FindFunction("FWSIZEFILIAL"), FWSizeFilial(), 2)

//-------------------------------------------------------------------
// Retorna o ocnte�do do campo M0_CODFIL
//-------------------------------------------------------------------         
#xtranslate FWGETCODFILIAL => Iif ( FindFunction("FWCODFIL"), FWCodFil(), SM0->M0_CODFIL)
