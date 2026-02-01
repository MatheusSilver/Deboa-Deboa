-- Fun Fact, em todos estes anos nesta industria vital, está é a primeira vez que um dos custom luas mais antigos é usado (Drop And Roll)

function onEvent(name, value1, value2)
	if name == 'BlackOut' then
		if flashing then
		if value1 == 'true' then
		makeLuaSprite('BlackFlash', 'blackscreen', -700, -120);
		scaleObject('BlackFlash', 18, 22);
		addLuaSprite('BlackFlash', true)
		setProperty('BlackFlash.visible', true);
		elseif value1 == 'false' then
		setProperty('BlackFlash.visible', false)
			end
		end
	end
end