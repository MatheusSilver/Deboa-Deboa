function onCreate() -- O master.lua nesse caso serve somente para precache
                    -- e coisas fora cenários
    precacheSound('stat')
	precacheImage('cenarios/phantasm/fleet_bg')
	precacheImage('cenarios/phantasm/fleet_tree')
	addCharacterToList('fleetwayPHANTASM', 'boyfriend')

    setProperty('gf.visible', false)
	setProperty('dad.visible', false)
	setProperty('iconP2.visible', false)

    setPropertyFromClass('GameOverSubstate', 'bgType', 'sonic'); --Character json file for the death animation
    setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'gameOverEndSonic'); --put in mods/sounds/
    setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'breakfast'); --put in mods/sounds/
end