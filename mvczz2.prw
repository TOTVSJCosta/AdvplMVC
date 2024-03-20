#include "totvs.ch"
#include "fwmvcdef.ch"

// pontos de entrada
user function ZZ1MVCPE()
    local xRet  := .T.
    local cIDPE := PARAMIXB[3]  AS Character

    if cIDPE == ""
    endif
return xRet

static function ModelDef()
    local oStruZZ1  := FwFormStruct(1, "ZZ1")
    local oModel    := MPFormModel():New("ZZ1MVCPE")

    oModel:AddFields("ZZ1MASTER",, oStruZZ1)
    oModel:SetPrimaryKey({"ZZ1_FILIAL", "ZZ1_ID"})
    oModel:SetDescription("Integrações")
    oModel:GetModel("ZZ1MASTER"):SetDescription("Central de Integrações")
return oModel

static function ViewDef()
    local oStruZZ1  := FwFormStruct(2, "ZZ1")
    local oModel    := ModelDef()
    local oView     := FWFormView():New()

    oView:SetModel(oModel)
    oView:AddField("VIEWZZ1", oStruZZ1, "ZZ1MASTER")
    
    oView:CreateHorizontalBox("master", 35)
    oView:SetOwnerView("VIEWZZ1", "master")
return oView
