function onCreate()
    -- pushScriptData("FLIPHPBarIconsMainCode")
    addCharacterToList('BFRerun', 'bf')
    addCharacterToList('Nothing', 'bf')
    addCharacterToList('BFRerunDead', 'bf')
    addCharacterToList('BFRerunhurt', 'bf')

    addCharacterToList('DiabloFake1', 'dad')
    addCharacterToList('DiabloFake2', 'dad')
    addCharacterToList('DiabloNormal', 'dad')
    addCharacterToList('DiabloUnMasked', 'dad')
    addCharacterToList('NothingDad', 'dad')
end


-- Sim... Existe uma maneira mais fácil de fazer isso, mas né, só para não quebrar a outra parte da música
-- Decidi complicar o começo.

-- Se o programador da Drop And Roll estiver lendo isso, saiba que teu código foi o mais confuso entre todas as músicas portadas para o ModBoa...
function onStartCountdown()
    for i = 0, 4, 1 do
        setPropertyFromGroup('playerStrums', i, 'alpha', 0)
    end
    for i = 0, 4, 1 do
        setPropertyFromGroup('opponentStrums', i, 'alpha', 0)
    end
    
    setProperty("HUD.healthBar.alpha", 0)
    setProperty("HUD.iconP1.alpha", 0)
    setProperty("HUD.iconP2.alpha", 0)
    setProperty("HUD.scoreTxt.alpha", 0)
    setProperty("HUD.timeBar.alpha", 0)
    setProperty("HUD.timeTxt.alpha", 0)
    setProperty("HUD.botplayTxt.alpha", 0)
end
