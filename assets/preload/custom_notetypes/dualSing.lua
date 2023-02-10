function onCreate()
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'dualSing' then
			setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true)
		end
	end
end

--Basicamente isso é só uma solução preguiçosa (Ou talvez melhor k) que fazer a música por eventos na Sidekick

local GFSingAnims = {'singLEFT', 'singDOWN', 'singUP', 'singRIGHT'}
local GFSingDir = 1
function goodNoteHit(id, noteData, noteType, isSustainNote)
	if noteType == 'dualSing' then
		GFSingDir = direction
		characterPlayAnim('gf', GFSingAnims[GFSingDir+1], true)
	end
end
function opponentNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'dualSing' then
		GFSingDir = direction
		characterPlayAnim('gf', GFSingAnims[GFSingDir+1], true)
		characterPlayAnim('dad', GFSingAnims[GFSingDir+1], true)
	end
end -- THANKS KEVIN KUNTZ FOR SCRIPT