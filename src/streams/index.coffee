Rx = require 'rxjs/Rx'
{ parseFrameToRecordableRaw, isGroup, isGesture } = require '../parsers'

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
            if isGroup buffer, frame.hands
                buffer.push frame.hands
            else if isGesture buffer
                observer.next buffer
                buffer = []

createRxRecognitionFromGesture = (stream) ->
    stream

createRxResultFromFrames = (stream) -> createRxRecognitionFromGesture createRxGestureFrameFromFrames stream


module.exports = { createRxFrameFromLeap, createRxFrameFromJson, createRxResultFromFrames }