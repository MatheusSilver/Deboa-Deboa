k = 50
function onEvent(name, value1, value2)
	if not downscroll then
		k = 50
	end
	if downscroll then
		k = 570
	end
	if name == 'NoteMoveProper' then
		noteTweenY('A', 0, k, value1, 'linear')
		noteTweenY('B', 1, k, value1, 'linear')
		noteTweenY('C', 2, k, value1, 'linear')
		noteTweenY('D', 3, k, value1, 'linear')
		noteTweenY('E', 4, k, value1, 'linear')
		noteTweenY('F', 5, k, value1, 'linear')
		noteTweenY('J', 6, k, value1, 'linear')
		noteTweenY('H', 7, k, value1, 'linear')
	end
end