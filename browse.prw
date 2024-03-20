#include "totvs.ch"
#include "FWMVCDEF.ch"

user function XFISA001()
    local oBrowse := FWLoadBrw("browse")

    oBrowse:SetMenuDef("browse")
    oBrowse:Activate()
return

static function BrowseDef()
    local oBrowse := FWMBrowse():New()

    oBrowse:SetAlias("ZZ1")
    oBrowse:SetDescription("Central de Integrações")
    oBrowse:AddLegend("ZZ1_STATUS == 'H'", "GREEN", "Habilitada")
    oBrowse:AddLegend("ZZ1_STATUS == 'D'", "RED", "Desabilitada")
    oBrowse:SetFilterDefault("if(__cUserID != '000000', ZZ1_STATUS == 'H', .T.)")
    oBrowse:DisableDetails()
return oBrowse

static function MenuDef()
    local aOpcoes := {}

    ADD OPTION aOpcoes Title 'Visualizar'   Action 'VIEWDEF.MVCZZ2'   OPERATION MODEL_OPERATION_VIEW   ACCESS 0
    ADD OPTION aOpcoes Title 'Incluir'      Action 'VIEWDEF.MVCZZ1'   OPERATION MODEL_OPERATION_INSERT ACCESS 0
    ADD OPTION aOpcoes Title 'Alterar'      Action 'VIEWDEF.MVCZZ1'   OPERATION MODEL_OPERATION_UPDATE ACCESS 0
    ADD OPTION aOpcoes Title 'Excliuir'     Action 'VIEWDEF.MVCZZ2'   OPERATION MODEL_OPERATION_DELETE ACCESS 0
    ADD OPTION aOpcoes Title 'Executar'     Action 'U_ExecInt()'      OPERATION MODEL_OPERATION_VIEW   ACCESS 0
return aOpcoes

