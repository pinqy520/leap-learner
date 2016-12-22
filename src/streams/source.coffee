Rx = require 'rxjs/Rx'
{ parseFrameToRecordableRaw } = require '../utils/parseFrameToRecordableRaw'

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

module.exports = { createRxFrameFromLeap, createRxFrameFromJson }