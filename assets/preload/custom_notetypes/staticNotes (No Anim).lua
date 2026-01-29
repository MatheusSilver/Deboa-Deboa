function onCreate()
	precacheImage('staticNotes')
	precacheSound('hitStatic1')
	precacheImage('hitStatic');
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'staticNotes (No Anim)' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'staticNotes');
			setPropertyFromGroup('unspawnNotes', i, 'hitHealth', '0.023');
			setPropertyFromGroup('unspawnNotes', i, 'missHealth', '0.3');
			setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true);
			setPropertyFromGroup('unspawnNotes', i, 'hitCausesMiss', false);
		end
	end
end

function onCreatePost()
	loadStatic()
end

function noteMiss(id, noteData, noteType, isSustainNote)
	if noteType == 'staticNotes' then
		triggerEvent('StaticMiss');
	end
end