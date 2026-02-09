function onEvent(name, value1, value2)
	if name == 'Fade UI Complete' then
		type = tonumber(value1)
		duration = tonumber(value2);
		if duration < 0 then
			duration = 0;
		end

		-- Note Stuff Out
		if type == 0 and duration == 0 then
			for i = 0, 4, 1 do
				setPropertyFromGroup('playerStrums', i, 'alpha', 0)
			end
			for i = 0, 4, 1 do
				setPropertyFromGroup('opponentStrums', i, 'alpha', 0)
			end
		elseif type == 0 and duration > 0 then
		noteTweenAlpha("noteGoneOpp1", 0, 0, duration, "quartInOut");
            noteTweenAlpha("noteGoneOpp2", 1, 0, duration, "quartInOut");
            noteTweenAlpha("noteGoneOpp3", 2, 0, duration, "quartInOut");
            noteTweenAlpha("noteGoneOpp4", 3, 0, duration, "quartInOut");
            noteTweenAlpha("noteGone5", 4, 0, duration, "quartInOut");
            noteTweenAlpha("noteGone6", 5, 0, duration, "quartInOut");
            noteTweenAlpha("noteGone7", 6, 0, duration, "quartInOut");
            noteTweenAlpha("noteGone8", 7, 0, duration, "quartInOut");
		end

            if type == 2 and duration == 0 then
			for i = 0, 4, 1 do
				setPropertyFromGroup('opponentStrums', i, 'alpha', 0)
			end
		elseif type == 2 and duration > 0 then
		noteTweenAlpha("noteGoneOpp1", 0, 0, duration, "quartInOut");
            noteTweenAlpha("noteGoneOpp2", 1, 0, duration, "quartInOut");
            noteTweenAlpha("noteGoneOpp3", 2, 0, duration, "quartInOut");
            noteTweenAlpha("noteGoneOpp4", 3, 0, duration, "quartInOut");
		end

            if type == 4 and duration == 0 then
			for i = 0, 4, 1 do
				setPropertyFromGroup('playerStrums', i, 'alpha', 0)
			end
		elseif type == 4 and duration > 0 then
            noteTweenAlpha("noteGone5", 4, 0, duration, "quartInOut");
            noteTweenAlpha("noteGone6", 5, 0, duration, "quartInOut");
            noteTweenAlpha("noteGone7", 6, 0, duration, "quartInOut");
            noteTweenAlpha("noteGone8", 7, 0, duration, "quartInOut");
            end

		-- Note Stuff In
		if type == 1 and duration == 0 then
			for i = 0, 4, 1 do
				setPropertyFromGroup('playerStrums', i, 'alpha', 1)
			end
			for i = 0, 4, 1 do
				setPropertyFromGroup('opponentStrums', i, 'alpha', 1)
			end
		elseif type == 1 and duration > 0 then
		noteTweenAlpha("noteGoneOpp1", 0, 1, duration, "quartInOut");
            noteTweenAlpha("noteGoneOpp2", 1, 1, duration, "quartInOut");
            noteTweenAlpha("noteGoneOpp3", 2, 1, duration, "quartInOut");
            noteTweenAlpha("noteGoneOpp4", 3, 1, duration, "quartInOut");
            noteTweenAlpha("noteGone5", 4, 1, duration, "quartInOut");
            noteTweenAlpha("noteGone6", 5, 1, duration, "quartInOut");
            noteTweenAlpha("noteGone7", 6, 1, duration, "quartInOut");
            noteTweenAlpha("noteGone8", 7, 1, duration, "quartInOut");
		end

            if type == 3 and duration == 0 then
			for i = 0, 4, 1 do
				setPropertyFromGroup('opponentStrums', i, 'alpha', 1)
			end
		elseif type == 3 and duration > 0 then
		noteTweenAlpha("noteGoneOpp1", 0, 1, duration, "quartInOut");
            noteTweenAlpha("noteGoneOpp2", 1, 1, duration, "quartInOut");
            noteTweenAlpha("noteGoneOpp3", 2, 1, duration, "quartInOut");
            noteTweenAlpha("noteGoneOpp4", 3, 1, duration, "quartInOut");
		end

            if type == 5 and duration == 0 then
			for i = 0, 4, 1 do
				setPropertyFromGroup('playerStrums', i, 'alpha', 1)
			end
		elseif type == 5 and duration > 0 then
            noteTweenAlpha("noteGone5", 4, 1, duration, "quartInOut");
            noteTweenAlpha("noteGone6", 5, 1, duration, "quartInOut");
            noteTweenAlpha("noteGone7", 6, 1, duration, "quartInOut");
            noteTweenAlpha("noteGone8", 7, 1, duration, "quartInOut");
		end
           
            --UI Stuff Out

            if type == 6 and duration == 0 then
            setProperty('HUD.healthBar.alpha',  0)
            setProperty('HUD.iconP1.alpha',  0)
            setProperty('HUD.iconP2.alpha',  0)
            setProperty('HUD.scoreTxt.alpha',  0)
            setProperty('HUD.timeBar.alpha', 0)
            setProperty('HUD.timeTxt.alpha', 0)
            elseif type == 6 and duration > 0 then
            doTweenAlpha('hp', 'HUD.healthBar', 0, duration, 'quartInOut')
            doTweenAlpha('hpicon1', 'HUD.iconP1', 0, duration, 'quartInOut')
            doTweenAlpha('hpicon2', 'HUD.iconP2', 0, duration, 'quartInOut')
            doTweenAlpha('score', 'HUD.scoreTxt', 0, duration, 'quartInOut')
            doTweenAlpha('timeBar', 'HUD.timeBar', 0, duration, 'quartInOut')
            doTweenAlpha('timeBarTxt', 'HUD.timeTxt', 0, duration, 'quartInOut')
            end

            if type == 8 and duration == 0 then
            setProperty('HUD.healthBar.alpha',  0)
            setProperty('HUD.iconP1.alpha',  0)
            setProperty('HUD.iconP2.alpha',  0)
            setProperty('HUD.scoreTxt.alpha',  0)
            elseif type == 8 and duration > 0 then
            doTweenAlpha('hp', 'HUD.healthBar', 0, duration, 'quartInOut')
            doTweenAlpha('hpicon1', 'HUD.iconP1', 0, duration, 'quartInOut')
            doTweenAlpha('hpicon2', 'HUD.iconP2', 0, duration, 'quartInOut')
            doTweenAlpha('score', 'HUD.scoreTxt', 0, duration, 'quartInOut')
            end

            if type == 10 and duration == 0 then
            setProperty('HUD.timeBar.alpha', 0)
            setProperty('HUD.timeTxt.alpha', 0)
            elseif type == 10 and duration > 0 then
            doTweenAlpha('timeBar', 'HUD.timeBar', 0, duration, 'quartInOut')
            doTweenAlpha('timeBarTxt', 'HUD.timeTxt', 0, duration, 'quartInOut')
            end

            -- UI Stuff In
            if type == 7 and duration == 0 then
            setProperty('HUD.healthBar.alpha',  1)
            setProperty('HUD.iconP1.alpha',  1)
            setProperty('HUD.iconP2.alpha',  1)
            setProperty('HUD.scoreTxt.alpha',  1)
            setProperty('HUD.timeBar.alpha', 1)
            setProperty('HUD.timeTxt.alpha', 1)
		elseif type == 7 and duration > 0 then
            doTweenAlpha('hp', 'HUD.healthBar', 1, duration, 'quartInOut')
            doTweenAlpha('hpicon1', 'HUD.iconP1', 1, duration, 'quartInOut')
            doTweenAlpha('hpicon2', 'HUD.iconP2', 1, duration, 'quartInOut')
            doTweenAlpha('score', 'HUD.scoreTxt', 1, duration, 'quartInOut')
            doTweenAlpha('timeBar', 'HUD.timeBar', 1, duration, 'quartInOut')
            doTweenAlpha('timeBarTxt', 'HUD.timeTxt', 1, duration, 'quartInOut')
		end
            
            if type == 9 and duration == 0 then
            setProperty('HUD.healthBar.alpha',  1)
            setProperty('HUD.iconP1.alpha',  1)
            setProperty('HUD.iconP2.alpha',  1)
            setProperty('HUD.scoreTxt.alpha',  1)
            elseif type == 9 and duration > 0 then
            doTweenAlpha('hp', 'HUD.healthBar', 1, duration, 'quartInOut')
            doTweenAlpha('hpicon1', 'HUD.iconP1', 1, duration, 'quartInOut')
            doTweenAlpha('hpicon2', 'HUD.iconP2', 1, duration, 'quartInOut')
            doTweenAlpha('score', 'HUD.scoreTxt', 1, duration, 'quartInOut')
            end

            if type == 11 and duration == 0 then
            setProperty('HUD.timeBar.alpha', 1)
            setProperty('HUD.timeTxt.alpha', 1)
            elseif type == 11 and duration > 0 then
            doTweenAlpha('timeBar', 'HUD.timeBar', 1, duration, 'quartInOut')
            doTweenAlpha('timeBarTxt', 'HUD.timeTxt', 1, duration, 'quartInOut')
            end

            --Everything In

            if type == 12 and duration == 0 then
			for i = 0, 4, 1 do
				setPropertyFromGroup('playerStrums', i, 'alpha', 0)
			end
			for i = 0, 4, 1 do
				setPropertyFromGroup('opponentStrums', i, 'alpha', 0)
			end
            setProperty('HUD.healthBar.alpha',  0)
            setProperty('HUD.iconP1.alpha',  0)
            setProperty('HUD.iconP2.alpha',  0)
            setProperty('HUD.scoreTxt.alpha',  0)
            setProperty('HUD.timeBar.alpha', 0)
            setProperty('HUD.timeTxt.alpha', 0)
            setProperty('HUD.botplayTxt.alpha', 0)
		elseif type == 12 and duration > 0 then
            noteTweenAlpha("noteGoneOpp1", 0, 0, duration, "quartInOut");
            noteTweenAlpha("noteGoneOpp2", 1, 0, duration, "quartInOut");
            noteTweenAlpha("noteGoneOpp3", 2, 0, duration, "quartInOut");
            noteTweenAlpha("noteGoneOpp4", 3, 0, duration, "quartInOut");
            noteTweenAlpha("noteGone5", 4, 0, duration, "quartInOut");
            noteTweenAlpha("noteGone6", 5, 0, duration, "quartInOut");
            noteTweenAlpha("noteGone7", 6, 0, duration, "quartInOut");
            noteTweenAlpha("noteGone8", 7, 0, duration, "quartInOut");
            doTweenAlpha('hp', 'HUD.healthBar', 0, duration, 'quartInOut')
            doTweenAlpha('hpicon1', 'HUD.iconP1', 0, duration, 'quartInOut')
            doTweenAlpha('hpicon2', 'HUD.iconP2', 0, duration, 'quartInOut')
            doTweenAlpha('score', 'HUD.scoreTxt', 0, duration, 'quartInOut')
            doTweenAlpha('timeBar', 'HUD.timeBar', 0, duration, 'quartInOut')
            doTweenAlpha('timeBarTxt', 'HUD.timeTxt', 0, duration, 'quartInOut')
            doTweenAlpha('botplytxt', 'HUD.botplayTxt', 0, duration, 'quartInOut')
		end

            --Everything Out

            if type == 13 and duration == 0 then
			for i = 0, 4, 1 do
				setPropertyFromGroup('playerStrums', i, 'alpha', 1)
			end
			for i = 0, 4, 1 do
				setPropertyFromGroup('opponentStrums', i, 'alpha', 1)
			end
            setProperty('HUD.healthBar.alpha',  1)
            setProperty('HUD.iconP1.alpha',  1)
            setProperty('HUD.iconP2.alpha',  1)
            setProperty('HUD.scoreTxt.alpha',  1)
            setProperty('HUD.timeBar.alpha', 1)
            setProperty('HUD.timeTxt.alpha', 1)
            setProperty('HUD.botplayTxt.alpha', 1)
		elseif type == 13 and duration > 0 then
		noteTweenAlpha("noteGoneOpp1", 0, 1, duration, "quartInOut");
            noteTweenAlpha("noteGoneOpp2", 1, 1, duration, "quartInOut");
            noteTweenAlpha("noteGoneOpp3", 2, 1, duration, "quartInOut");
            noteTweenAlpha("noteGoneOpp4", 3, 1, duration, "quartInOut");
            noteTweenAlpha("noteGone5", 4, 1, duration, "quartInOut");
            noteTweenAlpha("noteGone6", 5, 1, duration, "quartInOut");
            noteTweenAlpha("noteGone7", 6, 1, duration, "quartInOut");
            noteTweenAlpha("noteGone8", 7, 1, duration, "quartInOut");
            doTweenAlpha('hp', 'HUD.healthBar', 1, duration, 'quartInOut')
            doTweenAlpha('hpicon1', 'HUD.iconP1', 1, duration, 'quartInOut')
            doTweenAlpha('hpicon2', 'HUD.iconP2', 1, duration, 'quartInOut')
            doTweenAlpha('score', 'HUD.scoreTxt', 1, duration, 'quartInOut')
            doTweenAlpha('timeBar', 'HUD.timeBar', 1, duration, 'quartInOut')
            doTweenAlpha('timeBarTxt', 'HUD.timeTxt', 1, duration, 'quartInOut')
            doTweenAlpha('botplytxt', 'HUD.botplayTxt', 1, duration, 'quartInOut')
		end
	end
end