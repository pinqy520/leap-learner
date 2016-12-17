parseFrameToRecordableRaw = (frame) ->
    hands                   : (parseHandToRaw hand for hand in frame.hands)
    timestamp               : frame.timestamp
    id                      : frame.id
    currentFrameRate        : frame.currentFrameRate
    data                    : frame.data
    historyIdx              : frame.historyIdx
    type                    : frame.type

parseHandToRaw = (hand) ->
    fingers                 : (parseFingerToRaw finger for finger in hand.fingers)
    direction               : hand.direction
    grabStrength            : hand.grabStrength
    id                      : hand.id
    palmNormal              : hand.palmNormal
    palmPosition            : hand.palmPosition
    palmVelocity            : hand.palmVelocity
    sphereCenter            : hand.sphereCenter
    sphereRadius            : hand.sphereRadius
    stabilizedPalmPosition  : hand.stabilizedPalmPosition
    type                    : hand.type

parseFingerToRaw = (finger) ->
    carpPosition            : finger.carpPosition
    dipPosition             : finger.dipPosition
    direction               : finger.direction
    handId                  : finger.handId
    id                      : finger.id
    length                  : finger.length
    mcpPosition             : finger.mcpPosition
    pipPosition             : finger.pipPosition
    positions               : finger.positions
    stabilizedTipPosition   : finger.stabilizedTipPosition
    timeVisible             : finger.timeVisible
    tipPosition             : finger.tipPosition
    tipVelocity             : finger.tipVelocity
    touchDistance           : finger.touchDistance
    width                   : finger.width
    type                    : finger.type

module.exports = { parseFrameToRecordableRaw }