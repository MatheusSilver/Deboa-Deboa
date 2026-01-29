function onCreate()
	precacheImage('staticNotes')
	precacheSound('hitStatic1')
	precacheImage('hitStatic');
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'staticNotes' then 
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'staticNotes');

			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then --Doesn't let Dad/Opponent notes get ignored
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', false); --Miss has penalties
			end
		end
	end
end

function onCreatePost()
	loadStatic()
end


function noteMiss(id, direction, noteType, isSustainNote)
	if noteType == 'staticNotes' then
		triggerEvent('StaticMiss');
	end
end

