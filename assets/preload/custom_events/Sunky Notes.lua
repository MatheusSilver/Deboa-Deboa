function onEvent(name)
    if name == 'Sunky Notes' and not middlescroll then
        setPropertyFromGroup('opponentStrums', 0, 'x', defaultOpponentStrumX0 + 100)
        setPropertyFromGroup('opponentStrums', 1, 'x', defaultOpponentStrumX1 + 100)
        setPropertyFromGroup('opponentStrums', 2, 'x', defaultOpponentStrumX2 + 100)
        setPropertyFromGroup('opponentStrums', 3, 'x', defaultOpponentStrumX3 + 100)

        setPropertyFromGroup('playerStrums', 0, 'x', defaultPlayerStrumX0 - 100)
        setPropertyFromGroup('playerStrums', 1, 'x', defaultPlayerStrumX1 - 100)
        setPropertyFromGroup('playerStrums', 2, 'x', defaultPlayerStrumX2 - 100)
        setPropertyFromGroup('playerStrums', 3, 'x', defaultPlayerStrumX3 - 100)
    end
end