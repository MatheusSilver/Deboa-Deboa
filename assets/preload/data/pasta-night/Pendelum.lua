-- Code made by Drawoon_
-- If you use this please give me credit
-- E "otimizado" pelo chat gpt (honestamente não achei que fosse funcionar)
-- Na maior parte o bixo só encheu o código de micro funções e bugou o shadow 
-- Ele também criou variáveis booleanas que nunca mudam, provavelmente assumindo que esse code está sempre rodando
-- E essas variáveis mudam em algum outro lugar.
-- Anyway, acho que a melhor coisa que ele fez foi funcionalizar o code.

-- Declare local variables
local beatInterval, Starter, tranceInterval, trance, VolumeStatic
local psyshockCooldown = 80

function onCreate()
    beatInterval = 2 -- Pendulum Interval
    Starter = false
    tranceInterval = 0
    trance = 0
    VolumeStatic = 0
    psyshockCooldown = 80

    initializePendulum()
    initializeStatic()
    initializeAnswerSign()
    initializePsyshock()
end
function onSongStart()
    Starter = true
end
function onUpdate(elapsed)
    if Starter then
        updatePendulum()
    end

    handleAnimationCompletion()
    handleTrance()
end
function SetInterval(new)
    beatInterval = new
end
function GoodPendelum()
    trance = trance - 0.075
    updateShadowPendulum()
    setProperty('answer_sign.visible', true)
    playAnim('answer_sign', 'Tick', true)
end
function BadPendelum()
    trance = trance + 0.115
    setProperty('answer_sign.visible', true)
    playAnim('answer_sign', 'X', true)
end
function onSoundFinished(tag)
    if tag == 'TranceSound' then
        playSound('TranceStatic', VolumeStatic, 'TranceSound')
    end
end
function onStepHit()
    if getSongPosition() > 20000 then
        handlePsyshockCooldown()
    end
end
function Psyshock()
    setProperty('Psyshock.alpha', 1)
    playAnim('Psyshock', 'Psyshock')
    playSound('Psyshock', 0.6)
    if flashing then
        cameraFlash('camHUD', '0xFFFFAFC1', 1)
    end
    trance = trance + 0.25
end
function PsyshockCalculate(Start, Ending)
    local t = Start + (getSongPosition() / songLength) * (Ending - Start)
    local Result = stringSplit(t, '.')
    return tonumber(Result[1])
end
-- Additional functions
function initializePendulum()
    makeAnimatedLuaSprite('ShadowPendelum', 'Pendelum_Phase2', 0, 0)
    setObjectCamera('ShadowPendelum', 'camHUD')
    addAnimationByPrefix('ShadowPendelum', 'idle', 'Pendelum Phase 2', 24, true)
    setProperty('ShadowPendelum.origin.y', 0)
    screenCenter('ShadowPendelum', 'x')
    setProperty('ShadowPendelum.alpha', 0.5)
    addLuaSprite('ShadowPendelum')

    makeAnimatedLuaSprite('Pendelum', 'Pendelum_Phase2', 0, 0)
    setObjectCamera('Pendelum', 'camHUD')
    addAnimationByPrefix('Pendelum', 'idle', 'Pendelum Phase 2', 24, true)
    setProperty('Pendelum.origin.y', 0)
    screenCenter('Pendelum', 'x')
    addLuaSprite('Pendelum')
end
function initializeStatic()
    makeAnimatedLuaSprite('Static', 'StaticHypno', 0, 0)
    setObjectCamera('Static', 'camHUD')
    setGraphicSize('Static', screenWidth, screenHeight)
    addAnimationByPrefix('Static', 'Idle', 'StaticHypno', 24, true)
    setProperty('Static.alpha', 0)
    addLuaSprite('Static', true)
end
function initializeAnswerSign()
    makeAnimatedLuaSprite("answer_sign", "Extras", 530, 360)
    setObjectCamera("answer_sign", "camHUD")
    addAnimationByPrefix('answer_sign', 'Tick', 'Checkmark', 24, false)
    addAnimationByPrefix('answer_sign', 'X', 'X finished', 24, false)
    setProperty('answer_sign.visible', false)
    addLuaSprite('answer_sign')
end
function initializePsyshock()
    makeAnimatedLuaSprite('Psyshock', 'Psyshock', 530, 370)
    scaleObject('Psyshock', 0.85, 0.85)
    addAnimationByPrefix('Psyshock', 'Psyshock', 'Full Psyshock Particle', 24, false)
    setProperty('Psyshock.alpha', 1)
    addLuaSprite('Psyshock', true)
end
function updatePendulum()
    local convertedTime = ((getSongPosition() / (crochet * beatInterval)) * math.pi)
    setProperty('Pendelum.angle', (math.sin(convertedTime) * 32))
    local pendulumTimeframe = math.floor(((convertedTime / math.pi) - math.floor(convertedTime / math.pi)) * 1000) / 1000
    local reach = 0.2;
    if pendulumTimeframe < reach or pendulumTimeframe > (1 - reach) then
        if not alreadyHit then
            canHitPendulum = true
        end
    else
        alreadyHit = false
        if canHitPendulum then
            if tranceInterval % 2 == 0 then
                BadPendelum()
                canHitPendulum = false
            end
        end
    end
    if keyJustPressed('space') and not alreadyHit then
        if canHitPendulum then
            alreadyHit = true
            canHitPendulum = false
            GoodPendelum()
        else
            BadPendelum()
        end
    end
    if botPlay and not alreadyHit and canHitPendulum then
        alreadyHit = true
        canHitPendulum = false
        GoodPendelum()
    end
end
function updateShadowPendulum()
    setProperty('ShadowPendelum.alpha', 0.5)
    setProperty('ShadowPendelum.angle', getProperty('Pendelum.angle'))
    doTweenAlpha('Shadow', 'ShadowPendelum', 0, 0.5, 'Linear')
end
function handleAnimationCompletion()
    if getProperty('answer_sign.animation.curAnim.finished') then
        setProperty('answer_sign.visible', false)
    end
    if getProperty('Psyshock.animation.curAnim.finished') then
        setProperty('Psyshock.alpha', 0)
    end
end
function handleTrance()
    setProperty('Static.alpha', trance / 2)
    if trance > 1 then
        VolumeStatic = (trance - 1) / 2
        setSoundVolume('TranceSound', VolumeStatic)
    else
        VolumeStatic = 0
    end
    if trance > 2 then
        trance = 2
        setHealth(-1)
    end
    if trance < -0.25 then
        trance = -0.25
    end
end
function handlePsyshockCooldown()
    if psyshockCooldown <= 0 then
        Psyshock()
        psyshockCooldown = PsyshockCalculate(75, 40)
    else
        psyshockCooldown = psyshockCooldown - 1
    end
end
