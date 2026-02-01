local flyingItemsRightPos = -3500
local flyingItemsLeftPos = 3500

function onCreate()

---Code by berserk

--- E FORTEMENTE modificado por Matheus Silver...

--- PRA QUE TANTO SETOBJECTORDER????????????

	makeLuaSprite('GardientFOREST', 'forestgradient', -300, -50)
	
	scaleObject('GardientFOREST', 1.2, 1.2)

	addLuaSprite('GardientFOREST')
	
	setProperty('GardientFOREST.visible', true)

    makeAnimatedLuaSprite('waterfall', 'waterfall', 550, 100);
    
	addAnimationByPrefix('waterfall', 'idle', 'waterfall', 24, true);
	
	scaleObject('waterfall', 1, 1);
	
	addLuaSprite('waterfall');
	
	setProperty('waterfall.visible', true)

   	makeLuaSprite('forest', 'forest', -420, 120)
	
	setObjectOrder('forest', 2)
	
	scaleObject('forest', 1.1, 1.1)

	addLuaSprite('forest')
	
	setProperty('forest.visible', true)
	
	makeLuaSprite('leaves1', 'leaves1', -200, -100)
	
	setObjectOrder('leaves1', 3)
	
	scaleObject('leaves1', 0.7, 0.7)

	addLuaSprite('leaves1', true)
	
	setProperty('leaves1.visible', true)
	
	setObjectCamera('leaves1','hud');

	-- Ok... Consigo aceitar o de cima.
    
	makeLuaSprite('obj1234', 'blackscreen', -400, 0)
	
	scaleObject('obj1234', 2.5, 2.5)

	--	addLuaSprite('obj1234', true)
	
	
	-- NÃO, SÓ NÃO!!!
	
	addLuaSprite('obj1234')
	
	setProperty('obj1234.visible', true)


	---PART 2
    
    
    makeLuaSprite('RegularSky', 'regularsky', -170, -150)
	
	setObjectOrder('RegularSky', 0)
	
	scaleObject('RegularSky', 1.1, 1.1)

	addLuaSprite('RegularSky')
	
	setProperty('RegularSky.visible', false)

    makeLuaSprite('RegularSkyF', 'Firesky', -170, -180)
	
	scaleObject('RegularSkyF', 1.1, 1.1)

	addLuaSprite('RegularSkyF')
	
	setProperty('RegularSkyF.visible', false)

	makeLuaSprite('obj1', 'obj1', flyingItemsLeftPos, 200)
	addLuaSprite('obj1');
	scaleObject('obj1', 0.85, 0.85)
	setProperty('obj1.visible', false)
	
	makeLuaSprite('obj2', 'obj2', flyingItemsRightPos, 300)
	scaleObject('obj2', 0.85, 1)
	addLuaSprite('obj2');
	setProperty('obj2.visible', false)

	makeLuaSprite('mountains2', 'mountains2', -100, 489)
	
	setObjectOrder('mountains2', 1)
	
	scaleObject('mountains2', 1, 1)

	addLuaSprite('mountains2')
	
	setProperty('mountains2.visible', false)

   	makeLuaSprite('mountains', 'mountains', 100, 389)
	
	setObjectOrder('mountains', 2)
	
	scaleObject('mountains', 1, 1)

	addLuaSprite('mountains')
	
	setProperty('mountains.visible', false)
	
	makeAnimatedLuaSprite('sea1', 'sea1', -100, 700);
    makeLuaSprite('sand1', 'sand1', 100, 1000)
	
	setObjectOrder('sand1', 4)
	
	scaleObject('sand1', 1, 1)

	addLuaSprite('sand1')
	
	setProperty('sand1.visible', false)

	addAnimationByPrefix('sea1', 'idle', 'sea1', 24, true);
	
	scaleObject('sea1', 1.2, 1);
	
	addLuaSprite('sea1');
	
	setProperty('sea1.visible', false)
    

    makeAnimatedLuaSprite('fireleaves', 'fireleaves', -150, -98);
    
	addAnimationByPrefix('fireleaves', 'idle', 'leaves', 24, true);
	
	scaleObject('fireleaves', 0.7, 0.7);
	
	setProperty('fireleaves.visible', false)
    
    setObjectCamera('fireleaves','hud');
    
	addLuaSprite('fireleaves', true)


	---PART3

	makeLuaSprite('RegularSkyFF', 'Firesky', -700, -180)

	setObjectOrder('RegularSkyFF', 0)

	scaleObject('RegularSkyFF', 1.1, 1.1)

	addLuaSprite('RegularSkyFF')

	setProperty('RegularSkyFF.visible', false)

	makeLuaSprite('sand2', 'sand2', -200, -50)
	
	scaleObject('sand2', 1, 1)

	addLuaSprite('sand2')
	
	setProperty('sand2.visible', false)

    makeAnimatedLuaSprite('sea2', 'sea2', -930, 496);
    
	addAnimationByPrefix('sea2', 'idle', 'sea2', 24, true);
	
	scaleObject('sea2', 1.1, 1.1);
	
	addLuaSprite('sea2');
	
	setProperty('sea2.visible', false)


end
	
	
---thanks deh4nk for this code
---Isso estava desnecessariamente bagunçado...
function onTweenCompleted(tag)
	if tag == 'obj1Move' then 
		setProperty("obj1.x", flyingItemsLeftPos)
		doTweenX('obj1Move', 'obj1', flyingItemsRightPos, 12, 'linear')
	end
	if tag == 'obj2Move' then
		setProperty("obj2.x", flyingItemsRightPos)
		doTweenX('obj2Move', 'obj2', flyingItemsLeftPos, 14, 'linear')
	end
end

function onEvent(event, v1, v2)
	if event == "trocar ato" then
		if v1 == "64" then
			setProperty('obj1234.visible', false)
		elseif v1 == "352" then
			setProperty('sea1.visible', true)
			setProperty('sand1.visible', true)
			setProperty('mountains.visible', true)
			setProperty('mountains2.visible', true)
			setProperty('RegularSky.visible', true)
			setProperty('GardientFOREST.visible', false)
			setProperty('waterfall.visible', false)
			setProperty('forest.visible', false)
		elseif v1 == "1215" then
			setProperty('RegularSkyF.visible', true)
			setProperty('RegularSky.visible', false)
			setProperty('fireleaves.visible', true)
			setProperty('leaves1.visible', false)
			setProperty('obj1.visible', true)
			setProperty('obj2.visible', true)


			doTweenX('obj1Move', 'obj1', flyingItemsRightPos, 12, 'linear')
			doTweenX('obj2Move', 'obj2', flyingItemsLeftPos, 14, 'linear')
		
		elseif v1 == "2606" then
			setProperty('RegularSkyFF.visible', true)
			setProperty('sand2.visible', true)
			setProperty('sea2.visible', true)
			
			setProperty('RegularSkyF.visible', false)
			setProperty('mountains2.visible', false)
			setProperty('sea1.visible', false)
			setProperty('sand1.visible', false)
			setProperty('mountains.visible', false)
			setProperty('obj1.visible', false)
			setProperty('obj2.visible', false)
			

			-- Só faz o tween enquanto ele estiver vísivel... 
			cancelTween("obj1Move")
			cancelTween("obj2Move")
		end
	end

end