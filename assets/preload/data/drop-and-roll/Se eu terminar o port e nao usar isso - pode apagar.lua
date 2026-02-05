-- Script by a dumbass you just watched from (HenrySMD)

local healthBarIsFlip = true
local stickThere = false
function onUpdate(elapsed)
	if healthBarIsFlip == true then -- if you want to flip the health bar or not (set to true to flip, set false will turn back to normal)
		setProperty('HUD.healthBar.flipX', true)

		if getProperty('health') < 2 then
			stickThere = false
		end

		if getProperty('health') >= 2 then
			stickThere = true
		end
	else
		setProperty('HUD.healthBar.flipX', false)
	end
end

function onUpdatePost()
	if healthBarIsFlip == true then
		setProperty('HUD.iconP1.flipX', true)
		setProperty('HUD.iconP2.flipX', true)

		if stickThere == false then
			if getProperty('health') > 0 then
				setProperty('HUD.iconP1.x', 216+getProperty('health')*296+getProperty('HUD.healthBar.x')-343.5)
				setProperty('HUD.iconP2.x', 317+getProperty('health')*297+getProperty('HUD.healthBar.x')-343.5)
			end

			if getProperty('health') <= 0 then
				setProperty('HUD.iconP1.x', 216+getProperty('HUD.healthBar.x')-343.5)
				setProperty('HUD.iconP2.x', 317+getProperty('HUD.healthBar.x')-343.5)
			end
		end

		if stickThere == true then
		   setProperty('HUD.iconP1.x', 808+getProperty('HUD.healthBar.x')-343.5)
		   setProperty('HUD.iconP2.x', 911+getProperty('HUD.healthBar.x')-343.5)
		end

		--setProperty('HUD.iconP1.y', getProperty('HUD.healthBar.y') -75) -- icons stick to health bar (y position), I added if you guys want
		--setProperty('HUD.iconP2.y', getProperty('HUD.healthBar.y') -75)
	else
		setProperty('HUD.iconP1.flipX', false)
		setProperty('HUD.iconP2.flipX', false)
	end
end