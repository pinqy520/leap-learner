Rx = require 'rxjs/Rx'
{ parseFrameToRecordableRaw, ANN } = require '../parsers'
{ isGroup, isGesture, parseGestureToMatrix, preProcessGesture, Net } = ANN()

createRxLoopFromLeap = (fn) ->
    Rx.Observable.create (observer) -> 
        fn (frame) -> observer.next frame

createRxFrameFromLoop = (stream) ->
    stream.map parseFrameToRecordableRaw

createRxFrameFromLeap = (fn) -> createRxFrameFromLoop createRxLoopFromLeap fn

createRxFrameFromJson = (data) ->
    Rx.Observable.from data

createRxGestureFrameFromFrames = (stream) ->
    buffer = []
    Rx.Observable.create (observer) ->
        next = (frame) ->
            if isGroup buffer, frame.hands
                # console.log frame.hands
                buffer.push frame.hands
            else if isGesture buffer
                observer.next preProcessGesture buffer
                buffer = []
        complete = -> observer.complete()
        error = (err) -> observer.error(err)
        stream.subscribe next, error, complete

createRxTransformFromGesture = (stream) ->
    stream.map parseGestureToMatrix

createRxRecognitionFromTransform = (stream) ->
    # stream
    stream.subscribe (matrix) ->
        console.log recognize matrix

createRxResultFromFrames = (stream) -> createRxRecognitionFromTransform createRxTransformFromGesture createRxGestureFrameFromFrames stream


createRxLearnSourceFromFrames = (stream, name) -> 
    source = createRxTransformFromGesture createRxGestureFrameFromFrames stream
    source.map (matrix) -> createLearnParams matrix, name

createRxLearnFromSources = (streams) ->
    source = Rx.Observable.merge streams...
    source.toArray().map (data) -> learn data

createLearnParams = (input, name) ->
    console.log name
    param = 
        input: input
        output: {}
    param.output[name] = 1.0 if name
    return param

net = new Net

learn = (data) -> 
    net = new Net
    net.train data
    return net

recognize = (data) ->
    net.run data

module.exports = { createRxFrameFromLeap, createRxFrameFromJson, createRxResultFromFrames, createRxLearnSourceFromFrames, createRxLearnFromSources }