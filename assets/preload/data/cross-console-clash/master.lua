function onCreate()

    if legendas then
        pushScriptData("Adicionar Imagens diferenciado")
    end
    if storyDifficulty == 4 then 
        precacheImage('pixelUI/flower-clash');
        precacheImage('pixelUI/shroom-clash');
        precacheSound('Damage');
        precacheSound('power_down');
        precacheSound('powerup');
    else
        precacheSound('ring_loss');
        precacheSound('Ring');
        precacheImage('pixelUI/ring-clash');
    end

    close()

end