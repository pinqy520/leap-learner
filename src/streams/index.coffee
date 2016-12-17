Rx = require 'rxjs/Rx'
{ parseFrameToRecordableRaw, sameHands, isAct } = require '../parsers'

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
        stream.subscribe (frame) ->
            act = isAct frame.hands
            if buffer.length > 0 and ((not sameHands buffer[0], frame.hands) or not act)
                observer.next buffer
                buffer = []
            else if frame.hands.length > 0 and act
                buffer.push frame.hands

createRxRecognitionFromGesture = (stream) ->
    stream

createRxResultFromFrames = (stream) -> createRxRecognitionFromGesture createRxGestureFrameFromFrames stream


module.exports = { createRxFrameFromLeap, createRxFrameFromJson, createRxResultFromFrames }