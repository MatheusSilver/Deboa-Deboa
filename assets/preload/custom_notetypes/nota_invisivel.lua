function onCreate()
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'nota_invisivel' and not getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'nota_invisivel');
			setPropertyFromGroup('unspawnNotes', i, 'isinvisibru', true)
		end
	end
end