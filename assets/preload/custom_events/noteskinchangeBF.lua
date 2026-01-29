-- Deveras agradecido Cláudio

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
            
            for i = 0, getProperty('playerStrums.length')-1 do
				setPropertyFromGroup('playerStrums', i, 'texture', value1); -- Experimental, mas acho que deve funfar
			end
            prevtexture = value1
        end
    end
end

function onUpdatePost(elapsed)
    if pendingTextureChange then
        local endIndex = math.min(pendingIndex + batchSize, pendingTextureChange.totalNotes)
        for i = pendingIndex, endIndex - 1 do
            -- Quando uma nota não tem tipo definido, ela é uma nota comum, ou seja, não é nota de dano ou outra coisa aleatória.
            if getPropertyFromGroup('unspawnNotes', i, 'mustPress') and getPropertyFromGroup('unspawnNotes', i, 'noteType') == nil then
				setPropertyFromGroup('unspawnNotes', i, 'texture', pendingTextureChange.texture)
                if pendingTextureChange.splashTexture ~= '' then
                    setPropertyFromGroup('unspawnNotes', i, 'noteSplashTexture', pendingTextureChange.splashTexture)
                end
            end
        end
        
        pendingIndex = endIndex -1
        
        if pendingIndex >= pendingTextureChange.totalNotes-1 then
            pendingTextureChange = nil
        end
    end
end