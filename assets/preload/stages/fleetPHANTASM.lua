function onCreate() -- Isso aqui é só pro setup dos cenários
					-- e para o setup das transições
	precacheSound('stat')
	precacheImage('cenarios/phantasm/fleet_bg')
	precacheImage('cenarios/phantasm/fleet_tree')
	addCharacterToList('fleetwayPHANTASM', 'boyfriend')
	addCharacterToList('sonicPHANTASM', 'boyfriend')
	addCharacterToList('fleetwayPHANTASM_Invisibru', 'boyfriend')
	addCharacterToList('sonicPHANTASM_Invisibru', 'boyfriend')
	addCharacterToList('fleetwayPHANTASM_Invisibru', 'dad')
	addCharacterToList('sonicPHANTASM_Invisibru', 'dad')

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

end

function onStartCountdown()
	setProperty('gf.alpha', 0)
	setProperty('dad.alpha', 0)
	
	setPropertyFromClass('GameOverSubstate', 'bgType', 'sonic'); --Character json file for the death animation
	setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'gameOverEndSonic'); --put in mods/sounds/
	setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'breakfast'); --put in mods/sounds/
	
	return Function_Continue
end