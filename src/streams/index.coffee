Rx = require 'rxjs/Rx'
{ parseFrameToRecordableRaw } = require '../parsers'

createRxLoopFromLeap = (fn) ->
    Rx.Observable.create (observer) -> 
        fn (frame) -> observer.next frame

createRxFrameFromLoop = (stream) ->
    stream.map parseFrameToRecordableRaw

createRxFrameFromJson = (data) ->
    Rx.Observable.from data

createRxActiveFramesFromFrames = (stream) ->
    buffer = []
    Rx.Observable.create (observer) ->
        stream.subscribe (frame) ->
            if frame.hands.length > 0
                buffer.push frame
            else 
                observer.next(buffer) if buffer.length > 0
                buffer = []
                
createRxHandsFromActiveFrames = (stream) ->
    stream

createRxGestureFromHands = (stream) ->
    stream

createRxRecognitionFromGesture = (stream) ->
    stream

createRxResultFromFrames = (stream) -> createRxRecognitionFromGesture createRxGestureFromHands createRxHandsFromActiveFrames createRxActiveFramesFromFrames stream


module.exports = { createRxLoopFromLeap, createRxFrameFromLoop, createRxFrameFromJson, createRxResultFromFrames }