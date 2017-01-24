brain = require 'brain.js'
_ = require 'lodash'

createLearnParams = (input, name) ->
    console.log name # , input
    param =
        input: input
        output: {}
    param.output[name] = 1.0 if name
    return param

absVelocity = (v) -> Math.max (Math.abs v[0]), (Math.abs v[1]), (Math.abs v[2])

parseGestureToMatrix = (frames) ->
    matrix = []
    for hands in frames
        for hand in hands
            matrix.push hand.palmPosition...
            matrix.push hand.palmVelocity...
            for finger in hand.fingers
                matrix.push finger.tipPosition...
                matrix.push finger.tipVelocity...
    matrix

same = (h1, h2) ->
    if h1 and h2 and h1.length > 0
        if h1.length is h2.length
            count = h1.length - 1
            for i in [0..count]
                if h1[i].id is not h2[i].id
                    return false
            return true
    return false

create = (opt = {}) ->
    _opt =
        minVelocity: 20
        frameCount: 5

    _.assign _opt, opt

    _frameIntervalCount = _opt.frameCount + 1
    _gestureFrameCount = _frameIntervalCount * 2

    _net = new brain.NeuralNetwork

    _maxMatrix = []
    _minMatrix = []
    _subMatrix = []

    _formatInput = (data) ->
        input: _formatMatrix data.input
        output: data.output

    _formatMatrix = (matrix) ->
        _.zipWith matrix, _minMatrix, _subMatrix, (v, min, sub) -> (v - min) / sub

    _train = (data) ->
        # console.log 'train', data
        matrixes = _.map data, 'input'
        _maxMatrix = _.unzipWith matrixes, _.rest _.max
        _minMatrix = _.unzipWith matrixes, _.rest _.min
        _subMatrix = _.zipWith _maxMatrix, _minMatrix, _.subtract
        _net.train data.map _formatInput

    _run = (data) -> _net.run _formatMatrix data


    learn = (data) -> _train data
    recognize = (data) ->
        result = _run data
        collection = _.map (_.keys result), (key) -> { key, value: result[key] }
        maxOne = _.maxBy collection, 'value'
        if maxOne.value > 0.5 then "#{maxOne.key} (#{(maxOne.value * 100).toFixed(2)}%)" else 'nosense'


    _isAct = (hands) ->
        if hands.length > 0
            for hand in hands
                if _opt.minVelocity < absVelocity hand.palmVelocity
                    return true
                for finger in hand.fingers
                    if _opt.minVelocity < absVelocity finger.tipVelocity
                        return true
        return false

    isGroup = (group, hands) -> hands.length > 0 and ((group.length is 0) or (((_isAct group[0]) or (_isAct hands)) and (same group[0], hands)))
    isGesture = (buffer) -> _gestureFrameCount < buffer.length
    _formatGesture = (frames) ->
        # console.log 'transform', frames
        count = 0
        inc = frames.length / _frameIntervalCount
        limit = frames.length - inc - 1
        while count < limit
            count += inc
            frames[Math.floor count]
    transform = (frames) -> parseGestureToMatrix _formatGesture frames

    { learn, recognize, isGroup, isGesture, transform, createLearnParams }



module.exports = create
module.exports.default = create
