function onCreate()
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
	--Check if the note is an Instakill Note
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'invisible GF Sing' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'nota_invisivel'); --Change texture
			setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true)
			setPropertyFromGroup('unspawnNotes', i, 'isinvisibru', true)
		end
	end
	--debugPrint('Script started!')
end

local GFSingAnims = {'singLEFT', 'singDOWN', 'singUP', 'singRIGHT'}
local GFSingDir = 1
function goodNoteHit(id, noteData, noteType, isSustainNote)
	if noteType == 'invisible GF Sing' then
		GFSingDir = direction
		characterPlayAnim('gf', GFSingAnims[GFSingDir+1], true)
	end
end
function opponentNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'invisible GF Sing' then
		GFSingDir = direction
		characterPlayAnim('gf', GFSingAnims[GFSingDir+1], true)
		characterPlayAnim('dad', GFSingAnims[GFSingDir+1], true)
	end
end -- THANKS KEVIN KUNTZ FOR SCRIPT