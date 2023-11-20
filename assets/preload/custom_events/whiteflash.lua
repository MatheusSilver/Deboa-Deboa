function onCreate()
  makeLuaSprite('whiteflash', 'empty', 0, 0)
  makeGraphic('whiteflash', 1, 1, 'FFFFFF')
  setGraphicSize("whiteflash", screenWidth, screenHeight)
  setObjectCamera("whiteflash", 'hud2')
  setProperty('whiteflash.alpha', 0)
  addLuaSprite("whiteflash")
end
function onEvent(name, value1, value2)
  if name == 'whiteflash' then
    setProperty('whiteflash.alpha', 1)
    doTweenAlpha('whiteflashbye', 'whiteflash', 0, 1, 'linear')
  end
end