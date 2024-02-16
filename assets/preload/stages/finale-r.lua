--[[
    A ideia deste lua é basicamente preparar todos os assets para uso dentro de cada .lua chamado pelo master
    Qualquer ajuste de offset, e/ou framerate deve ser feito única e exclusivamente neste .lua
    fora o da intro, aquele lá é um caso a parte.
	fun fact, o da Intro não é mais utilizado k
]]

function onCreatePost()
	--Icons code
	makeLuaSprite('oppIcon', 'empty', 230 ,getProperty('healthBar.y') -80)
	loadGraphic('oppIcon', 'icons/xeno/xeno', 150)
	addAnimation('oppIcon', 'icon/'..getProperty('dad.healthIcon'), {0, 1}, 0, true)
	setObjectCamera('oppIcon', 'camHUD')
	setObjectOrder('oppIcon', getObjectOrder('healthBarBG') + 2)
	addLuaSprite('oppIcon')
	setProperty('oppIcon.visible', false)
	setObjectOrder('oppIcon', getObjectOrder('healthBarBG') + 2)

	makeLuaSprite('bfIcon', 'empty', getProperty('healthBar.width') + 285 ,getProperty('healthBar.y') -80)
	loadGraphic('bfIcon', 'icons/fnf/bf', 150)
	addAnimation('bfIcon', 'icon/'..getProperty('boyfriend.healthIcon'), {0, 1}, 0, true)
	setObjectCamera('bfIcon', 'camHUD')
	setProperty('bfIcon.visible', false)
	setProperty('bfIcon.flipX', false)
	setObjectOrder('bfIcon', getObjectOrder('healthBarBG') + 3)
	addLuaSprite('bfIcon')
	setObjectOrder('bfIcon', getObjectOrder('healthBarBG') + 3)

	makeLuaSprite('HPbar', 'empty', getProperty('healthBar.x'),getProperty('healthBar.y'));
	makeGraphic('HPbar',getProperty('healthBar.width'),getProperty('healthBar.height'),'00B6FF')
	addLuaSprite('HPbar', true);
	setProperty('HPbar.visible', false)
	setObjectOrder('HPbar',getObjectOrder('healthBar') + 1)
	setObjectCamera('HPbar', 'hud');
end

function preloadChars()
	addCharacterToList('invisibru', 'dad'); -- general use purposes
	-- Ato 1
	addCharacterToList('bfrun', 'bf');
	addCharacterToList('xenofinal', 'dad');

	-- Face-to-Face
	addCharacterToList('bf_ftf', 'bf');
	addCharacterToList('xeno-ftf', 'dad');

	-- Depois ele volta pro ato 1

	-- Mão boba

	addCharacterToList('bfrunHand', 'bf');

	-- LateralRun

	addCharacterToList('bfrunbobo', 'bf');

	-- Drowning

	addCharacterToList('bf_drowning', 'bf');

	-- GigaSonic

	addCharacterToList('beef', 'bf');
	addCharacterToList('xenoholding', 'dad');

	-- Circus

	addCharacterToList('bfstring', 'bf');

	-- Super Transform

	addCharacterToList('sbf1', 'bf');
	addCharacterToList('xenomad', 'dad');

	-- ato final

	addCharacterToList('sbf2', 'bf');

end

function introStuff() -- Só pra carregar umas coisas usadas após o vidro.
	makeLuaSprite('circuloinicio', 'StartScreen/Circle-gran-finale', 900, 0);
	setObjectCamera('circuloinicio', 'hud2')
	addLuaSprite('circuloinicio')

	makeLuaSprite('textoinicio', 'StartScreen/Text-gran-finale', -1200, 0);
	setObjectCamera('textoinicio', 'hud2')
	addLuaSprite('textoinicio')
end

function onCreate()

	preloadChars();

	introStuff();

	makeLuaSprite('introBG', 'introBG', -1000, -700);
	setGraphicSize('introBG', screenWidth*1.16, screenHeight*1.175)
	setObjectCamera('introBG', 'legenda')
	screenCenter('introBG')
	addLuaSprite('introBG')

	--BG quase global
	makeLuaSprite('global_shader', 'bg_shader', -1000, -700);
	setProperty('global_shader.visible', false)
	setScrollFactor('global_shader', 0.7, 0.7);
	setProperty('global_shader.alpha', 0.5)
	scaleObject('global_shader', 1.5, 1.5);
	addLuaSprite('global_shader')

	--Outro bg quase global só que só é usado por alguns segundos, mas foi colocado aqui pra ficar atrás de todo mundo.
	-- Explicação deveras complicada pra dizer que quero esse sprite atrás do cenário...

    makeAnimatedLuaSprite('static','effects/staticBACKGROUND2',-1400,-1000)
	addAnimationByPrefix('static','dance','menuSTATICNEW instance ',24,true)
    --objectPlayAnimation('static','dance',false)
    setScrollFactor('static', 0.9, 0.9);
    scaleObject('static', 4, 4);
	setProperty('static.visible', false)
	addLuaSprite('static')
	
	-- Extras

	--(dos mesmos criadores de trans.lua, veeeeeeeeeeem aiiiiiiiiiiii)
    --Talvez... MAS SÓ TALVEZ... Eu seja cancelado por esse nome de variável 
    makeLuaSprite('blackTrans', 'empty', 0, 0)
	makeGraphic('blackTrans', screenWidth, screenHeight, '000000')
	setObjectCamera('blackTrans', 'legenda')
	setProperty('blackTrans.visible', false)
	setProperty('blackTrans.alpha', 0)
    screenCenter('blackTrans')
	addLuaSprite('blackTrans', false)

	makeLuaSprite('redTrans', 'RedVG', 0, 0)
	setObjectCamera('redTrans', 'legenda')
	setProperty('redTrans.visible', false)
	setProperty('redTrans.alpha', 0)
    screenCenter('redTrans')
	addLuaSprite('redTrans', false)

	makeLuaSprite('iamgod', 'simplejump', 0, 0)
	setObjectCamera('iamgod', 'legenda')
	setProperty('iamgod.visible', false)
	setGraphicSize('iamgod', screenWidth, screenHeight)
    screenCenter('iamgod')
	addLuaSprite('iamgod', false)

	makeAnimatedLuaSprite('herewego', 'cutscenes/hwg', -1250, 400);
	addAnimationByPrefix('herewego', 'anim', 'hi', 24, false);
	addAnimationByPrefix('herewego', 'justXeno', 'xeno', 24, false)
	setObjectCamera('herewego', 'camlegenda')
	screenCenter('herewego')
	setProperty('herewego.visible', false)
	addLuaSprite('herewego')

	makeAnimatedLuaSprite('bfgetsmic', 'cutscenes/bfgethismic', -1250, 400);
	addAnimationByPrefix('bfgetsmic', 'anim', 'bfgethismic', 24, false);
	--playAnim('bfgetsmic', 'anim')
	setObjectCamera('bfgetsmic', 'camlegenda')
	objectPlayAnimation('bfgetsmic', 'anim', false)
	setGraphicSize('bfgetsmic', screenWidth, screenHeight)
	screenCenter('bfgetsmic')
	setProperty('bfgetsmic.visible', false)
	addLuaSprite('bfgetsmic')

	makeAnimatedLuaSprite('daHandDrowning', 'daHandTrans', -1950, -400);
	addAnimationByPrefix('daHandDrowning', 'anim', 'hand', 12, false);
	setProperty('daHandDrowning.alpha', 0)
	setProperty('daHandDrowning.visible', false)
	scaleLuaSprite('daHandDrowning', 3, 3)
	updateHitbox('daHandDrowning')
	addLuaSprite('daHandDrowning', false)

	--[[makeAnimatedLuaSprite('grabbf', 'cutscenes/grabbf', -1250, 400);
	addAnimationByPrefix('grabbf', 'anim', 'grab', 24, false);
	setProperty('grabbf.visible', false)
	setProperty('grabbf.flipX', true)
	addLuaSprite('grabbf', true)
	]]

	makeAnimatedLuaSprite('bffall', 'cutscenes/bffall', 0, 0);
	addAnimationByPrefix('bffall', 'anim', 'bffall', 24, false);
	setObjectCamera('bffall', 'camlegenda')
	scaleLuaSprite('bffall', 0.8, 0.8)
	screenCenter('bffall', 'x')
	setProperty('bffall.y', screenHeight+200)
	setProperty('bffall.visible', false)
	addLuaSprite('bffall')


    -- Coisas do ato1 (que depois de ter feito tudo, descobri que era a musica inteira usando isso)
	-- CY me traumatizou ferradamente
	makeLuaSprite('Background', 'ato1/Sky', -1300, -850);
    setProperty('Background.visible', false)
	setScrollFactor('Background', 0.6, 0.6);
	scaleObject('Background', 1.20, 1.3);

	makeAnimatedLuaSprite('Ring', 'ato1/Objects/ring', -640, -320);
    setProperty('Ring.visible', false)
	setScrollFactor('Ring', 0.7, 0.5);
	scaleObject('Ring', 0.9, 0.8);

	makeAnimatedLuaSprite('Checkpoint', 'ato1/Objects/checkpoint', -1250, 400);
    setProperty('Checkpoint.visible', false)
	setScrollFactor('Checkpoint', 0.7, 0.5);
	scaleObject('Checkpoint', 0.9, 0.8);

	makeLuaSprite('Rock', 'ato1/Objects/THE ROCK', 490, -650);
    setProperty('Rock.visible', false)
	setScrollFactor('Rock', 0.7, 0.5);
	scaleObject('Rock', 0.9, 0.8);

	makeLuaSprite('Sega', 'ato1/Objects/SEGA', 250, -400);
    setProperty('Sega.visible', false)
	setScrollFactor('Sega', 0.7, 0.5);
	scaleObject('Sega', 0.9, 0.8);

	makeAnimatedLuaSprite('Eggman', 'ato1/Objects/egg', 550, -240);
    setProperty('Eggman.visible', false)
	setScrollFactor('Eggman', 0.7, 0.5);
	scaleObject('Eggman', 0.9, 0.8);

	makeAnimatedLuaSprite('Text', 'ato1/Objects/text', -550, -700);
    setProperty('Text.visible', false)
	setScrollFactor('Text', 0.7, 0.5);
	scaleObject('Text', 0.9, 0.8);

	makeLuaSprite('S', 'ato1/Objects/S', -1650, 650);
    setProperty('S.visible', false)
	setScrollFactor('S', 1, 0.54);
	scaleObject('S', 0.9, 0.8);

	makeLuaSprite('O', 'ato1/Objects/O', -1250, 550);
    setProperty('O.visible', false)
	setScrollFactor('O', 1, 0.55);
	scaleObject('O', 0.9, 0.8);

	makeLuaSprite('N', 'ato1/Objects/N', 100, 180);
    setProperty('N.visible', false)
	setScrollFactor('N', 1, 0.56);
	scaleObject('N', 0.9, 0.8);

	makeLuaSprite('I', 'ato1/Objects/I', 510, 140);
    setProperty('I.visible', false)
	setScrollFactor('I', 1, 0.57);
	scaleObject('I', 0.9, 0.8);

	makeLuaSprite('C', 'ato1/Objects/C', 840, 160);
    setProperty('C.visible', false)
	setScrollFactor('C', 1, 0.58);
	scaleObject('C', 0.9, 0.8);

	makeLuaSprite('Mountains', 'ato1/Mountains', -1300, -800);
    setProperty('Mountains.visible', false)
	setScrollFactor('Mountains', 0.8, 0.6);
	scaleObject('Mountains', 0.95, 0.95);

	makeAnimatedLuaSprite('Lake', 'ato1/water', -1350, -240);
    setProperty('Lake.visible', false)
	scaleObject('Lake', 0.9, 0.8);
	
	makeAnimatedLuaSprite('Band', 'ato1/band', -1250, -480);
    setProperty('Band.visible', false)
	scaleObject('Band', 0.9, 0.9);
	setObjectOrder('Band', 2);
	
	addLuaSprite('Background', false);
	addLuaSprite('Ring', false);
	addAnimationByPrefix('Ring', 'idle', 'ring idle', 16, true);
	addLuaSprite('Checkpoint', false);
	addAnimationByPrefix('Checkpoint', 'idle', 'checkpoint idle', 24, true);
	addLuaSprite('Rock', false);
	addLuaSprite('Sega', false);
	addLuaSprite('Eggman', false);
	addAnimationByPrefix('Eggman', 'idle', 'egg idle', 16, true);
	addLuaSprite('Text', false);
	addAnimationByPrefix('Text', 'idle', 'text idle', 24, true);
	addLuaSprite('O', false);
	addLuaSprite('S', false);
	addLuaSprite('N', false);
	addLuaSprite('I', false);
	addLuaSprite('C', false);
	addLuaSprite('Mountains', false);
	addLuaSprite('EXE Ring', false);
	addLuaSprite('Lake', false);
	addAnimationByPrefix('Lake', 'idle', 'water idle', 16, true);
	addLuaSprite('Band', false);
	setObjectOrder('Band', getObjectOrder('dadGroup'))
	addAnimationByPrefix('Band', 'idle', 'band idle', 24, true);

	-- Face-to-Face Moment

	makeLuaSprite('way2', 'face-to-face/way2', -1835, -750);
	scaleLuaSprite('way2', 0.85, 0.85)
	addLuaSprite('way2', false);
	setObjectOrder('way2', getObjectOrder('dadGroup'))
	setProperty('way2.visible', false)

	-- Mão Boba moment

	makeAnimatedLuaSprite('Band_perpective', 'maoboba/bandp', -3350, -1580);
	scaleObject('Band_perpective', 1.4, 1.4);
	setProperty('Band_perpective.visible', false)
	addLuaSprite('Band_perpective', false);
	addAnimationByPrefix('Band_perpective', 'idle', 'bandp idle', 24, true);

	makeLuaSprite('daHand', 'maoboba/hand',-2100, -440)
	scaleObject('daHand', 1.4, 1.4);
	setProperty('daHand.visible', false)
	addLuaSprite('daHand', false);

	-- Coisas do Ato2

	makeAnimatedLuaSprite('BandFlat', 'ato2/flatb', -1650, -1580);
	scaleObject('BandFlat', 0.9, 1.3);
	setProperty('BandFlat.visible', false)
	addLuaSprite('BandFlat', false);
	addAnimationByPrefix('BandFlat', 'idle', 'a instance', 24, true);

	--drowning arts
	
	-- Provavelmente isso vai ser modificado.
	makeLuaSprite('drowningArt0', 'drowningArts/drowningArt0', -1300, -600);
    setProperty('drowningArt0.visible', true)
	setProperty("drowningArt0.alpha", 0)
	setObjectCamera('drowningArt0', 'hud2')
	setGraphicSize('drowningArt0', screenWidth, screenHeight)
	screenCenter('drowningArt0')

	makeLuaSprite('drowningArt1', 'drowningArts/drowningArt1', -1300, -600);
    setProperty('drowningArt1.visible', false)
	setProperty("drowningArt1.alpha", 0.5)
	setObjectCamera('drowningArt1', 'camlegenda')
	setGraphicSize('drowningArt1', screenWidth, screenHeight)
	screenCenter('drowningArt1')
	addLuaSprite('drowningArt1', false);

	makeLuaSprite('drowningArt2', 'drowningArts/drowningArt2', -1300, -600);
    setProperty('drowningArt2.visible', false)
	setProperty("drowningArt2.alpha", 0.5)
	setObjectCamera('drowningArt2', 'camlegenda')
	setGraphicSize('drowningArt2', screenWidth, screenHeight)
	screenCenter('drowningArt2')
	addLuaSprite('drowningArt2', false);

	makeLuaSprite('drowningArt3', 'drowningArts/drowningArt3', -1300, -600);
    setProperty('drowningArt3.visible', false)
	setProperty("drowningArt3.alpha", 0.5)
	setObjectCamera('drowningArt3', 'camlegenda')
	setGraphicSize('drowningArt3', screenWidth, screenHeight)
	screenCenter('drowningArt3')
	addLuaSprite('drowningArt3', false);

	makeLuaSprite('drowningArt4', 'drowningArts/drowningArt4', -1300, -600);
    setProperty('drowningArt4.visible', false)
	setProperty("drowningArt4.alpha", 0.5)
	setObjectCamera('drowningArt4', 'camlegenda')
	setGraphicSize('drowningArt4', screenWidth, screenHeight)
	screenCenter('drowningArt4')
	addLuaSprite('drowningArt4', false);
	
	-- CircusMoment

	makeLuaTiledSprite('circusBG', 'circusBG', 2897, 827, true, false)
	setLuaSpriteScrollFactor('circusBG',0.4,0.4)
	setPropertyTiledLuaSprite("circusBG.antialiasing", false)
	setPropertyTiledLuaSprite("circusBG.visible", false)
	setPropertyTiledLuaSprite("circusBG.x", -1000)
	setPropertyTiledLuaSprite("circusBG.y", -25)
	addLuaSprite('circusBG');

end