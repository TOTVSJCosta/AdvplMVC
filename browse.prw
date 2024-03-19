#include "totvs.ch"
#include "fwmvcdef.ch"


user function AdvplMVC()
    local oBrowse := FWLoadBrw("browse")
    
    oBrowse:SetMenuDef("browse")
    oBrowse:Activate()
return

static function MenuDef()
    local aMenu := {} AS Array

    ADD OPTION aMenu TITLE "Incuir" ACTION "VIEWDEF.MVCZZ1";
        OPERATION MODEL_OPERATION_INSERT ACCESS 0
    
    ADD OPTION aMenu TITLE "Alterar" ACTION "VIEWDEF.MVCZZ1";
        OPERATION MODEL_OPERATION_UPDATE ACCESS 0
    
    ADD OPTION aMenu TITLE "Visualizar" ACTION "VIEWDEF.MVCZZ2";
        OPERATION 2 ACCESS 0
    
    ADD OPTION aMenu TITLE "Excluir" ACTION "VIEWDEF.MVCZZ2";
        OPERATION MODEL_OPERATION_DELETE ACCESS 0
return aMenu

static function BrowseDef()
    local oBrowse := FWMBrowse():New()
    
    oBrowse:SetAlias("ZZ1")
    oBrowse:SetDescription("Central de Integrações")
    oBrowse:DisableDetails()
    oBrowse:AddLegend("ZZ1_STATUS=='H'", "GREEN", "Habilitada")
    oBrowse:AddLegend("ZZ1_STATUS=='D'", "RED", "Desabilitada")
    oBrowse:SetFilterDefault("if(__cUserID != '000000', ZZ1_STATUS=='H', .t.)")
return oBrowse
