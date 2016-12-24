Rx = require 'rxjs/Rx'


create = (learner) ->
    # Extract some Gesture from frames
    createRxGestureFrameFromFrames = (stream) ->
        buffer = []
        Rx.Observable.create (observer) ->
            next = (frame) ->
                if learner.isGroup buffer, frame.hands
                    buffer.push frame.hands
                else if learner.isGesture buffer
                    # console.log 'buffer next', buffer
                    observer.next buffer
                    buffer = []
            complete = ->
                # console.log 'buffer complete', buffer
                observer.next buffer if learner.isGesture buffer
                observer.complete()
            error = (err) -> observer.error err
            stream.subscribe next, error, complete

    # transform this Gesture to matrix for parsing
    createRxTransformFromGesture = (stream) ->
        stream.map learner.transform

    createRxData = (stream) -> createRxTransformFromGesture createRxGestureFrameFromFrames stream

    { createRxData }

module.exports = create
module.exports.default = create