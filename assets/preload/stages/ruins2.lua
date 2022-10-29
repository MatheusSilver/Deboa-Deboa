function onCreate()
	-- background shit
	makeLuaSprite('ruins','ruins', -1460, -600)
        addLuaSprite('ruins',false)

        makeAnimatedLuaSprite('Sonic','Sonic', 1200,300)
        addAnimationByPrefix('Sonic','dance','Sonic',24,true)
        addLuaSprite('Sonic', false);

        makeAnimatedLuaSprite('Amy','Amy', 1250,500)
        addAnimationByPrefix('Amy','dance','Amy',24,true)
        addLuaSprite('Amy', false);
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end