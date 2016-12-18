{ parseFrameToRecordableRaw } = require './parseFrameToRecordableRaw'

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

isGesture = (buffer) -> buffer.length > 10

module.exports = { parseFrameToRecordableRaw, isGroup, isGesture  }