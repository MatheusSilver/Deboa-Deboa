local prevtexture = ''
local pendingIndex = 0
local pendingTextureChange = nil	
local batchSize = 20 -- X02 ache um valor bom para esse coiso aqui

function onCreate()
    if (not getPropertyFromClass('PlayState', 'SONG.arrowSkin') == nil or not getPropertyFromClass('PlayState', 'SONG.arrowSkin') == '') then
        prevtexture = getPropertyFromClass('PlayState', 'SONG.arrowSkin')
    end
end

function onEvent(name, value1, value2)
    if name == 'noteskinchangeOPPT' then
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
        end
    end
end

function onUpdatePost(elapsed)
    if pendingTextureChange then
        local endIndex = math.min(pendingIndex + batchSize, pendingTextureChange.totalNotes)
        for i = pendingIndex, endIndex - 1 do
            if (getPropertyFromGroup('unspawnNotes', i, 'spawned')) then
                goto continue
            end
             if not getPropertyFromGroup('unspawnNotes', i, 'mustPress') and getPropertyFromGroup('unspawnNotes', i, 'texture') == prevtexture then
				setPropertyFromGroup('unspawnNotes', i, 'texture', pendingTextureChange.texture)
                if pendingTextureChange.splashTexture ~= '' then
                    setPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture', pendingTextureChange.splashTexture)
                end
            end
            ::continue::
        end
        
        pendingIndex = endIndex -1
        

        -- Esse carinha apaga o conjunto de carregamento.
        if pendingIndex >= pendingTextureChange.totalNotes-1 then
            prevtexture = pendingTextureChange.texture
            pendingTextureChange = nil
        end
    end
end