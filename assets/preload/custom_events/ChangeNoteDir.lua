function onEvent(name, value1, value2)
	if name == 'ChangeNoteDir' then
		noteTweenAngle('A', 0, value2, value1, 'circOut')
		noteTweenAngle('B', 1, value2, value1, 'circOut')
		noteTweenAngle('C', 2, value2, value1, 'circOut')
		noteTweenAngle('D', 3, value2, value1, 'circOut')

		noteTweenAngle('E', 4, value2, value1, 'circOut')
		noteTweenAngle('F', 5, value2, value1, 'circOut')
		noteTweenAngle('J', 6, value2, value1, 'circOut')
		noteTweenAngle('H', 7, value2, value1, 'circOut')
	end
end
