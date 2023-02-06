function onCreate()
	
	makeLuaSprite('MOONBACK','cenarios/piracy/BG',-500,-500)
	addLuaSprite('MOONBACK',false)
	setLuaSpriteScrollFactor('MOONBACK',0,0)
	--close(true);
		
	makeLuaSprite('TREESBACK','cenarios/piracy/BGTREES', -300,-0)
	addLuaSprite('TREESBACK',false)
	setLuaSpriteScrollFactor('TREESBG',0,0)
	
	makeLuaSprite('GROUND1','cenarios/piracy/GROUND',-750,-200)
	addLuaSprite('GROUND1', false)

	makeAnimatedLuaSprite('tailsd', 'cenarios/piracy/TBOP', -70, 300)
	addAnimationByPrefix('tailsd', 'bopidle', 'tailsbop', 24, null)
	addLuaSprite('tailsd', false)

	
	makeAnimatedLuaSprite('KNUCKLESD', 'cenarios/piracy/KNUXBOP', 900, 200)
	addAnimationByPrefix('KNUCKLESD', 'boppidle', 'knucklesbop', 24, null)
	addLuaSprite('KNUCKLESD', false)

	end

function onBeatHit()
	objectPlayAnimation('tailsd', 'bopidle', true)
	objectPlayAnimation('KNUCKLESD', 'boppidle', true)
end