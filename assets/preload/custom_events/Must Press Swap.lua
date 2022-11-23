function onEvent(name, value1, value2)
	if name == "Must Press Swap" then
		for i = 0, 3 do
			j = (i + 4)

			iPos = _G['defaultPlayerStrumX'..i];
			jPos = _G['defaultOpponentStrumX'..i];
			if alreadySwapped then
				iPos = _G['defaultOpponentStrumX'..i];
				jPos = _G['defaultPlayerStrumX'..i];
			end
			noteTweenX('note'..i..'TwnX', i, iPos, 0.01, 'quadInOut');
			noteTweenX('note'..j..'TwnX', j, jPos, 0.01, 'quadInOut');
		end
		alreadySwapped = not alreadySwapped;
	end
end