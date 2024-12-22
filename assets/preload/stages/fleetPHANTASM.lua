local bgs = {'fleet', 'sonic'}

function onCreate()
	precacheSound('stat')
	precacheImage('cenarios/phantasm/fleet_bg')
	precacheImage('cenarios/phantasm/fleet_tree')
	addCharacterToList('fleetwayPHANTASM', 'boyfriend')
	
	makeAnimatedLuaSprite('fx', 'vintage', 0, 0)
	addAnimationByPrefix('fx', 'idle', 'idle', 16, true)
	scaleObject('fx', 3, 3)
	setObjectCamera('fx', 'camHud')
	objectPlayAnimation('fx', 'idle', true)
	setProperty('fx.alpha', 0)
	addLuaSprite('fx', true)

	makeLuaSprite('bg', 'cenarios/phantasm/sonic_bg', 0, 0)
	addLuaSprite('bg', false)

	makeLuaSprite('tree', 'cenarios/phantasm/sonic_tree', 0, 0)
	addLuaSprite('tree', false)

	setPropertyFromClass('GameOverSubstate', 'bgType', 'sonic'); --Character json file for the death animation
    setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'gameOverEndSonic'); --put in mods/sounds/
    setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'breakfast'); --put in mods/sounds/
end

function onStartCountdown()
	setProperty('gf.alpha', 0)
	setProperty('dad.alpha', 0)
	setProperty('iconP2.alpha', 0)
	
	return Function_Continue
end

function onStepHit()
	if curStep == 384 or curStep == 768 or curStep == 1151 or curStep == 1172 or curStep == 1276 or curStep == 1282 or curStep == 1304 or curStep == 1536 or curStep == 1922 or curStep == 1937 or curStep == 1943 or curStep == 1956 then
		fleetON()
	end
	if curStep == 640 or curStep == 1024 or curStep == 1154 or curStep == 1176 or curStep == 1279 or curStep == 1300 or curStep == 1408 or curStep == 1792 or curStep == 1926 or curStep == 1940 or curStep == 1946 or curStep == 1960 then
		fleetOFF()
	end
end

function fleetON()
	setProperty('fx.alpha', 0.8)
	loadGraphic('bg','cenarios/phantasm/fleet_bg')
	loadGraphic('tree','cenarios/phantasm/fleet_tree')
	doTweenAlpha('fleetON', 'fx', 0, 1, 'linear')
	playSound('stat', 0.3)
	triggerEvent('Change Character', 0, 'fleetwayPHANTASM')
end

function fleetOFF()
	setProperty('fx.alpha', 0.8)
	loadGraphic('bg','cenarios/phantasm/sonic_bg')
	loadGraphic('tree','cenarios/phantasm/sonic_tree')
	doTweenAlpha('fleetON', 'fx', 0, 1, 'linear')
	playSound('stat', 0.3)
	triggerEvent('Change Character', 0, 'sonicPHANTASM')
end