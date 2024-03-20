#include "totvs.ch"
#include "FWMVCDEF.ch"

// pontos de entrada
user function MDCADINT()
    local xRet   := .T.
    local oModel := PARAMIXB[1] 
    local cIDPE  := PARAMIXB[2]

    do case
        case cIDPE == "BUTTONBAR"
            xRet := U_AddBtn()

        case cIDPE == "MODELCANCEL"
            if oModel:GetOperation() == MODEL_OPERATION_INSERT
                msgInfo("Operação cancelada")
            endif

    endcase
    if valtype(xRet) == 'L' .and. !xRet
        Help( ,, 'Help',, 'Preço unitário não informado.', 1, 0 )
    endif
return xRet

static function Gravacao(oModel)
    //FWFldPut("ZZ1_FINALI", lower(FWFldGet("ZZ1_FINALI")))

    FWFormCommit(oModel)
return .T.

static function PreValid(oModel)
    local lRet := .T.
    local oMdlBkp := FWModelActive()

    if oModel:GetOperation() == MODEL_OPERATION_UPDATE .AND. FWFldGet("ZZ1_METODO") == 'U'
        lRet := .F.
    endif

    FWModelActive(oMdlBkp)
return lRet

static function ModelDef()
    //local bPre      := {|oModel| PreValid(oModel)}
    //local bCommit   := {|oModel| Gravacao(oModel)}
    local oStruZZ1  := FwFormStruct(1, "ZZ1")
    local oModel    := MPFormModel():New("MDCADINT",/*bPre*/,, {|oModel| Gravacao(oModel)})
    //local oMdlZZ1

    oModel:AddFields("ZZ1MASTER",nil, oStruZZ1)
    oModel:SetPrimaryKey({"ZZ1_FILIAL", "ZZ1_ID"})

    oModel:SetDescription("Integrações")

    //oMdlZZ1 := oModel:GetModel("ZZ1MASTER")
    //oMdlZZ1:SetDescription("Cadastro das Integrações")
    oModel:GetModel("ZZ1MASTER"):SetDescription("Cadastro das Integrações")
return oModel

static function ViewDef()
    local oStruZZ1  := FwFormStruct(2, "ZZ1")
    local oModel    := FWLoadModel("MVCZZ1")
    local oView     := FWFormView():New()

    oView:SetModel(oModel)
    oView:AddField("VIEW_ZZ1", oStruZZ1, "ZZ1MASTER")

    oView:CreateHorizontalBox("header", 35)
    oView:SetOwnerView("VIEW_ZZ1", "header")

    oView:addUserButton('Executar', 'SALVAR', {|| U_ExecInt()}, 'Executar Integração')
    oView:addUserButton('Produtos', 'SALVAR', {|| ViewSB1()}, 'Visualizar Produtos')
return oView

static function ViewSB1()
    FWExecView("veio das integrações", "MVCZZ1", MODEL_OPERATION_UPDATE)
return
