function onCreate()
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		--Check if the note is an Blammed Note
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Ice Note' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'ICENOTE_assets'); --Change texture

			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') == true then --Doesn't let Dad/Opponent notes get ignored
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true); --Miss has penalties
			else
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', false); --Miss has penalties
			end
		end
	end
end