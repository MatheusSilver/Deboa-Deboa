local nice = true --does funny stuff

function onStepHit()

if curStep == 3326 then
doTweenX('starvingManDie', 'dadGroup', -6000, 5, 'smootherStepInOut')
doTweenAlpha('woahNotesDEADagain', 'camHUD', 0, 0.1, 'smootherStepInOut')
end

if curStep == 3365 then
addAnimationByPrefix('reach', 'furnace', 'Furnace left', 24, true)
doTweenX('heAttak', 'furnace', getProperty('boyfriend.x'), 0.3, 'smootherStepInOut')
objectPlayAnimation('furnace', 'reach', true)
end
if curStep == 3375 then
doTweenX('reach', 'furnace', -9000, 0.3, 'smootherStepInOut')
end
end