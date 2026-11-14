
local ofs = 40;
local followchars = true; -- Yaaaaaaaaaaaaaaaaaaaay meu primeiro script em lua
-- Que pena que ele só funciona na BSL Engine k (Não que eu me importe muito com isso, claro)


-- Sim... Esse é o camFollowGlobal mas com uma pequena sutileza, agora ele atualiza o tempo todo
-- Movimento de camera mais liso, sabe como é né?
-- O bixo fica voando pra cima e pra baixo o tempo todo té doido...

function onUpdate(elapsed)
    -- updateCamPos('all') -- Provavelmente isso deixaria essa parte um cadin lagada de mais.
    -- Provavelmente teremos que fazer uma modificação nesse script para o player com efeitos de camera desligados.
    if getCamMove() then    
        if mustHitSection == false then
            updateCamPos('dad')
            local anim = getProperty('dad.animation.curAnim.name')
            if anim == 'singLEFT' then
                triggerEvent('Camera Follow Pos',camPosDadX-ofs,camPosDadY)
            end
            if anim == 'singRIGHT' then
                triggerEvent('Camera Follow Pos',camPosDadX+ofs,camPosDadY)
            end
            if anim == 'singUP' then
                triggerEvent('Camera Follow Pos',camPosDadX,camPosDadY-ofs)
            end
            if anim == 'singDOWN' then
                triggerEvent('Camera Follow Pos',camPosDadX,camPosDadY+ofs)
            end
            if anim == 'idle' then
                triggerEvent('Camera Follow Pos',camPosDadX,camPosDadY)
            end
        else
            --updateCamPos('bf') -- Tenho minhas duvidas se o bf real vai precisar disso... Mas acho que não
            local anim = getProperty('boyfriend.animation.curAnim.name')
            if anim == 'singLEFT' then
                triggerEvent('Camera Follow Pos',camPosBFX-ofs,camPosBFY)
            end
            if anim == 'singRIGHT' then
                triggerEvent('Camera Follow Pos',camPosBFX+ofs,camPosBFY)
            end
            if anim == 'singUP' then
                triggerEvent('Camera Follow Pos',camPosBFX,camPosBFY-ofs)
            end
            if anim == 'singDOWN' then
                triggerEvent('Camera Follow Pos',camPosBFX,camPosBFY+ofs)
            end
	        if anim == 'idle' then
                triggerEvent('Camera Follow Pos',camPosBFX,camPosBFY)
            end 
        end
    end
end