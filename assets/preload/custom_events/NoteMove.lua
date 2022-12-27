k = 50

function onEvent(name, value1, value2)
	if name == 'NoteMove' then
		noteTweenY('A', 0, k + value2, value1, 'linear')
		noteTweenY('B', 1, k - value2, value1, 'linear')
		noteTweenY('C', 2, k + value2, value1, 'linear')
		noteTweenY('D', 3, k - value2, value1, 'linear')
		noteTweenY('E', 4, k + value2, value1, 'linear')
		noteTweenY('F', 5, k - value2, value1, 'linear')
		noteTweenY('J', 6, k + value2, value1, 'linear')
		noteTweenY('H', 7, k - value2, value1, 'linear')
	end
end