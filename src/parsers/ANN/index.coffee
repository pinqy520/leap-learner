brain = require 'brain.js'

ANN = ->
    isSameHands = (h1, h2) ->
        # console.log h1, h2
        if h1 and h2 and h1.length > 0
            if h1.length is h2.length
                count = h1.length - 1
                for i in [0..count]
                    if h1[i].id is not h2[i].id
                        return false
                return true
        return false

    absVelocity = (v) -> Math.max (Math.abs v[0]), (Math.abs v[1]), (Math.abs v[2])

    minVelocity = 20

    frameCount = 5

    frameIntervalCount = frameCount + 1

    gestureCount = frameIntervalCount * 2

    isAct = (hands) ->
        if hands.length > 0
            for hand in hands
                if minVelocity < absVelocity hand.palmVelocity
                    return true
                for finger in hand.fingers
                    if minVelocity < absVelocity finger.tipVelocity
                        return true
        # console.log false
        return false

    isGroup = (group, hands) -> hands.length > 0 and ((group.length is 0) or (((isAct group[0]) or (isAct hands)) and (isSameHands group[0], hands)))

    isGesture = (buffer) -> gestureCount < buffer.length

    preProcessGesture = (frames) -> 
        count = 0
        inc = frames.length / frameIntervalCount
        limit = frames.length - inc - 1
        while count < limit
            count += inc
            frames[Math.floor count]

    createNoSenseData = () -> []

    parseGestureToMatrix = (frames) ->
        matrix = []
        # console.log frames
        for hands in frames
            for hand in hands
                matrix.push hand.palmPosition...
                matrix.push hand.palmVelocity...
                for finger in hand.fingers
                    matrix.push finger.tipPosition...
                    matrix.push finger.tipVelocity...
        matrix

    Net = brain.NeuralNetwork

    { isGroup, isGesture, parseGestureToMatrix, preProcessGesture, Net }

module.exports = { ANN }