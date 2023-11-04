-- Esse primeiro script serve apenas para configurar aquela introzinha maneira lá.
-- Assim que isso acabar, ele chamará a função transAto2 que cuida da transição obviamente, e encerra o script pra economizar memória.

function onCreate()
    makeAnimatedLuaSprite('sonicIntro1', 'intro/sonic', 0, 0)
    addAnimationByPrefix('sonicIntro1', 'preEntrada', 'vazio', 24, true)
    addAnimationByPrefix('sonicIntro1', 'entrada', 'spawnfull', 24, false)
    addAnimationByPrefix('sonicIntro1', 'idle', 'idlefull', 24, true)
    addAnimationByPrefix('sonicIntro1', 'preAttack', 'eh', 24, false)
    addAnimationByPrefix('sonicIntro1', 'attack', 'hi', 11, false)
    addOffset('sonicIntro1', 'attack', -46, 20)
    setObjectCamera('sonicIntro1', 'camother')
    playAnim('sonicIntro1', 'preEntrada', true)
    setProperty('sonicIntro1.alpha', 1)
    scaleObject('sonicIntro1', 1.6, 1.6)
    screenCenter('sonicIntro1')
    setProperty('sonicIntro1.x', getProperty('sonicIntro1.x'))
    setProperty('sonicIntro1.y', getProperty('sonicIntro1.y'))

    addLuaSprite('sonicIntro1')

end

function onCountdownTick(tick)
    if tick == 3 then
        playAnim('sonicIntro1', 'entrada')
    end
end

function onSongStart()
    playAnim('sonicIntro1', 'idle', true)
end

function onEvent(name, value1, value2)
    if name == 'trocar ato' then
        if value1 == '21' then
            playAnim('sonicIntro1', 'preAttack', true)
        end
    end
    if name == 'trocar ato' then
        if value1 == '22' then
            playAnim('sonicIntro1', 'attack', true)
        end
    end
    if name == 'trocar ato' then
        if value1 == '43' then
            transAto2()
        end
    end
end

function transAto2()
    cameraFlash('legenda', '0xff0000', 2, true)
    removeLuaSprite('sonicIntro1', true)
    --close()
end