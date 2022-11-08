-- Event notes hooks
function onEvent(name, value1, value2)
	if name == 'Hud Fade' then
		duration = value1;
		if duration < 0 then
			duration = 0;
		end

		targetAlpha = value2;
		if duration == 0 then
			setProperty('camhud.alpha', targetAlpha);
		else
			doTweenAlpha('hudFadeEventTween', 'camhud', targetAlpha, duration, 'linear');
		end
		--debugPrint('Event triggered: ', name, duration, targetAlpha);
	end
end