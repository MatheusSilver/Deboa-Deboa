local speedChanger = 0

local phase1unico = {'montesverdes', 'flores', 'trens'}
local phase2cheetos = {'ceu', 'montanhas','cachorreira','awa', 'florrandom1', 'chaorunning1'}

--Sim Sim, sou uma pessoa bastante imparcial
local phase3cheetosvilao = {'vilaophase3-1','vilaophase3-2', 'vilaophase3-3'}

local phase3cheetosheroi = {'heroiphase3-1','heroiphase3-2', 'heroiphase3-3'}

local phase4cheetos = {'ceuEXE', 'montanhasEXE','cachorreiraEXE','awaEXE', 'florrandom2EXE', 'florrandom3EXE', 'chaorunning1EXE'}

local phase5cheetos = {'nocume', 'ardia'}

local phase6cheetos = {'angelislandchao', 'angelislandarvores', 'angelislandbg'}

local phase7cheetos = {'phase7-1', 'phase7-2', 'phase7-3', 'phase7-4'}

local phase9cheetos = {'phase9-1', 'phase9-2', 'phase9-3'}

local phase10cheetos = {'phase10-1', 'phase10-2', 'phase10-3'}

function onCreatePost()
	--setProperty("boyfriendGroup.visible", false)
	--setProperty('dadGroup.visible', false)
end

function onCreate()
	

	--phase1 stuff
	makeLuaTiledSprite('ceu','cenarios/phase1/ceu',2000,310,true,false) --1
	setLuaSpriteScrollFactor('ceu',0.4,0.4)
	setPropertyTiledLuaSprite("ceu.antialiasing", false)
	setPropertyTiledLuaSprite("ceu.x", -555)
	setPropertyTiledLuaSprite("ceu.y", -260)
	addLuaSprite('ceu');

	makeLuaSprite('montanhas','cenarios/phase1/montanhas',75-200,105-43) --2
	setLuaSpriteScrollFactor('montanhas',0.5,0.5)
	setProperty('montanhas.scale.x', 5)
	setProperty('montanhas.scale.y', 4.5)
	setProperty('montanhas.antialiasing', false)
	addLuaSprite('montanhas',false)

	makeAnimatedLuaSprite('cachorreira','cenarios/phase1/cachorreira',-50-300,295-35) --3
	setLuaSpriteScrollFactor('cachorreira',0.6,0.6)
	addAnimationByPrefix('cachorreira', 'bg2', 'bg2', 16, true);
	setProperty('cachorreira.antialiasing', false)
	setProperty('cachorreira.scale.x', 5)
	setProperty('cachorreira.scale.y', 5)
	addLuaSprite('cachorreira',false)
	objectPlayAnimation('cachorreira', 'bg2', true)

	makeAnimatedLuaSprite('awa','cenarios/phase1/awa',-80-300,580-35) --4
	setLuaSpriteScrollFactor('awa',0.6,0.6)
	addAnimationByPrefix('awa', 'bg1', 'bg1', 16, true);
	setProperty('awa.scale.x', 5)
	setProperty('awa.scale.y', 5)
	setProperty('awa.antialiasing', false)
	addLuaSprite('awa',false)
	objectPlayAnimation('awa', 'bg1', true)

	makeLuaSprite('montesverdes','cenarios/phase1/GHGround',150,100)--5
	setLuaSpriteScrollFactor('montesverdes',0.7,0.7)
	setProperty('montesverdes.scale.x', 5)
	setProperty('montesverdes.scale.y', 5)
	setProperty('montesverdes.antialiasing', false)
	addLuaSprite('montesverdes',false)

	makeAnimatedLuaSprite('flores','cenarios/phase1/flowers',150,105) --6
	setLuaSpriteScrollFactor('flores',0.7,0.7)
	addAnimationByPrefix('flores', 'flowerloop', 'flowerloop', 16, true);
	setProperty('flores.antialiasing', false)
	setProperty('flores.scale.x', 5)
	setProperty('flores.scale.y', 5)
	addLuaSprite('flores',false)
	objectPlayAnimation('flores', 'flowerloop', true)

	makeAnimatedLuaSprite('trens','cenarios/phase1/objects',150,100) --7
	setLuaSpriteScrollFactor('trens',0.7,0.7)
	addAnimationByPrefix('trens', 'objects', 'objects', 16, true);
	setProperty('trens.antialiasing', false)
	setProperty('trens.scale.x', 5)
	setProperty('trens.scale.y', 5)
	addLuaSprite('trens',false)
	objectPlayAnimation('trens', 'objects', true)


	--phase 2 cheetos
	makeLuaSprite('florrandom1','cenarios/phase2/random1',-2000,40)--5
	setLuaSpriteScrollFactor('florrandom1',0.7,0.7)
	setProperty('florrandom1.scale.x', 5)
	setProperty('florrandom1.scale.y', 5)
	setProperty('florrandom1.antialiasing', false)
	setProperty('florrandom1.visible', false)
	addLuaSprite('florrandom1',false)

	makeLuaTiledSprite('chaorunning1','cenarios/phase2/floorscroll',2303,373,true,false) --1
	setLuaSpriteScrollFactor('chaorunning1',0.4,0.4)
	setPropertyTiledLuaSprite("chaorunning1.antialiasing", false)
	setPropertyTiledLuaSprite("chaorunning1.x", -555)
	setPropertyTiledLuaSprite("chaorunning1.y", 575)
	setPropertyTiledLuaSprite("chaorunning1.visible", false)
	addLuaSprite('chaorunning1');


	--phase3 cheetos só que do vilão pois sou uma pessoa extremamente imparcial, fonte: Confia yey

	makeLuaSprite('vilaophase3-2','cenarios/phase3/vilao/2',-380,-125)--5
	setLuaSpriteScrollFactor('vilaophase3-2',0.7,0.7)
	setProperty('vilaophase3-2.scale.x', 1.5)
	setProperty('vilaophase3-2.scale.y', 1.7)
	setProperty('vilaophase3-2.visible', false)
	addLuaSprite('vilaophase3-2',false)

	makeLuaSprite('vilaophase3-1','cenarios/phase3/vilao/1',-445,315)--5
	setLuaSpriteScrollFactor('vilaophase3-1',0.7,0.7)
	setProperty('vilaophase3-1.scale.x', 1.4)
	setProperty('vilaophase3-1.scale.y', 1.4)
	setProperty('vilaophase3-1.visible', false)
	addLuaSprite('vilaophase3-1',true)

	makeLuaSprite('vilaophase3-3','cenarios/phase3/vilao/filtros',-450,-125)--5
	setLuaSpriteScrollFactor('vilaophase3-3',0.7,0.7)
	setProperty('vilaophase3-3.scale.x', 1)
	setProperty('vilaophase3-3.scale.y', 1.1)
	setObjectCamera('vilaophase3-3', 'camHUD');
	screenCenter('vilaophase3-3','xy')
	setProperty('vilaophase3-3.visible', false)
	addLuaSprite('vilaophase3-3')


	--Phase 3 cheetos só que do heroi pois novamente sou um cara deveras imparcial
	makeLuaSprite('heroiphase3-2','cenarios/phase3/heroi/2',-450,-125)--5
	setLuaSpriteScrollFactor('heroiphase3-2',0.7,0.7)
	setProperty('heroiphase3-2.scale.x', 1.5)
	setProperty('heroiphase3-2.scale.y', 1.7)
	setProperty('heroiphase3-2.visible', false)
	addLuaSprite('heroiphase3-2',false)

	makeLuaSprite('heroiphase3-1','cenarios/phase3/heroi/1',-480,290)--5
	setLuaSpriteScrollFactor('heroiphase3-1',0.7,0.7)
	setProperty('heroiphase3-1.scale.x', 1.5)
	setProperty('heroiphase3-1.scale.y', 1.5)
	setProperty('heroiphase3-1.visible', false)
	addLuaSprite('heroiphase3-1',true)

	makeLuaSprite('heroiphase3-3','cenarios/phase3/heroi/filtro',-450,-125)--5
	setLuaSpriteScrollFactor('heroiphase3-3',0.7,0.7)
	setProperty('heroiphase3-3.scale.x', 1)
	setProperty('heroiphase3-3.scale.y', 1.1)
	setObjectCamera('heroiphase3-3', 'camHUD');
	screenCenter('heroiphase3-3','xy')
	setProperty('heroiphase3-3.visible', false)
	addLuaSprite('heroiphase3-3')

	--Phase 4 cheetos, basicamente um combo de phase 1 com phase 2 só que exe OOOOOOOOOOOOOOOOOMAGAAAAAAAAAWD
	
	makeLuaSprite('montanhasEXE','cenarios/phase4/montanhas',75,80-120) --2
	setLuaSpriteScrollFactor('montanhasEXE',0.5,0.5)
	setProperty('montanhasEXE.scale.x', 4.5)
	setProperty('montanhasEXE.scale.y', 4.5)
	setProperty('montanhasEXE.antialiasing', false)
	setProperty('montanhasEXE.visible', false)
	addLuaSprite('montanhasEXE',false)
	
	makeAnimatedLuaSprite('cachorreiraEXE','cenarios/phase4/cachorreira',-50,290-100) --3
	setLuaSpriteScrollFactor('cachorreiraEXE',0.6,0.6)
	addAnimationByPrefix('cachorreiraEXE', 'bg2', 'bg2', 16, true);
	setProperty('cachorreiraEXE.antialiasing', false)
	setProperty('cachorreiraEXE.scale.x', 5)
	setProperty('cachorreiraEXE.scale.y', 5)
	setProperty('cachorreiraEXE.visible', false)
	addLuaSprite('cachorreiraEXE',false)
	objectPlayAnimation('cachorreiraEXE', 'bg2', true)
	
	makeAnimatedLuaSprite('awaEXE','cenarios/phase4/awa',-50-50,500-25) --4
	setLuaSpriteScrollFactor('awaEXE',0.6,0.6)
	addAnimationByPrefix('awaEXE', 'bg1', 'bg1', 16, true);
	setProperty('awaEXE.scale.x', 5)
	setProperty('awaEXE.scale.y', 5)
	setProperty('awaEXE.antialiasing', false)
	setProperty('awaEXE.visible', false)
	addLuaSprite('awaEXE',false)
	objectPlayAnimation('awaEXE', 'bg1', true)
	
	makeLuaSprite('florrandom2EXE','cenarios/phase4/random2',0,25)--5
	setLuaSpriteScrollFactor('florrandom2EXE',0.7,0.7)
	setProperty('florrandom2EXE.scale.x', 5)
	setProperty('florrandom2EXE.scale.y', 5)
	setProperty('florrandom2EXE.visible', false)
	setProperty('florrandom2EXE.antialiasing', false)
	addLuaSprite('florrandom2EXE',false)
	
	makeLuaSprite('florrandom3EXE','cenarios/phase4/random3',0,100)--5
	setLuaSpriteScrollFactor('florrandom2EXE',0.7,0.7)
	setProperty('florrandom3EXE.scale.x', 5)
	setProperty('florrandom3EXE.scale.y', 5)
	setProperty('florrandom3EXE.antialiasing', false)
	setProperty('florrandom3EXE.visible', false)
	--addLuaSprite('florrandom3EXE',false)
	
	makeLuaTiledSprite('chaorunning1EXE','cenarios/phase4/floorscroll',2303,256,true,false) --1
	setLuaSpriteScrollFactor('chaorunning1EXE',0.4,0.4)
	setPropertyTiledLuaSprite("chaorunning1EXE.antialiasing", false)
	setPropertyTiledLuaSprite("chaorunning1EXE.x", -500)
	setPropertyTiledLuaSprite("chaorunning1EXE.y", 550)
	setPropertyTiledLuaSprite("chaorunning1EXE.visible", false)
	addLuaSprite('chaorunning1EXE');

	--phase 5 cheetos vilao

	makeLuaSprite('nocumepausando','cenarios/phase5/monte paused',-1150,-350)--5
	setLuaSpriteScrollFactor('nocumepausando',0.7,0.7)
	setProperty('nocumepausando.scale.x', 0.95)
	setProperty('nocumepausando.scale.y', 0.95)
	setProperty('nocumepausando.visible', false)
	addLuaSprite('nocumepausando',false)

	--phase 5 cheetos heroi

	makeLuaSprite('ardia','cenarios/phase5/bg',-1150,-350)--5
	setLuaSpriteScrollFactor('ardia',0.7,0.7)
	setProperty('ardia.scale.x', 0.95)
	setProperty('ardia.scale.y', 0.95)
	setProperty('ardia.visible', false)
	addLuaSprite('ardia',false)

	makeLuaSprite('nocume','cenarios/phase5/objetos',-815,-300)--5
	setLuaSpriteScrollFactor('nocume',0.7,0.7)
	setProperty('nocume.scale.x', 0.9)
	setProperty('nocume.scale.y', 0.9)
	setProperty('nocume.visible', false)
	addLuaSprite('nocume',false)

	--phase 6 cheetos
	makeLuaTiledSprite('angelislandbg','cenarios/phase6/ceus',4096,1024,true,false) --1
	setLuaSpriteScrollFactor('angelislandbg',0.4,0.4)
	setPropertyTiledLuaSprite("angelislandbg.antialiasing", false)
	setPropertyTiledLuaSprite("angelislandbg.visible", false)
	setPropertyTiledLuaSprite("angelislandbg.x", -555)
	setPropertyTiledLuaSprite("angelislandbg.y", -260)
	addLuaSprite('angelislandbg');

	makeLuaTiledSprite('angelislandarvores','cenarios/phase6/arvores',4096,1024,true,false) --1
	setLuaSpriteScrollFactor('angelislandarvores',0.4,0.4)
	setPropertyTiledLuaSprite("angelislandarvores.antialiasing", false)
	setPropertyTiledLuaSprite("angelislandarvores.x", -555)
	setPropertyTiledLuaSprite("angelislandarvores.y", -175)
	setPropertyTiledLuaSprite("angelislandarvores.visible", false)
	addLuaSprite('angelislandarvores');

	makeLuaTiledSprite('angelislandchao','cenarios/phase6/gramado',6810,1024,true,false) --1
	setLuaSpriteScrollFactor('angelislandchao',0.4,0.4)
	setPropertyTiledLuaSprite("angelislandchao.antialiasing", false)
	setPropertyTiledLuaSprite("angelislandchao.x", -555)
	setPropertyTiledLuaSprite("angelislandchao.y", -165)
	setPropertyTiledLuaSprite("angelislandchao.visible", false)
	addLuaSprite('angelislandchao');

	--phase 7 cheetos

	makeLuaSprite('phase7-1','cenarios/phase7/1',-545,-75*1.5)--5
	setLuaSpriteScrollFactor('phase7-1',0.9,0.9)
	setProperty('phase7-1.scale.x', 1.6)
	setProperty('phase7-1.scale.y', 1.6)
	setProperty('phase7-1.visible', false)
	addLuaSprite('phase7-1',false)

	makeLuaSprite('phase7-2','cenarios/phase7/2',-445,-255)--5
	setLuaSpriteScrollFactor('phase7-2',0.7,0.7)
	setProperty('phase7-2.scale.x', 1.6)
	setProperty('phase7-2.scale.y', 1.5)
	setProperty('phase7-2.visible', false)
	addLuaSprite('phase7-2',true)

	makeLuaSprite('phase7-3','cenarios/phase7/3',250,600)--5
	setLuaSpriteScrollFactor('phase7-3',0.2,0.2)
	setProperty('phase7-3.scale.x', 1.3)
	setProperty('phase7-3.scale.y', 1.3)
	setProperty('phase7-3.visible', false)
	addLuaSprite('phase7-3',true)

	makeLuaSprite('phase7-4','cenarios/phase7/4',-300,-50)--5
	setLuaSpriteScrollFactor('phase7-4',0.6,0.4)
	setProperty('phase7-4.scale.x', 1.65)
	setProperty('phase7-4.scale.y', 1.65)
	setProperty('phase7-4.visible', false)
	addLuaSprite('phase7-4',true)

	--phase 8 cheetos
	makeLuaSprite('phase8','cenarios/phase8/sonic',-850,-320)--5
	setLuaSpriteScrollFactor('phase8',1,1)
	setProperty('phase8.scale.x', 1)
	setProperty('phase8.scale.y', 1)
	setProperty('phase8.visible', false)
	setProperty('phase8.antialiasing', false)
	addLuaSprite('phase8',false)

	--phase 9 cheetos vulgo melhor phase do mod falo mesmo achou ruim cai no soco

	makeLuaTiledSprite('phase9-2','cenarios/phase9/2',4096,1024,true,false) --1
	setLuaSpriteScrollFactor('phase9-2',0.4,0.4)
	setPropertyTiledLuaSprite("phase9-2.antialiasing", false)
	setPropertyTiledLuaSprite("phase9-2.visible", false)
	setPropertyTiledLuaSprite("phase9-2.x", -575)
	setPropertyTiledLuaSprite("phase9-2.y", -160)
	addLuaSprite('phase9-2', false);

	makeLuaSprite('phase9-3','cenarios/phase9/3',-800,-500)--5
	setLuaSpriteScrollFactor('phase9-3',1,1)
	setProperty('phase9-3.scale.x', 0.3)
	setProperty('phase9-3.scale.y', 0.3)
	setProperty('phase9-3.visible', false)
	setProperty('phase9-3.antialiasing', false)
	addLuaSprite('phase9-3',false)

	makeLuaTiledSprite('phase9-1','cenarios/phase9/1',4096,1024,true,false) --1
	setLuaSpriteScrollFactor('phase9-1',0.4,0.4)
	setPropertyTiledLuaSprite("phase9-1.antialiasing", false)
	setPropertyTiledLuaSprite("phase9-1.visible", false)
	setPropertyTiledLuaSprite("phase9-1.x", -575)
	setPropertyTiledLuaSprite("phase9-1.y", -260)
	addLuaSprite('phase9-1', true);

	--phase 10 cheetos

	makeLuaSprite('phase10-1','cenarios/phase10/bg',-480,-75)--5
	setLuaSpriteScrollFactor('phase7-1',0.4,0.4)
	setProperty('phase10-1.scale.x', 1.3)
	setProperty('phase10-1.scale.y', 1.4)
	setProperty('phase10-1.visible', false)
	addLuaSprite('phase10-1',false)

	makeLuaSprite('phase10-2','cenarios/phase10/stone1',-445,360)--5
	setLuaSpriteScrollFactor('phase10-2',1,1)
	setProperty('phase10-2.scale.x', 1.1)
	setProperty('phase10-2.scale.y', 1.1)
	setProperty('phase10-2.visible', false)
	addLuaSprite('phase10-2',true)

	makeLuaSprite('phase10-3','cenarios/phase10/stone2',590,350)--5
	setLuaSpriteScrollFactor('phase10-3',1,1)
	setProperty('phase10-3.scale.x', 1.1)
	setProperty('phase10-3.scale.y', 1.1)
	setProperty('phase10-3.visible', false)
	addLuaSprite('phase10-3',true)


end

-- O plano é que Aqui vai ficar só o precache a criação de variaveis de cenário.
-- As mecânicas e todo o resto ficarão no master.lua (futuramente será criado.)


-- Não tenho certeza de setProperty("defaultCamZoom",0.8) está funcionando, então talvez tu precise alterar o json do stage pra ter uma ideia melhor
-- De todos modos, na música, esse evento vai funcionar com base no CamZoomTween, então não estou lá muito preocupado com isso.
function changePhases(curPhase) -- Fazer um lua só pra isso.
	if curPhase == 2 then
		setProperty("defaultCamZoom",0.75)
		for i = 1,#phase1unico do
			setProperty(phase1unico[i]..'.visible', false)
		end
		for i = 1,#phase2cheetos do
			setProperty(phase2cheetos[i]..'.visible', true)
		end
		doTweenX('florqueanda1', 'florrandom1', 2000, 10, 'linear')
		doTweenX('montanhaqueanda1', 'montanhas', 400, 33, 'linear')
		doTweenX('awaqueanda1', 'awa', 400, 33, 'linear')
		doTweenX('eitacachorreira', 'cachorreira', 400, 33, 'linear')
	elseif curPhase == 3 then
		setProperty("defaultCamZoom",0.65)
		for i = 1,#phase1unico do
			setProperty(phase1unico[i]..'.visible', false)
		end
		for i = 1,#phase2cheetos do
			setProperty(phase2cheetos[i]..'.visible', false)
		end
		for i = 1,#phase3cheetosvilao do
			setProperty(phase3cheetosvilao[i]..'.visible', true)
		end
	elseif curPhase == 4 then
		setProperty("defaultCamZoom",0.65)
		for i = 1,#phase1unico do
			setProperty(phase1unico[i]..'.visible', false)
		end
		for i = 1,#phase3cheetosvilao do
			setProperty(phase3cheetosvilao[i]..'.visible', false)
		end
		for i = 1,#phase2cheetos do
			setProperty(phase2cheetos[i]..'.visible', false)
		end
		for i = 1,#phase3cheetosvilao do
			setProperty(phase3cheetosvilao[i]..'.visible', false)
		end
		for i = 1,#phase4cheetos do
			setProperty(phase4cheetos[i]..'.visible', true)
		end
		doTweenX('florqueanda1', 'florrandom1', 2000, 10, 'linear')
		doTweenX('montanhaqueanda1', 'montanhas', 400, 33, 'linear')
		doTweenX('awaqueanda1', 'awa', 400, 33, 'linear')
		doTweenX('eitacachorreira', 'cachorreira', 400, 33, 'linear')
	elseif curPhase == 5 then
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
	elseif curPhase == 6 then
		
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
	elseif curPhase == 7 then
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
	elseif curPhase == 8 then 	--0.75 de zoom
		setProperty("defaultCamZoom",0.8)
		for i = 1,#phase1unico do
			setProperty(phase1unico[i]..'.visible', false)
		end
		for i = 1,#phase2cheetos do
			setProperty(phase2cheetos[i]..'.visible', false)
		end
		setProperty('phase8.visible',true)
	elseif curPhase == 9 then 	--0.75 de zoom
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
	elseif curPhase == 10 then
		
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


--Pretendo transferir isso pro Master em Breve, afinal ainda no final teremos que dar um jeito de usar removeLuaSprite pra economizar memória
--já que o The End é a parte mais pesada do mod.
function onUpdate()
	speedChanger = speedChanger + 1

	--Just testing
	setPropertyTiledLuaSprite("ceu.scrollX", speedChanger*0.5)
	setPropertyTiledLuaSprite("chaorunning1.scrollX", speedChanger*15)
	setPropertyTiledLuaSprite("chaorunning1EXE.scrollX", speedChanger*15)


	setPropertyTiledLuaSprite("angelislandchao.scrollX", -speedChanger*45)
	setPropertyTiledLuaSprite("angelislandarvores.scrollX", -speedChanger*20)
	setPropertyTiledLuaSprite("angelislandbg.scrollX", -speedChanger*10)

	setPropertyTiledLuaSprite("phase9-1.scrollX", -speedChanger*60)
	setPropertyTiledLuaSprite("phase9-2.scrollX", -speedChanger*5)

	if keyJustPressed("space") then
		changePhases(10) 
	end
end
