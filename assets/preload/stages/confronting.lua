local speedChanger = 0

function onCreate()
	
	makeLuaTiledSprite('ceu','cenarios/phase1/ceu',1892,256,true,false) --1
	setLuaSpriteScrollFactor('ceu',0.4,0.4)
	setPropertyTiledLuaSprite("ceu.antialiasing", false)
	setPropertyTiledLuaSprite("ceu.x", -555)
	setPropertyTiledLuaSprite("ceu.y", -225)
	addLuaSprite('ceu');

	makeLuaSprite('montanhas','cenarios/phase1/montanhas',75,105) --2
	setLuaSpriteScrollFactor('montanhas',0.5,0.5)
	setProperty('montanhas.scale.x', 4.5)
	setProperty('montanhas.scale.y', 4.5)
	setProperty('montanhas.antialiasing', false)
	addLuaSprite('montanhas',false)

	makeAnimatedLuaSprite('awa','cenarios/phase1/awa',-300,500) --4
	setLuaSpriteScrollFactor('awa',0.6,0.6)
	addAnimationByPrefix('awa', 'bg1', 'bg1', 16, true);
	setProperty('awa.scale.x', 3)
	setProperty('awa.scale.y', 3)
	setProperty('awa.antialiasing', false)
	addLuaSprite('awa',false)
	objectPlayAnimation('awa', 'bg1', true)

	makeAnimatedLuaSprite('cachorreira','cenarios/phase1/cachorreira',-50,305) --3
	setLuaSpriteScrollFactor('cachorreira',0.6,0.6)
	addAnimationByPrefix('cachorreira', 'bg2', 'bg2', 16, true);
	setProperty('cachorreira.antialiasing', false)
	setProperty('cachorreira.scale.x', 5)
	setProperty('cachorreira.scale.y', 5)
	addLuaSprite('cachorreira',false)
	objectPlayAnimation('cachorreira', 'bg2', true)

	makeLuaSprite('montesverdes','cenarios/phase1/GHGround',0,100)--5
	setLuaSpriteScrollFactor('montesverdes',0.7,0.7)
	setProperty('montesverdes.scale.x', 5)
	setProperty('montesverdes.scale.y', 5)
	setProperty('montesverdes.antialiasing', false)
	addLuaSprite('montesverdes',false)

	makeAnimatedLuaSprite('flores','cenarios/phase1/flowers',0,105) --6
	setLuaSpriteScrollFactor('flores',0.7,0.7)
	addAnimationByPrefix('flores', 'flowerloop', 'flowerloop', 16, true);
	setProperty('flores.antialiasing', false)
	setProperty('flores.scale.x', 5)
	setProperty('flores.scale.y', 5)
	addLuaSprite('flores',false)
	objectPlayAnimation('flores', 'flowerloop', true)

	makeAnimatedLuaSprite('trens','cenarios/phase1/objects',0,100) --7
	setLuaSpriteScrollFactor('trens',0.7,0.7)
	addAnimationByPrefix('trens', 'objects', 'objects', 16, true);
	setProperty('trens.antialiasing', false)
	setProperty('trens.scale.x', 5)
	setProperty('trens.scale.y', 5)
	addLuaSprite('trens',false)
	objectPlayAnimation('trens', 'objects', true)


end

function onUpdate()
	speedChanger = speedChanger + 1
	setPropertyTiledLuaSprite("ceu.scrollX", speedChanger*0.5)
end
