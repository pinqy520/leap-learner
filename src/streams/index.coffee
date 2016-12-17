Rx = require 'rxjs/Rx'
{ parseFrameToRecordableRaw } = require '../parsers'

createRxLoopFromLeap = (fn) ->
    Rx.Observable.create (observer) -> 
        fn (frame) -> observer.next frame

createRxFrameFromLoop = (stream) ->
    stream.map parseFrameToRecordableRaw

createRxFrameFromFile = (path) ->
    path

createRxGestureFromFrames = (stream) ->
    stream.subscribe (frame) ->
        if frame.hands.length > 0
            console.log frame

createRxStreams = (fn) -> createRxGestureFromFrames createRxFrameFromLoop createRxLoopFromLeap fn

module.exports = { createRxLoopFromLeap, createRxFrameFromLoop, createRxFrameFromFile, createRxGestureFromFrames, createRxStreams }