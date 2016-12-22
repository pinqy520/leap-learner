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
