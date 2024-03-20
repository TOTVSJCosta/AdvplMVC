#include "totvs.ch"
#include "FWMVCDEF.ch"

static function ModelDef()
    local oStruZZ2  := FwFormStruct(1, "ZZ2")
    local oModel    := FWLoadModel("MVCZZ1")

    oModel:AddGrid("ZZ2DETAIL", "ZZ1MASTER", oStruZZ2)
    oModel:SetPrimaryKey({"ZZ2_FILIAL", "ZZ2_ID"})

    oModel:SetRelation("ZZ2DETAIL", {{"ZZ2_FILIAL", "xFilial('ZZ2')"},{"ZZ2_TASKID", "ZZ1_ID"}}, ZZ2->(IndexKey(1)))

    oModel:GetModel("ZZ2DETAIL"):SetOptional(.T.)
    /*oModel:GetModel("ZZ2DETAIL"):SetOnlyView(.T.)
    oModel:GetModel("ZZ2DETAIL"):SetOnlyQuery(.T.)*/
    oModel:GetModel("ZZ2DETAIL"):SetDescription("Histórico das Integrações")

return oModel

static function ViewDef()
    local oStruZZ2  := FwFormStruct(2, "ZZ2", {|cID| !(cID $ "ZZ2_TASKID,ZZ2_FINALI")})
    local oModel    := ModelDef() //FWLoadModel("MVCZZ2")
    local oView     := FWLoadView("MVCZZ1")

    oStruZZ2:SetProperty("ZZ2_RESULT", MVC_VIEW_TITULO, "Resultado do processamento")

    oView:SetModel(oModel)
    oView:AddGrid("VIEW_ZZ2", oStruZZ2, "ZZ2DETAIL")
    
    oView:AddOtherObjects("VIEWOTHER", {|oPanel| OtherObj(oPanel)})

    oView:CreateHorizontalBox("itens", 65)
    oView:CreateVerticalBox("itLeft", 50, "itens")
    oView:CreateVerticalBox("itRight", 50, "itens")

    oView:SetOwnerView("VIEW_ZZ2", "itLeft")
    oView:SetOwnerView("VIEWOTHER", "itRight")
    oView:EnableTitleView("VIEW_ZZ2", "Histórico das Integrações")
    oView:EnableTitleView("VIEWOTHER", "Outras Informações")

    //oStruZZ2:RemoveField("ZZ2_TASKID")
    oStruZZ2:RemoveField("ZZ2_FINALI")
return oView

static function OtherObj(oPanel)
    MsWorkTime():New(oPanel)
return

// Ponto de entrada para cadastro de produtos (MATA010)
user function ITEM()
    local cIDPE := PARAMIXB[2]
    
return .t.
