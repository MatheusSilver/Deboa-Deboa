local prevtexture2 =''
function onEvent(name, value1, value2) 
	if name == 'noteskinchangeOPPT' then
	if value1 == '' then
	-- do nothing lol
	else
		for i = 0, getProperty('unspawnNotes.length')-1 do
			if not getPropertyFromGroup('unspawnNotes', i, 'mustPress') and getPropertyFromGroup('unspawnNotes', i, 'texture') == prevtexture2  then
			setPropertyFromGroup('unspawnNotes', i, 'texture', value1);
			end
		end
		for i = 0, getProperty('opponentStrums.length')-1 do
			setPropertyFromGroup('opponentStrums', i, 'texture', value1); -- Experimental, mas acho que deve funfar
		end
		prevtexture2 = value1
	end 
	
	if value2 == '' then
	-- do nothing lol
	else
		for i = 0, getProperty('unspawnNotes.length')-1 do
			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') == false then
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture', value2);
			end
		end
	end
end
end