local speedChanger = 0

--Agora que sei que as funções em lua se comunicam entre os diversos .lua, acho que isso seja mais fácil omega kek

healthDrain = false;

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
		mudarRPCdetalhes('Ato 2')
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
		mudarRPCdetalhes('Ato 3')
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
		mudarRPCdetalhes('Ato 4')
		--triggerEvent("strum swap1", 'nada', 'nada', 'nada', 'nada')
		sai2D()
		doTweenX('florqueanda2EXE', 'florrandom2EXE', 2000, 1.0, 'linear')
		doTweenX('montanhaqueanda1EXE', 'montanhasEXE', 300, 34, 'linear')
		doTweenX('awaqueanda1EXE', 'awaEXE', 300, 34, 'linear')
		doTweenX('eitacachorreiraEXE', 'cachorreiraEXE', 300, 34, 'linear')
	elseif curPhase == 7 then
		--cancelTween('florqueanda2EXE')
		--cancelTween('montanhaqueanda1EXE')
		--cancelTween('awaqueanda1EXE')
		--cancelTween('eitacachorreiraEXE')
		--cancelTween('florqueanda1EXE')
		triggerEvent("strum swap1", 'nada', 'nada', 'nada', 'nada')
		doTweenY('nocumecheira', 'nocume', getProperty('nocume.y')-100, 5, 'smoothstepin')
		-- Maybe add efeito de tremederioa.
		for i = 1,#phase4cheetos do
			removeLuaSprite(phase4cheetos[i])
		end
		for i = 1,#phase5cheetos do
			setProperty(phase5cheetos[i]..'.visible', true)
		end
		entra2D()
		mudarRPCdetalhes('Ato 5')
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
		mudarRPCdetalhes('Ato 6')
		sai2D()
	elseif curPhase == 10 then
		setProperty('gfGroup.visible', true)
		--setCharacterX('dad', dadXPosOriginal)
		--Adicionado aqui sem testar, mas espero que conserte o ato 7 9 e 10
		for i = 1,#phase6cheetos do
			removeLuaSprite(phase6cheetos[i])
		end
		for i = 1,#phase7cheetos do
			setProperty(phase7cheetos[i]..'.visible',true)
		end
		mudarRPCdetalhes('Ato 7')
	elseif curPhase == 11 then
		for i = 1,#phase7cheetos do
			removeLuaSprite(phase7cheetos[i])
		end
		setProperty('gfGroup.visible', false)
		setProperty('phase8.visible',true)
		triggerEvent("Cinematics-CY", '2', '0.5', 'nada', 'nada')
		mudarRPCdetalhes('Ato 8')
	elseif curPhase == 12 then
			removeLuaSprite('phase8')
		for i = 1,#phase9cheetos do
			setProperty(phase9cheetos[i]..'.visible', true)
		end
		doTweenX('espacoqueandadeboa', 'phase9-2', -3000, 80, 'linear')
		doTweenX('deatheggqueanda', 'phase9-3', -2000, 70, 'linear')
		mudarRPCdetalhes('Ato 9')
	elseif curPhase == 13 then	
		triggerEvent("Cinematics-CY", '1', '0.5', 'nada', 'nada')
		--cancelTween('deatheggqueanda')
		for i = 1,#phase9cheetos do
			removeLuaSprite(phase9cheetos[i])
		end
		for i = 1,#phase10cheetos do
			setProperty(phase10cheetos[i]..'.visible',true)
		end
		mudarRPCdetalhes('Epílogo')
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
	pushScriptData("trans")

	precacheImage('Tails')
	--precacheImage('Knuckles')
	precacheImage('Phase3Static')
	precacheImage('vintage')
	precacheImage('NOTE_assets')
	precacheImage("daSTAT")
	precacheImage('splashes/blood')
	precacheImage('pixelUI/NOTE_assets_exezoom')
	precacheImage('pixelUI/NOTE_assets_exezoomENDS')
	precacheSound('stat')
	precacheSound('staticBUZZ')
	precacheSound('exerisadinha')

	makeLuaSprite('oppIcon', 'empty', getProperty('healthBar.y') -80)
		
	--Lembrar de colocar o som da estática inicial aqui tambem
end

function onCreatePost()
	makeLuaSprite('oppIcon', 'empty', 285 ,getProperty('healthBar.y') -80)
	loadGraphic('oppIcon', 'icons/icon-sonicexeAH', 150)
	addAnimation('oppIcon', 'icon/'..getProperty('dad.healthIcon'), {0, 1}, 0, true)
	setProperty('oppIcon.visible', false)
	setObjectCamera('oppIcon', 'camHUD')
	setObjectOrder('oppIcon', getObjectOrder('healthBarBG') + 1)
	addLuaSprite('oppIcon')
	setObjectOrder('oppIcon', getObjectOrder('healthBarBG') + 1)

	makeLuaSprite('bfIcon', 'empty', getProperty('healthBar.width') + 285 ,getProperty('healthBar.y') -80)
	loadGraphic('bfIcon', 'icons/icon-sonicAH', 150)
	addAnimation('bfIcon', 'icon/'..getProperty('bf.healthIcon'), {0, 1}, 0, true)
	setProperty('bfIcon.visible', false)
	setObjectCamera('bfIcon', 'camHUD')
	setObjectOrder('bfIcon', getObjectOrder('healthBarBG') + 2)
	addLuaSprite('bfIcon')
	setObjectOrder('bfIcon', getObjectOrder('healthBarBG') + 2)
end

function onUpdate()
	speedChanger = speedChanger + 1

    if phasedetector == 1 then
	setPropertyTiledLuaSprite("ceu.scrollX", speedChanger*0.5)
    elseif phasedetector == 2 then
    setPropertyTiledLuaSprite("chaorunning1.scrollX", speedChanger*20)
    setPropertyTiledLuaSprite("ceu.scrollX", speedChanger*0.5*10)
	elseif phasedetector == 6 then
	setPropertyTiledLuaSprite("chaorunning1EXE.scrollX", speedChanger*40)
	elseif phasedetector == 9 then
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

function entra2D()
	setProperty('health',1)
	healthDrain = true
	setProperty('isGrad', true)
	setProperty('oppIcon.visible', true)
	setProperty('bfIcon.visible', true)
	setProperty('iconP1.visible', false)
	setProperty('iconP2.visible', false)
	triggerEvent("Cinematics-CY", '1', '0.5', 'nada', 'nada')
end

function sai2D()
	healthDrain = false
	setProperty('health',1) --Design purposes
	setProperty('isGrad', false)
	setProperty('oppIcon.visible', false)
	setProperty('bfIcon.visible', false)
	setProperty('iconP1.visible', true)
	setProperty('iconP2.visible', true)
	triggerEvent("Cinematics-CY", '2', '0.5', 'nada', 'nada')
end
