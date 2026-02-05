local speedChanger = 0

--Agora que sei que as funções em lua se comunicam entre os diversos .lua, acho que isso seja mais fácil omega kek

healthDrain = false
lockAto6Run = false

ato8Change = false;

local phase1unico = {'montesverdes', 'flores', 'trens'}
local phase2cheetos = {'ceu', 'montanhas','cachorreira','awa', 'florrandom1', 'florrandom2', 'chaorunning1'}

--Sim Sim, sou uma pessoa bastante imparcial
local phase3cheetosvilao = {'vilaophase3-1','vilaophase3-2', 'vilaophase3-3'}

local phase3cheetosheroi = {'heroiphase3-1','heroiphase3-2', 'heroiphase3-3'}

local phase4cheetos = {'ceuEXE', 'montanhasEXE','cachorreiraEXE','awaEXE', 'florrandom2EXE', 'florrandom3EXE', 'chaorunning1EXE'}

local phase5cheetos = {'nocume', 'ardia'}

local phase6cheetos = {'angelislandchao', 'angelislandarvores', 'angelislandbg', 'knuxerabos'}

local phase7cheetos = {'phase7-1', 'phase7-2', 'phase7-3', 'phase7-4'}

local phase9cheetos = {'phase9-1', 'phase9-2', 'phase9-3'}

local phase10cheetos = {'phase10-1', 'phase10-2', 'phase10-3'}

local phasedetector = 1

local newValue = -5
local mult = -5


function onBeatHit()
	if healthDrain then
		scaleObject('oppIcon', 1.2, 1.2)
		scaleObject('bfIcon', 1.2, 1.2)
	end
end

lerpa = 0
lerpb = 0
lerpc = 0
acceleration = 0.0145 -- Aceleração constante
totalTime = 1.05 -- Tempo total da animação em segundos
currentTime = 0 -- Tempo atual da animação
prevTime = 0
function onUpdatePost(elapsed)
	if healthDrain then
		mult = lerp(1, getProperty('HUD.iconP1.scale.x'), boundTo(1 - (elapsed * 9), 0, 1));
    	scaleObject('oppIcon', mult, mult)
		scaleObject('bfIcon', mult, mult)
	end
	if phasedetector == 9 and lockAto6Run then
		
        currentTime = currentTime + elapsed
        if currentTime <= totalTime then
            local t = speedChanger - prevTime
            local newPositionA = (-speedChanger*45 + 0.5 * acceleration*45 * t * t)
            local newPositionB = (-speedChanger*20 + 0.5 * acceleration*20 * t * t)
            local newPositionC = (-speedChanger*10 + 0.5 * acceleration*10 * t * t)

            setProperty('angelislandchao.scrollX', newPositionA)
            setProperty('angelislandarvores.scrollX', newPositionB)
            setProperty('angelislandbg.scrollX', newPositionC)
        end
    end
end

function onTimerCompleted(tag)
	if tag == "lockmovement" then
        lockAto6Run = true
		prevTime = speedChanger
        lerpa = -speedChanger * 45
        lerpb = -speedChanger * 20
        lerpc = -speedChanger * 10
        currentTime = 0 -- Reinicia o tempo atual para a nova animação
    end
end

function lerp(a, b, ratio)
    return a + ratio * (b - a)
end

function boundTo(value, min, max)
    if value < min then
        return min
    elseif value > max then
        return max
    else
        return value
    end
end

function changePhases(curPhase) -- Fazer um lua só pra isso.
    phasedetector = curPhase
    if curPhase == 2 then
		for i = 1,#phase1unico do
			removeLuaSprite(phase1unico[i])
		end
		for i = 1,#phase2cheetos do
			setProperty(phase2cheetos[i]..'.visible', true)
		end
		setProperty('gfGroup.visible', false)
		doTweenX('florqueanda1', 'florrandom1', 2000, 2, 'linear')
		doTweenX('montanhaqueanda1', 'montanhas', 400-100, 33, 'linear')
		doTweenX('awaqueanda1', 'awa', 400-250, 33, 'linear')
		doTweenX('eitacachorreira', 'cachorreira', 400-250, 33, 'linear')

		playSound('sonicpeelout', 1, 'peelout')
		triggerEvent("Add Camera Zoom", "8", "0")
		setCamMove(false)
		triggerEvent('Camera Follow Pos',camPosDadX+1800,camPosDadY+150)
		mudarRPCdetalhes('cy_ato_2')
	elseif curPhase == 3 then
		--cancelTween('florqueanda1')
		--cancelTween('montanhaqueanda1')
		--cancelTween('awaqueanda1')
		--cancelTween('eitacachorreira')
		--cancelTween('florqueanda2')
		dueto(true)
		for i = 1,#phase2cheetos do
			removeLuaSprite(phase2cheetos[i])
		end
		for i = 1,#phase3cheetosvilao do
			cameraSetTarget('bf');
			setProperty(phase3cheetosvilao[i]..'.visible', true)
		end
		mudarRPCdetalhes('cy_ato_3')
		entra2D() -- Isso certamente não deveria estar naquele for ali em cima :skull:
	elseif curPhase == 4 then
		for i = 1,#phase3cheetosvilao do
			setProperty(phase3cheetosvilao[i]..'.visible', false)
		end
		for i = 1,#phase3cheetosheroi do
			setProperty(phase3cheetosheroi[i]..'.visible', true)
		end
	elseif curPhase == 5 then
		for i = 1,#phase3cheetosheroi do
			setProperty(phase3cheetosheroi[i]..'.visible', false)
		end
		for i = 1,#phase3cheetosvilao do
			setProperty(phase3cheetosvilao[i]..'.visible', true)
		end
	elseif curPhase == 6 then
		for i = 1,#phase3cheetosheroi do
			removeLuaSprite(phase3cheetosheroi[i])
		end
		for i = 1,#phase3cheetosvilao do
			removeLuaSprite(phase3cheetosvilao[i])
		end
		for i = 1,#phase4cheetos do
			setProperty(phase4cheetos[i]..'.visible', true)
		end
		mudarRPCdetalhes('cy_ato_4')
		--triggerEvent("strum swap1", 'nada', 'nada', 'nada', 'nada')
		sai2D()
		doTweenX('florqueanda2EXE', 'florrandom2EXE', 2000, 1.0, 'linear')
		doTweenX('montanhaqueanda1EXE', 'montanhasEXE', 300, 34, 'linear')
		doTweenX('awaqueanda1EXE', 'awaEXE', 300, 34, 'linear')
		doTweenX('eitacachorreiraEXE', 'cachorreiraEXE', 300, 34, 'linear')
		changeIcon('switch')
	elseif curPhase == 7 then
		--cancelTween('florqueanda2EXE')
		--cancelTween('montanhaqueanda1EXE')
		--cancelTween('awaqueanda1EXE')
		--cancelTween('eitacachorreiraEXE')
		--cancelTween('florqueanda1EXE')
		triggerEvent("strum swap1", 'nada', 'nada', 'nada', 'nada')
		doTweenY('nocumecheira', 'nocume', getProperty('nocume.y')-100, 5, 'smoothstepin')
		--setObjectOrder("videoSpr", getObjectOrder("nocume"))
		--setProperty("videoSpr.x", getProperty("nocume.x"))
		--setProperty("videoSpr.y", getProperty("nocume.y"))
		-- Maybe add efeito de tremederioa.
		for i = 1,#phase4cheetos do
			removeLuaSprite(phase4cheetos[i])
		end
		for i = 1,#phase5cheetos do
			setProperty(phase5cheetos[i]..'.visible', true)
		end
		entra2D()
		mudarRPCdetalhes('cy_ato_5')
		--O code abaixo faz o movimento original da concept da Vio.
		--Como não tenho uma ideia muito boa de como fazer aquilo ser um pouco mais suave.
		--Vou deixar só o code base aqui mesmo.
		--doTweenX('nocumeX','nocume', -875, 30)
		--doTweenY('nocumeY','nocume', -300, 30)
	elseif curPhase == 8 then
		cancelTween('nocumesobem') -- Talvez isso seja nescessário
		cancelTween('nocumedesce')
		
		-- SUS... Para dizer o mínimo k
		setProperty('nocumepausando.visible',true)
		for i = 1,#phase5cheetos do
			removeLuaSprite(phase5cheetos[i])
		end
	elseif curPhase == 9 then
		removeLuaSprite('nocumepausando')
		setProperty('dad.specialAnim', false)
		for i = 1,#phase6cheetos do
			setProperty(phase6cheetos[i]..'.visible',true)
		end		
		mudarRPCdetalhes('cy_ato_6')
		sai2D()
		setProperty("cambump_allowed", false)
		setProperty('HUD.bfIsLeft', false)
	elseif curPhase == 10 then
		setProperty("cambump_allowed", true)
		setProperty('gfGroup.visible', true)
		--setCharacterX('dad', dadXPosOriginal)
		--Adicionado aqui sem testar, mas espero que conserte o ato 7 9 e 10
		for i = 1,#phase6cheetos do
			removeLuaSprite(phase6cheetos[i])
		end
		for i = 1,#phase7cheetos do
			setProperty(phase7cheetos[i]..'.visible',true)
		end
		mudarRPCdetalhes('cy_ato_7')
	elseif curPhase == 11 then
		for i = 1,#phase7cheetos do
			removeLuaSprite(phase7cheetos[i])
		end
		setProperty('gfGroup.visible', false)
		setProperty('phase8.visible',true)
		triggerEvent("Cinematics-CY", '2', '0.5', 'nada', 'nada')
		mudarRPCdetalhes('cy_ato_8')
		ato8Change = true
		entra2D()
	elseif curPhase == 12 then
			removeLuaSprite('phase8')
			sai2D()
		for i = 1,#phase9cheetos do
			setProperty(phase9cheetos[i]..'.visible', true)
		end
		doTweenX('espacoqueandadeboa', 'phase9-2', -3000, 80, 'linear')
		doTweenX('deatheggqueanda', 'phase9-3', -2000, 70, 'linear')
		mudarRPCdetalhes('cy_ato_9')

		--Trocar lados...

	elseif curPhase == 13 then	
		triggerEvent("Cinematics-CY", '1', '0.5', 'nada', 'nada')
		--cancelTween('deatheggqueanda')
		for i = 1,#phase9cheetos do
			removeLuaSprite(phase9cheetos[i])
		end
		for i = 1,#phase10cheetos do
			setProperty(phase10cheetos[i]..'.visible',true)
		end
		triggerEvent("strum swap2", "cy", 'false')
		mudarRPCdetalhes('cy_ato_10')
		doTweenY('pedrasobe1', 'phase10-2', getProperty('phase10-2.y')-20, 1, 'smoothstepin')
		doTweenY('pedrasobe2', 'phase10-3', getProperty('phase10-3.y')-20, 1, 'smoothstepin')

	end
end
function onEvent(name, value1, value2)
	if name == "trocar stage" then
		changePhases(tonumber(value1))
    end
end

function onTweenCompleted(tag) --a
	if tag == 'florqueanda1' and phasedetector == 2 then 
		setProperty('florrandom1.x', -2000)
		doTweenX('florqueanda2', 'florrandom2', 2000, 2, 'linear')
	end
	if tag == 'florqueanda2' and phasedetector == 2 then 
		setProperty('florrandom2.x', -2000)
		doTweenX('florqueanda1', 'florrandom1', 2000, 2, 'linear')
	end
	if tag == 'florqueanda1EXE' and phasedetector == 6 then 
		setProperty('florrandom3EXE.x', -2000)
		doTweenX('florqueanda2EXE', 'florrandom2EXE', 2000, 1.0, 'linear')
	end
	if tag == 'florqueanda2EXE' and phasedetector == 6 then 
		setProperty('florrandom2EXE.x', -2000)
		doTweenX('florqueanda1EXE', 'florrandom3EXE', 2000, 1.0, 'linear')
	end
	if tag == 'nocumecheira' or  tag == 'nocumesobem' then
		doTweenY('nocumedesce', 'nocume', getProperty('nocume.y')+50, 3, 'sineinout')
	end -- Maybe deixar isso mais demorado resolva algo
	if tag == 'nocumedesce' then
		doTweenY('nocumesobem', 'nocume', getProperty('nocume.y')-50, 3, 'sineinout')
	end
	if tag == 'pedrasobe1' then 
		doTweenY('pedradesce1', 'phase10-2', getProperty('phase10-2.y')+20, 1, 'sineinout')
	end
	if tag == 'pedradesce1' then 
		doTweenY('pedrasobe1', 'phase10-2', getProperty('phase10-2.y')-20, 1, 'sineinout')
	end
	if tag == 'pedrasobe2' then
		doTweenY('pedradesce2', 'phase10-3', getProperty('phase10-3.y')+20, 1, 'sineinout')
	end
	if tag == 'pedradesce2' then
		doTweenY('pedrasobe2', 'phase10-3', getProperty('phase10-3.y')-20, 1, 'sineinout')
	end
	

end

function onCreate()

	addCharacterToList('Sonic Pixel Running ato4', 'bf')
    addCharacterToList('Sonic Exe Pixel Flying ato4', 'dad')
	
	pushScriptData("trans")

	precacheImage('Tails')
	--precacheImage('Knuckles')
	precacheImage('Phase3Static')
	precacheImage('vintage')
	precacheImage('NOTE_assets')
	precacheImage('splashes/blood')
	precacheImage('pixelUI/NOTE_assets_exezoom')
	precacheImage('pixelUI/NOTE_assets_exezoomENDS')
	--precacheSound('stat')
	precacheSound("sonicpeelout")
	precacheSound('exerisadinha')

	--setGameover('sonic', 'gameOverEndSonic', 'breakfast')

	setPropertyFromClass('GameOverSubstate', 'bgType', 'sonic'); --Character json file for the death animation
    setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'gameOverEndSonic'); --put in mods/sounds/
    setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'breakfast'); --put in mods/sounds/
end

function onCreatePost()
	lockAto6Run = false
	--Icons code
	makeLuaSprite('oppIcon', 'empty', 230 ,getProperty('HUD.healthBar.y') -80)
	loadGraphic('oppIcon', 'icons/cy/sonicexeAH', 150)
	addAnimation('oppIcon', 'icon/'..getProperty('dad.healthIcon'), {0, 1}, 0, true)
	setProperty('oppIcon.visible', false)
	setObjectCamera('oppIcon', 'camHUD')
	addLuaSprite('oppIcon')
	setObjectOrder('oppIcon', getObjectOrder('HUD.healthBarBG') + 5)

	makeLuaSprite('bfIcon', 'empty', getProperty('HUD.healthBar.width') + 285 ,getProperty('HUD.healthBar.y') -80)
	loadGraphic('bfIcon', 'icons/cy/sonicAH', 150)
	addAnimation('bfIcon', 'icon/'..getProperty('boyfriend.healthIcon'), {0, 1}, 0, true)
	setProperty('bfIcon.visible', false)
	setObjectCamera('bfIcon', 'camHUD')
	addLuaSprite('bfIcon')
	setObjectOrder('bfIcon', getObjectOrder('HUD.healthBarBG') + 6)

	--Ring code
	makeAnimatedLuaSprite('healthFollower', 'ring', getProperty('HUD.healthBar.x') + getProperty('HUD.healthBar.width')*getProperty('health')/2 ,getProperty('HUD.healthBarBG.y')-27)
	addAnimationByPrefix('healthFollower', 'idle', 'ring idle', 12, true)
	objectPlayAnimation('healthFollower', 'idle', true)
	setProperty('healthFollower.visible', false)
	setObjectCamera('healthFollower', 'hud')
	setGraphicSize('healthFollower', 75)

	addLuaSprite('healthFollower')
	setObjectOrder('healthFollower', getObjectOrder('HUD.healthBarBG') + 4)
end


function onUpdate()
	if healthDrain then
		if getProperty('health') < 0.25 then
			objectPlayIndexedAnimation('bfIcon', 1)
		elseif getProperty('health') > 1.8 then
			objectPlayIndexedAnimation('oppIcon', 1)
		else
			objectPlayIndexedAnimation('oppIcon', 0)
			objectPlayIndexedAnimation('bfIcon', 0)
		end
		-- Caso o sonico esteja na esquerda e o opp esteja na direita, é a formula abaixo
		-- setProperty('healthFollower.x', getProperty('HUD.healthBar.x') + getProperty('HUD.healthBar.width')*getProperty('health')/2)
		-- Caso contrário, bf na direita e opp na esquerda (que é o caso da CY), então...
		if (getProperty('health') >= 0.05 and getProperty('health') <= 1.95)then
			setProperty('healthFollower.x', getProperty('HUD.healthBar.x') - 35 + getProperty('HUD.healthBar.width')*((2-getProperty('health'))/2))
		end
		setProperty('healthFollower.angle', getProperty('healthFollower.angle')+36/60)
	end
	speedChanger = speedChanger + 1

    if phasedetector == 1 then
	setPropertyTiledLuaSprite("ceu.scrollX", speedChanger*0.5)
    elseif phasedetector == 2 then
    setPropertyTiledLuaSprite("chaorunning1.scrollX", speedChanger*20)
    setPropertyTiledLuaSprite("ceu.scrollX", speedChanger*0.5*10)
	elseif phasedetector == 6 then
	setPropertyTiledLuaSprite("chaorunning1EXE.scrollX", speedChanger*40)
	elseif phasedetector == 9 and not lockAto6Run then
	setPropertyTiledLuaSprite("angelislandchao.scrollX", -speedChanger*45)
	setPropertyTiledLuaSprite("angelislandarvores.scrollX", -speedChanger*20)
	setPropertyTiledLuaSprite("angelislandbg.scrollX", -speedChanger*10)
	elseif phasedetector == 12 then
	setPropertyTiledLuaSprite("phase9-1.scrollX", -speedChanger*60)
	end
end

function opponentNoteHit()
	if phasedetector == 13 then -- OOOOOOMAGAWD, ELE É LULISTA, RÁPIDO, FALE ALGO DO BOLSONARO...
		triggerEvent('Screen Shake', '0.015, 0.015', '0, 0')
	end
	if healthDrain and getProperty('health') > 0.15 then
		setProperty('health', getProperty('health') - 0.01)
	end
end

prevTwisted = false

function entra2D()
	setProperty('health',1)
	healthDrain = true
	setProperty('oppIcon.visible', true)
	setProperty('bfIcon.visible', true)
	setProperty('healthFollower.visible', true)
	setProperty('HUD.iconP1.visible', false)
	prevTwisted = getProperty('HUD.bfIsLeft')
	setProperty('HUD.bfIsLeft', false)
	setProperty('HUD.iconP2.visible', false)
	changeHealthBar(true)
	triggerEvent("Cinematics-CY", '1', '0.5', 'nada', 'nada')
	if ato8Change then
		loadGraphic('oppIcon', 'icons/ycr/xeno-ycr_pixel', 150)
		loadGraphic('bfIcon', 'icons/sonic icons', 150)
	end
end

function sai2D()
	healthDrain = false
	setProperty('health',1) --Design purposes
	setProperty('HUD.bfIsLeft', prevTwisted)
	setProperty('healthFollower.visible', false)
	setProperty('oppIcon.visible', false)
	setProperty('bfIcon.visible', false)
	setProperty('HUD.iconP1.visible', true)
	setProperty('HUD.iconP2.visible', true)
	changeHealthBar(false)
	triggerEvent("Cinematics-CY", '2', '0.5', 'nada', 'nada')
end
