function onStepHit()
	if curStep == 384 or curStep == 768 or curStep == 1151 or curStep == 1172 or curStep == 1276 or curStep == 1282 or curStep == 1304 or curStep == 1536 or curStep == 1922 or curStep == 1937 or curStep == 1943 or curStep == 1956 then
		fleetON()
	end
	if curStep == 640 or curStep == 1024 or curStep == 1154 or curStep == 1176 or curStep == 1279 or curStep == 1300 or curStep == 1408 or curStep == 1792 or curStep == 1926 or curStep == 1940 or curStep == 1946 or curStep == 1960 then
		fleetOFF()
	end
end

function playStat()
    playSound('stat', 0.41, "statSound")
end

function fleetON()
	setProperty('fx.alpha', 0.8)
    playStat()
	triggerEvent('Change Character', 'bf', 'fleetwayPHANTASM')
    triggerEvent('Change Character', 'dad', 'sonicPHANTASM_Invisibru')
	loadGraphic('bg','cenarios/phantasm/fleet_bg')
	loadGraphic('tree','cenarios/phantasm/fleet_tree')
	doTweenAlpha('fleetON', 'fx', 0, 1, 'linear')
end

function fleetOFF()
	setProperty('fx.alpha', 0.8)
    playStat()
	triggerEvent('Change Character', 'bf', 'sonicPHANTASM')
    triggerEvent('Change Character', 'dad', 'fleetwayPHANTASM_Invisibru')
	loadGraphic('bg','cenarios/phantasm/sonic_bg')
	loadGraphic('tree','cenarios/phantasm/sonic_tree')
	doTweenAlpha('fleetON', 'fx', 0, 1, 'linear')
end