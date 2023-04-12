function onCreate() -- Aqui só serve para dar carregar e configurar os cenários,
	-- A parte massa da coisa mesmo está lá no Master.lua

	--phase1 stuff
	makeLuaTiledSprite('ceu','cenarios/phase1/ceu',2000,330,true,false) --1
	setLuaSpriteScrollFactor('ceu',0.4,0.4)
	setPropertyTiledLuaSprite("ceu.antialiasing", false)
	setPropertyTiledLuaSprite("ceu.x", -555)
	setPropertyTiledLuaSprite("ceu.y", -223)
	addLuaSprite('ceu');

	makeLuaSprite('montanhas','cenarios/phase1/montanhas',75-200+100,105-23) --2
	setLuaSpriteScrollFactor('montanhas',0.5,0.5)
	setProperty('montanhas.scale.x', 5)
	setProperty('montanhas.scale.y', 4.5)
	setProperty('montanhas.antialiasing', false)
	addLuaSprite('montanhas',false)

	makeAnimatedLuaSprite('cachorreira','cenarios/phase1/cachorreira',-50-300+140,295-35) --3
	setLuaSpriteScrollFactor('cachorreira',0.6,0.6)
	addAnimationByPrefix('cachorreira', 'bg2', 'bg2', 16, true);
	setProperty('cachorreira.antialiasing', false)
	setProperty('cachorreira.scale.x', 5)
	setProperty('cachorreira.scale.y', 5)
	addLuaSprite('cachorreira',false)
	objectPlayAnimation('cachorreira', 'bg2', true)

	makeAnimatedLuaSprite('awa','cenarios/phase1/awa',-80-300+100,580-35) --4
	setLuaSpriteScrollFactor('awa',0.6,0.6)
	addAnimationByPrefix('awa', 'bg1', 'bg1', 16, true);
	setProperty('awa.scale.x', 6)
	setProperty('awa.scale.y', 5)
	setProperty('awa.antialiasing', false)
	addLuaSprite('awa',false)
	objectPlayAnimation('awa', 'bg1', true)

	makeLuaSprite('montesverdes','cenarios/phase1/GHGround',0,100+1500)--5
	setLuaSpriteScrollFactor('montesverdes',1,1)
	setProperty('montesverdes.scale.x', 5)
	setProperty('montesverdes.scale.y', 5)
	setProperty('montesverdes.antialiasing', false)
	addLuaSprite('montesverdes',false)

	makeAnimatedLuaSprite('flores','cenarios/phase1/flowers',0,105+1500) --6
	setLuaSpriteScrollFactor('flores',1,1)
	addAnimationByPrefix('flores', 'flowerloop', 'flowerloop', 16, true);
	setProperty('flores.antialiasing', false)
	setProperty('flores.scale.x', 5)
	setProperty('flores.scale.y', 5)
	addLuaSprite('flores',false)
	objectPlayAnimation('flores', 'flowerloop', true)

	makeAnimatedLuaSprite('trens','cenarios/phase1/objects',0,100+1500) --7
	setLuaSpriteScrollFactor('trens',1,1)
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

	makeLuaSprite('florrandom2','cenarios/phase2/random2',-2000,40)--5
	setLuaSpriteScrollFactor('florrandom2',0.7,0.7)
	setProperty('florrandom2.scale.x', 5)
	setProperty('florrandom2.scale.y', 5)
	setProperty('florrandom2.antialiasing', false)
	setProperty('florrandom2.visible', false)
	addLuaSprite('florrandom2',false)

	makeLuaTiledSprite('chaorunning1','cenarios/phase2/floorscroll',2303,373,true,false) --1
	setLuaSpriteScrollFactor('chaorunning1',0.4,0.4)
	setPropertyTiledLuaSprite("chaorunning1.antialiasing", false)
	setPropertyTiledLuaSprite("chaorunning1.x", -555)
	setPropertyTiledLuaSprite("chaorunning1.y", 575)
	setPropertyTiledLuaSprite("chaorunning1.visible", false)
	addLuaSprite('chaorunning1');


	--phase3 cheetos só que do vilão pois sou uma pessoa extremamente imparcial, fonte: Confia yey

	makeLuaSprite('vilaophase3-2','cenarios/phase3/vilao/2',-380,-125)--5
	setLuaSpriteScrollFactor('vilaophase3-2',1,1)
	setProperty('vilaophase3-2.scale.x', 1.5)
	setProperty('vilaophase3-2.scale.y', 1.7)
	setProperty('vilaophase3-2.visible', false)
	addLuaSprite('vilaophase3-2',false)

	makeLuaSprite('vilaophase3-1','cenarios/phase3/vilao/1',-335,315)--5
	setLuaSpriteScrollFactor('vilaophase3-1',0.6,1)
	setProperty('vilaophase3-1.scale.x', 1.5)
	setProperty('vilaophase3-1.scale.y', 1.45)
	setProperty('vilaophase3-1.visible', false)
	addLuaSprite('vilaophase3-1',true)

	makeLuaSprite('vilaophase3-3','cenarios/phase3/vilao/filtros',-380,-125)--5
	setLuaSpriteScrollFactor('vilaophase3-3',1,1)
	setProperty('vilaophase3-3.scale.x', 1.5)
	setProperty('vilaophase3-3.scale.y', 1.7)
	setProperty('vilaophase3-3.visible', false)
	addLuaSprite('vilaophase3-3', true)


	--Phase 3 cheetos só que do heroi pois novamente sou um cara deveras imparcial
	makeLuaSprite('heroiphase3-2','cenarios/phase3/heroi/2',-380,-125)--5
	setLuaSpriteScrollFactor('heroiphase3-2',1,1)
	setProperty('heroiphase3-2.scale.x', 1.5)
	setProperty('heroiphase3-2.scale.y', 1.7)
	setProperty('heroiphase3-2.visible', false)
	addLuaSprite('heroiphase3-2',false)

	makeLuaSprite('heroiphase3-1','cenarios/phase3/heroi/1',-335,315)--5
	setLuaSpriteScrollFactor('heroiphase3-1',0.6,1)
	setProperty('heroiphase3-1.scale.x', 1.5)
	setProperty('heroiphase3-1.scale.y', 1.45)
	setProperty('heroiphase3-1.visible', false)
	addLuaSprite('heroiphase3-1',true)

	makeLuaSprite('heroiphase3-3','cenarios/phase3/heroi/filtro',-380,-125)--5
	setLuaSpriteScrollFactor('heroiphase3-3',1,1)
	setProperty('heroiphase3-3.scale.x', 1.5)
	setProperty('heroiphase3-3.scale.y', 1.7)
	setProperty('heroiphase3-3.visible', false)
	addLuaSprite('heroiphase3-3', true)

	--Phase 4 cheetos, basicamente um combo de phase 1 com phase 2 só que exe OOOOOOOOOOOOOOOOOMAGAAAAAAAAAWD
	
	makeLuaSprite('montanhasEXE','cenarios/phase4/montanhas',75+200,80-120) --2
	setLuaSpriteScrollFactor('montanhasEXE',0.5,0.5)
	setProperty('montanhasEXE.scale.x', 4.5)
	setProperty('montanhasEXE.scale.y', 4.5)
	setProperty('montanhasEXE.antialiasing', false)
	setProperty('montanhasEXE.visible', false)
	addLuaSprite('montanhasEXE',false)
	
	makeAnimatedLuaSprite('cachorreiraEXE','cenarios/phase4/cachorreira',-50+200,290-100) --3
	setLuaSpriteScrollFactor('cachorreiraEXE',0.6,0.6)
	addAnimationByPrefix('cachorreiraEXE', 'bg2', 'bg2', 16, true);
	setProperty('cachorreiraEXE.antialiasing', false)
	setProperty('cachorreiraEXE.scale.x', 5)
	setProperty('cachorreiraEXE.scale.y', 5)
	setProperty('cachorreiraEXE.visible', false)
	addLuaSprite('cachorreiraEXE',false)
	objectPlayAnimation('cachorreiraEXE', 'bg2', true)
	
	makeAnimatedLuaSprite('awaEXE','cenarios/phase4/awa',-50+200-50,500-25) --4
	setLuaSpriteScrollFactor('awaEXE',0.6,0.6)
	addAnimationByPrefix('awaEXE', 'bg1', 'bg1', 16, true);
	setProperty('awaEXE.scale.x', 5)
	setProperty('awaEXE.scale.y', 5)
	setProperty('awaEXE.antialiasing', false)
	setProperty('awaEXE.visible', false)
	addLuaSprite('awaEXE',false)
	objectPlayAnimation('awaEXE', 'bg1', true)
	
	makeLuaSprite('florrandom2EXE','cenarios/phase4/random2',-2000,-30)--5
	setLuaSpriteScrollFactor('florrandom2EXE',0.7,0.7)
	setProperty('florrandom2EXE.scale.x', 5)
	setProperty('florrandom2EXE.scale.y', 5)
	setProperty('florrandom2EXE.visible', false)
	setProperty('florrandom2EXE.antialiasing', false)
	addLuaSprite('florrandom2EXE',false)
	
	makeLuaSprite('florrandom3EXE','cenarios/phase4/random1',-2000,-50)--5
	setLuaSpriteScrollFactor('florrandom2EXE',0.7,0.7)
	setProperty('florrandom3EXE.scale.x', 5)
	setProperty('florrandom3EXE.scale.y', 5)
	setProperty('florrandom3EXE.antialiasing', false)
	setProperty('florrandom3EXE.visible', false)
	addLuaSprite('florrandom3EXE',false)
	
	makeLuaTiledSprite('chaorunning1EXE','cenarios/phase4/floorscroll',2303,256,true,false) --1
	setLuaSpriteScrollFactor('chaorunning1EXE',0.4,0.4)
	setPropertyTiledLuaSprite("chaorunning1EXE.antialiasing", false)
	setPropertyTiledLuaSprite("chaorunning1EXE.x", -500)
	setPropertyTiledLuaSprite("chaorunning1EXE.y", 550)
	setPropertyTiledLuaSprite("chaorunning1EXE.visible", false)
	addLuaSprite('chaorunning1EXE');

	--phase 5 cheetos vilao

	makeLuaSprite('nocumepausando','cenarios/phase5/monte paused',-1250,-450)--5
	setLuaSpriteScrollFactor('nocumepausando',0.7,0.7)
	setProperty('nocumepausando.scale.x', 0.75)
	setProperty('nocumepausando.scale.y', 0.75)
	setProperty('nocumepausando.visible', false)
	addLuaSprite('nocumepausando',false)

	--phase 5 cheetos heroi

	makeLuaSprite('ardia','cenarios/phase5/bg',-1250,-450)--5
	setLuaSpriteScrollFactor('ardia',0.7,0.7)
	setProperty('ardia.scale.x', 0.75)
	setProperty('ardia.scale.y', 0.75)
	setProperty('ardia.visible', false)
	addLuaSprite('ardia',false)

	makeLuaSprite('nocume','cenarios/phase5/objetos',-815,-300)--5
	setLuaSpriteScrollFactor('nocume',0.7,0.7)
	setProperty('nocume.scale.x', 0.75)
	setProperty('nocume.scale.y', 0.75)
	setProperty('nocume.visible', false)
	addLuaSprite('nocume',false)

	--phase 6 cheetos
	makeLuaTiledSprite('angelislandbg','cenarios/phase6/ceus',4096,1024,true,false) --1
	setLuaSpriteScrollFactor('angelislandbg',0.4,1)
	setPropertyTiledLuaSprite("angelislandbg.antialiasing", false)
	setPropertyTiledLuaSprite("angelislandbg.visible", false)
	setPropertyTiledLuaSprite("angelislandbg.x", -555)
	setPropertyTiledLuaSprite("angelislandbg.y", -260-60)
	addLuaSprite('angelislandbg');

	makeLuaTiledSprite('angelislandarvores','cenarios/phase6/arvores',4096,1024,true,false) --1
	setLuaSpriteScrollFactor('angelislandarvores',0.4,1)
	setPropertyTiledLuaSprite("angelislandarvores.antialiasing", false)
	setPropertyTiledLuaSprite("angelislandarvores.x", -555)
	setPropertyTiledLuaSprite("angelislandarvores.y", -175-100)
	setPropertyTiledLuaSprite("angelislandarvores.visible", false)
	addLuaSprite('angelislandarvores');

	makeLuaTiledSprite('angelislandchao','cenarios/phase6/gramado',6810,1024,true,false) --1
	setLuaSpriteScrollFactor('angelislandchao',0.4,1)
	setPropertyTiledLuaSprite("angelislandchao.antialiasing", false)
	setPropertyTiledLuaSprite("angelislandchao.x", -555)
	setPropertyTiledLuaSprite("angelislandchao.y", -165-60)
	setPropertyTiledLuaSprite("angelislandchao.visible", false)
	addLuaSprite('angelislandchao');

	makeLuaSprite('knuxerabos','tailsknuckles',800,2000)--5
	setLuaSpriteScrollFactor('knuxerabos',0.9,0.9)
	setProperty('knuxerabos.scale.x', 0.6)
	setProperty('knuxerabos.scale.y', 0.6)
	setProperty('knuxerabos.visible', false)
	addLuaSprite('knuxerabos',false)

	--phase 7 cheetos

	makeLuaSprite('phase7-1','cenarios/phase7/1',-400,-75*1.5)--5
	setLuaSpriteScrollFactor('phase7-1',0.9,0.9)
	setProperty('phase7-1.scale.x', 1.7)
	setProperty('phase7-1.scale.y', 1.7)
	setProperty('phase7-1.visible', false)
	addLuaSprite('phase7-1',false)

	makeLuaSprite('phase7-2','cenarios/phase7/2',-100,-205)--5
	setLuaSpriteScrollFactor('phase7-2',0.7,0.7)
	setProperty('phase7-2.scale.x', 1.7)
	setProperty('phase7-2.scale.y', 1.55)
	setProperty('phase7-2.visible', false)
	addLuaSprite('phase7-2',true)

	makeLuaSprite('phase7-3','cenarios/phase7/3',150,600)--5
	setLuaSpriteScrollFactor('phase7-3',0.6,0.4)
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
	setLuaSpriteScrollFactor('phase9-2',0.4,0.3)
	setPropertyTiledLuaSprite("phase9-2.antialiasing", false)
	setPropertyTiledLuaSprite("phase9-2.visible", false)
	setPropertyTiledLuaSprite("phase9-2.x", -575)
	setPropertyTiledLuaSprite("phase9-2.y", -160)
	addLuaSprite('phase9-2', false);

	makeLuaSprite('phase9-3','cenarios/phase9/3',1000,-620)--5
	setLuaSpriteScrollFactor('phase9-3',0.4,0.3)
	setProperty('phase9-3.scale.x', 0.4)
	setProperty('phase9-3.scale.y', 0.4)
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

	makeLuaSprite('phase10-1','cenarios/phase10/bg',-530,-75)--5
	setLuaSpriteScrollFactor('phase10-1',0.2,0.2)
	setProperty('phase10-1.scale.x', 1.6)
	setProperty('phase10-1.scale.y', 1.7)
	setProperty('phase10-1.visible', false)
	addLuaSprite('phase10-1',false)

	makeLuaSprite('phase10-2','cenarios/phase10/stone1',0,0)--5
	setLuaSpriteScrollFactor('phase10-2',1,1)
	setProperty('phase10-2.scale.x', 1.1)
	setProperty('phase10-2.scale.y', 1.1)
	setProperty('phase10-2.visible', false)
	addLuaSprite('phase10-2',true)

	makeLuaSprite('phase10-3','cenarios/phase10/stone2',0,0)--5
	setLuaSpriteScrollFactor('phase10-3',1,1)
	setProperty('phase10-3.scale.x', 1.1)
	setProperty('phase10-3.scale.y', 1.1)
	setProperty('phase10-3.visible', false)
	addLuaSprite('phase10-3',true)


end

function onCreatePost() -- Isso aqui se comunica com o trans.lua (está em post pra garantir que o trans pegue o y antes da alteração pra depois usar no tween.)
	setCharacterY('bf', getCharacterY('bf')+1500)
	setCharacterY('dad', getCharacterY('dad')+1500)
	setCamMove(false);
end