Rx = require 'rxjs/Rx'
_ = require 'lodash'
{ parseFrameToRecordableRaw, ANN } = require '../parsers'
{ isGroup, isGesture, parseGestureToMatrix, preProcessGesture, Net } = ANN()

# Listen from leapjs loop
createRxLoopFromLeap = (fn) ->
    Rx.Observable.create (observer) ->
        fn (frame) -> observer.next frame

# Extract Useful data from frame
createRxFrameFromLoop = (stream) ->
    stream.map parseFrameToRecordableRaw

# Get Frames from Leapjs
createRxFrameFromLeap = (fn) -> createRxFrameFromLoop createRxLoopFromLeap fn

# Get Frames from records
createRxFrameFromJson = (data) ->
    Rx.Observable.from data

# Extract some Gesture from frames
createRxGestureFrameFromFrames = (stream) ->
    buffer = []
    Rx.Observable.create (observer) ->
        next = (frame) ->
            if isGroup buffer, frame.hands
                buffer.push frame.hands
            else if isGesture buffer
                observer.next preProcessGesture buffer
                buffer = []
        complete = ->
            observer.next preProcessGesture buffer if isGesture buffer
            observer.complete()
        error = (err) -> observer.error(err)
        stream.subscribe next, error, complete

# transform this Gesture to matrix for parsing
createRxTransformFromGesture = (stream) ->
    stream.map parseGestureToMatrix

# --------------------

createRxRecognitionFromTransform = (stream) ->
    stream.subscribe (matrix) ->
        console.log recognize matrix

createRxResultFromFrames = (stream) -> createRxRecognitionFromTransform createRxTransformFromGesture createRxGestureFrameFromFrames stream


createRxLearnSourceFromFrames = (stream, name) -> 
    source = createRxTransformFromGesture createRxGestureFrameFromFrames stream
    source.map (matrix) -> createLearnParams matrix, name

createRxLearnFromSources = (streams) ->
    source = Rx.Observable.merge streams...
    source.toArray().map (data) -> learn data

# ---------------

createLearnParams = (input, name) ->
    console.log name
    param = 
        input: input
        output: {}
    param.output[name] = 1.0 if name
    return param

class LeapNet
    _net: new Net
    _leapFormat: (data) =>
        input: @_leapFormatMatrix data.input
        output: data.output
    
    _leapFormatMatrix: (matrix) ->
        _.zipWith matrix, @_leapMinMatrix, @_leapSubMatrix, (v, min, sub) -> (v - min) / sub

    train: (data) ->
        matrixes = _.map data, 'input'
        @_leapMaxMatrix = _.unzipWith matrixes, _.rest _.max
        @_leapMinMatrix = _.unzipWith matrixes, _.rest _.min
        @_leapSubMatrix = _.zipWith @_leapMaxMatrix, @_leapMinMatrix, _.subtract
        @_net.train data.map @_leapFormat

    run: (data) ->
        @_net.run @_leapFormatMatrix data

net = new LeapNet

learn = (data) -> 
    net = new LeapNet
    net.train data
    return net

recognize = (data) ->
    net.run data

module.exports = { createRxFrameFromLeap, createRxFrameFromJson, createRxResultFromFrames, createRxLearnSourceFromFrames, createRxLearnFromSources }