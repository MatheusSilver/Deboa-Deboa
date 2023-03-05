local prevtexture =''
function onEvent(name, value1, value2)
	if name == 'noteskinchangeBF' then
	if value1 == '' then
	-- do nothing lol
	else
		for i = 0, getProperty('unspawnNotes.length')-1 do
			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') == true and getPropertyFromGroup('unspawnNotes', i, 'texture') == prevtexture then -- man...
			setPropertyFromGroup('unspawnNotes', i, 'texture', value1);
			end
		end
		for i = 0, getProperty('playerStrums.length')-1 do
			setPropertyFromGroup('playerStrums', i, 'texture', value1); -- Experimental, mas acho que deve funfar
		end
		prevtexture = value1
	end
	if value2 == '' then
	-- do nothing lol
	else
		for i = 0, getProperty('unspawnNotes.length')-1 do
			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture', value2);
			end
		end
	end
end
end