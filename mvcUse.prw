#include "totvs.ch"
#include "FWMVCDEF.ch"

user function MVCZZ1()
    RPCSetEnv("99","01")
    
    local lOK     := .T.
    local oModel  := FWLoadModel("MVCZZ2")
    //local oMdlZZ1 := oModel:GetModel("ZZ1MASTER")
    local nI, aErros := {}, aCampos := {}

    oModel:SetOperation(MODEL_OPERATION_INSERT)
    oModel:Activate()

    aAdd(aCampos, {"ZZ1_FINALI", upper("Busca Logradouras API ViaCEP")})
    aAdd(aCampos, {"ZZ1_METODO", "G"})
    aAdd(aCampos, {"ZZ1_STATUS", "D"})

    for nI := 1 to len(aCampos)
        //if !oMdlZZ1:SetValue(aCampos[nI,1], aCampos[nI, 2])
        if !FWFldPut(aCampos[nI,1], aCampos[nI, 2])
            aAdd(aErros, oModel:GetErrorMessage())
            lOK := .F.
        endif
    next

    if lOK .and. oModel:VldData() .and. oModel:CommitData()
        lOK := .T.
    else
        aAdd(aErros, oModel:GetErrorMessage())
        lOK := .F.
    endif

    If(lOK, nil, mostraErro(aErros))

    oModel:DeActivate(
    RPCClearEnv()
return

static function mostraErro(aErros)
    local nI

    for nI := 1 to len(aErros)
        alert(aErros[nI, MODEL_MSGERR_MESSAGE])
    next nI
return


user function AddBtn() AS Array
    local aRet := {{'Executar', 'SALVAR', {|| U_ExecInt()}, 'Executar Integração'}}
return aRet

user function ExecInt()
    local xRet
    local lOK       AS Logical
    local cEndPoint := rtrim(ZZ1->ZZ1_ENDPT)
    local cFuncao   := rtrim(ZZ1->ZZ1_FUNCAO)
    local cMetodo   := ZZ1->ZZ1_METODO
    local cResult   AS Character
    local oRest     := FWRest():New(cEndPoint)
    
    if ZZ1->ZZ1_STATUS == 'D'
        msgAlert("A integração está desabilitada para uso!")
        return
    endif
    if ExistBlock(cFuncao)
        xRet := ExecBlock(cFuncao)
    endif

    do case
        case cMetodo == 'A'
        case cMetodo == 'G'
            oRest:SetPath(xRet)
            if oRest:Get()
                cResult := decodeUTF8(oRest:GetResult())
                lOK := .T.
            else
                cResult := decodeUTF8(oRest:GetLastError())
                lOK := .F.
            endif
            gravaLog(lOK, cResult)
        case cMetodo == 'P'
        case cMetodo == 'U'
    endcase 
    freeObj(oRest)
return

user function ViaCEP() AS Character
    local cCEP := FWInputBox("Insira o CEP que deseja consultar:")
    
    cCEP := '/' + alltrim(cCEP) + "/json"
return cCEP

static function gravaLog(lOK, cResult)
    local oModel  := FWLoadModel("MVCZZ2")
    local oMdlZZ2 := oModel:GetModel("ZZ2DETAIL")
    local nLines  := oMdlZZ2:Length()

    local nI, aErros, aCampos

    oModel:SetOperation(MODEL_OPERATION_UPDATE)
    oModel:Activate()

    aCampos := {}
    aAdd(aCampos, {"ZZ2_STATUS", if(lOK, 'F', 'E')})
    aAdd(aCampos, {"ZZ2_TASKID", ZZ1->ZZ1_ID})
    aAdd(aCampos, {"ZZ2_DATAEX", Date()})
    aAdd(aCampos, {"ZZ2_HORAEX", Time()})
    aAdd(aCampos, {"ZZ2_RESULT", cResult})

    lOK := .T.

    if oMdlZZ2:AddLine() > nLines
        aErros := {}

        for nI := 1 to len(aCampos)
            if !FWFldPut(aCampos[nI,1], aCampos[nI, 2])
                aAdd(aErros, oModel:GetErrorMessage())
                lOK := .F.
            endif
        next
    else
    endif

    if lOK .and. oModel:VldData() .and. oModel:CommitData()
        lOK := .T.
    else
        aAdd(aErros, oModel:GetErrorMessage())
        lOK := .F.
    endif

    If(lOK, nil, mostraErro(aErros))

    oModel:DeActivate()
return
