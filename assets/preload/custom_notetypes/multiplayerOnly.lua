function onCreate()
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
	--Check if the note is an Instakill Note
    -- O coiso do isPlayState é justamente para que eu não tenha que mexer lá no multiplayer, assim eu garanto que as notas só ficam invisiveis no modo normal.
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'multiplayerOnly' and getProperty("isPlayState") == true then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'nota_invisivel'); --Change texture
			setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true)
			setPropertyFromGroup('unspawnNotes', i, 'isinvisibru', true)
            setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true); --Evita erros por não acertar a nota.
                --Essas notas devem ficar invisiveis no PlayState normal, e visiveis apenas no multiplayer.
                -- É uma ideia similar ao que o pessoal da Drop And Roll fez naquela cutscene com o bf cantando.
		end
	end
end