local prevtexture = ''
local pendingIndex = 0
local pendingTextureChange = nil	
local batchSize = 20 -- X02 ache um valor bom para esse coiso aqui

function onEvent(name, value1, value2)
    if name == 'noteskinchangeBF' then
        if value1 ~= '' then
            pendingTextureChange = {
                texture = value1,
                splashTexture = value2,
                totalNotes = getProperty('unspawnNotes.length')
            }
            pendingIndex = 0
            
            for i = 0, getProperty('opponentStrums.length')-1 do
			    setPropertyFromGroup('opponentStrums', i, 'texture', value1); -- Experimental, mas acho que deve funfar
		    end
            prevtexture = value1
        end
    end
end

function onUpdatePost(elapsed)
    if pendingTextureChange then
        local endIndex = math.min(pendingIndex + batchSize, pendingTextureChange.totalNotes)
        for i = pendingIndex, endIndex - 1 do
            if not getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
				setPropertyFromGroup('unspawnNotes', i, 'texture', pendingTextureChange.texture)
                if pendingTextureChange.splashTexture ~= '' then
                    setPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture', pendingTextureChange.splashTexture)
                end
            end
        end
        
        pendingIndex = endIndex
        

        -- Esse carinha apaga o conjunto de carregamento.
        if pendingIndex >= pendingTextureChange.totalNotes then
            pendingTextureChange = nil
        end
    end
end