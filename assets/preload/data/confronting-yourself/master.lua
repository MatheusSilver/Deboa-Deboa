local speedChanger = 0

local phase1unico = {'montesverdes', 'flores', 'trens'}
local phase2cheetos = {'ceu', 'montanhas','cachorreira','awa', 'florrandom1', 'florrandom2', 'chaorunning1'}

--Sim Sim, sou uma pessoa bastante imparcial
local phase3cheetosvilao = {'vilaophase3-1','vilaophase3-2', 'vilaophase3-3'}

local phase3cheetosheroi = {'heroiphase3-1','heroiphase3-2', 'heroiphase3-3'}

local phase4cheetos = {'ceuEXE', 'montanhasEXE','cachorreiraEXE','awaEXE', 'florrandom2EXE', 'florrandom3EXE', 'chaorunning1EXE'}

local phase5cheetos = {'nocume', 'ardia'}

local phase6cheetos = {'angelislandchao', 'angelislandarvores', 'angelislandbg'}

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
		doTweenX('florqueanda1', 'florrandom1', 2000, 3.5, 'linear')
		doTweenX('montanhaqueanda1', 'montanhas', 400-100, 33, 'linear')
		doTweenX('awaqueanda1', 'awa', 400-250, 33, 'linear')
		doTweenX('eitacachorreira', 'cachorreira', 400-250, 33, 'linear')
	elseif curPhase == 3 then
		for i = 1,#phase2cheetos do
			removeLuaSprite(phase2cheetos[i]..'.visible', false)
		end
		for i = 1,#phase3cheetosvilao do
			setProperty(phase3cheetosvilao[i]..'.visible', true)
		end
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
		doTweenX('florqueanda2EXE', 'florrandom2EXE', 2000, 3, 'linear')
		doTweenX('montanhaqueanda1EXE', 'montanhasEXE', 400, 34, 'linear')
		doTweenX('awaqueanda1EXE', 'awaEXE', 400, 34, 'linear')
		doTweenX('eitacachorreiraEXE', 'cachorreiraEXE', 400, 34, 'linear')
	elseif curPhase == 7 then
		setProperty("defaultCamZoom",0.65)
		for i = 1,#phase1unico do
			setProperty(phase1unico[i]..'.visible', false)
		end
		for i = 1,#phase2cheetos do
			setProperty(phase2cheetos[i]..'.visible', false)
		end
		for i = 1,#phase5cheetos do
			setProperty(phase5cheetos[i]..'.visible', true)
		end
		setProperty('nocumepausando.visible',false)
	elseif curPhase == 8 then
		
		for i = 1,#phase1unico do
			setProperty(phase1unico[i]..'.visible', false)
		end
		for i = 1,#phase2cheetos do
			setProperty(phase2cheetos[i]..'.visible', false)
		end
		for i = 1,#phase6cheetos do
			setProperty(phase6cheetos[i]..'.visible',true)
			setProperty("defaultCamZoom",0.8) -- OU VAI OU VAI...
		end		
	elseif curPhase == 9 then
		setProperty("defaultCamZoom",0.75)
		for i = 1,#phase1unico do
			setProperty(phase1unico[i]..'.visible', false)
		end
		for i = 1,#phase2cheetos do
			setProperty(phase2cheetos[i]..'.visible', false)
		end
		for i = 1,#phase7cheetos do
			setProperty(phase7cheetos[i]..'.visible',true)
		end
	elseif curPhase == 10 then 	--0.75 de zoom
		setProperty("defaultCamZoom",0.8)
		for i = 1,#phase1unico do
			setProperty(phase1unico[i]..'.visible', false)
		end
		for i = 1,#phase2cheetos do
			setProperty(phase2cheetos[i]..'.visible', false)
		end
		setProperty('phase8.visible',true)
	elseif curPhase == 11 then 	--0.75 de zoom
		setProperty("defaultCamZoom",0.65)
		for i = 1,#phase1unico do
			setProperty(phase1unico[i]..'.visible', false)
		end
		for i = 1,#phase2cheetos do
			setProperty(phase2cheetos[i]..'.visible', false)
		end
		for i = 1,#phase9cheetos do
			setProperty(phase9cheetos[i]..'.visible', true)
		end
	elseif curPhase == 12 then	
		for i = 1,#phase1unico do
			setProperty(phase1unico[i]..'.visible', false)
		end
		for i = 1,#phase2cheetos do
			setProperty(phase2cheetos[i]..'.visible', false)
		end
		for i = 1,#phase10cheetos do
			setProperty(phase10cheetos[i]..'.visible',true)
			setProperty("defaultCamZoom",0.8) -- OU VAI OU VAI...
		end		
	end
end
function onEvent(name, value1, value2)
	if name == "trocar stage" then
		changePhases(tonumber(value1))
    end
end

function onTweenCompleted(tag)
	if tag == 'florqueanda1' and phasedetector == 2 then 
		setProperty('florrandom1.x', -2000)
		doTweenX('florqueanda2', 'florrandom2', 2000, 3.5, 'linear')
	end
	if tag == 'florqueanda2' and phasedetector == 2 then 
		setProperty('florrandom2.x', -2000)
		doTweenX('florqueanda1', 'florrandom1', 2000, 3.5, 'linear')
	end
	if tag == 'florqueanda1EXE' and phasedetector == 6 then 
		setProperty('florrandom3EXE.x', -2000)
		doTweenX('florqueanda2EXE', 'florrandom2EXE', 2000, 3, 'linear')
	end
	if tag == 'florqueanda2EXE' and phasedetector == 6 then 
		setProperty('florrandom2EXE.x', -2000)
		doTweenX('florqueanda1EXE', 'florrandom3EXE', 2000, 3, 'linear')
	end
end

function onUpdate()
	speedChanger = speedChanger + 1

    if phasedetector == 1 then
	setPropertyTiledLuaSprite("ceu.scrollX", speedChanger*0.5)
    elseif phasedetector == 2 then
    setPropertyTiledLuaSprite("chaorunning1.scrollX", speedChanger*20)
    setPropertyTiledLuaSprite("ceu.scrollX", speedChanger*0.5*10)
	elseif phasedetector == 6 then
	setPropertyTiledLuaSprite("chaorunning1EXE.scrollX", speedChanger*30)
	end

	setPropertyTiledLuaSprite("angelislandchao.scrollX", -speedChanger*45)
	setPropertyTiledLuaSprite("angelislandarvores.scrollX", -speedChanger*20)
	setPropertyTiledLuaSprite("angelislandbg.scrollX", -speedChanger*10)

	setPropertyTiledLuaSprite("phase9-1.scrollX", -speedChanger*60)
	setPropertyTiledLuaSprite("phase9-2.scrollX", -speedChanger*5)

	if keyJustPressed("space") then
		changePhases(phasedetector+1) 
	end
end
