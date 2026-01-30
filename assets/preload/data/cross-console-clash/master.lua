function onCreate()

    addCharacterToList('luigi-ccc', 'gf')

    if difficulty == 4 then 
        precacheImage('pixelUI/flower-clash');
        precacheImage('pixelUI/shroom-clash');
        precacheSound('Damage');
        precacheSound('power_down');
        precacheSound('powerup');
        addCharacterToList('mario-ccc-small', 'bf')
        addCharacterToList('mario-ccc', 'bf')
        addCharacterToList('mario-fire', 'bf')
    else
        precacheSound('ring_loss');
        precacheSound('Ring');
        precacheImage('pixelUI/ring-clash');
    end

    stop()

end