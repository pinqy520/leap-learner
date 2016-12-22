createRxRecognitionFromTransform = (stream) ->
    stream.subscribe (matrix) ->
        console.log recognize matrix

createRxLearnSourceFromFrames = (stream, name) -> 
    source = createRxTransformFromGesture createRxGestureFrameFromFrames stream
    source.map (matrix) -> createLearnParams matrix, name

createRxLearnFromSources = (streams) ->
    source = Rx.Observable.merge streams...
    source.toArray().map (data) -> learn data