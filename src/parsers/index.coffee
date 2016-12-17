{ parseFrameToRecordableRaw } = require './parseFrameToRecordableRaw'

sameHands = (h1, h2) ->
    if h1 and h2
        if h1.length is h2.length
            count = h1.length - 1
            for i in [0..count]
                if h1[i].id is not h2[i].id
                    return false
            return true
    return false

absVelocity = (v) -> Math.max (Math.abs v[0]), (Math.abs v[1]), (Math.abs v[2])

minVelocity = 20

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
    

module.exports = { parseFrameToRecordableRaw, sameHands, isAct }