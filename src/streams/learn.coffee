
createLearnStream = (learner) ->
    createRxRecognitionFromTransform = (stream) ->
        stream.subscribe (matrix) ->
            console.log learner.recognize matrix

    createRxLearnSourceFromFrames = (stream, name) -> 
        stream.map (matrix) -> learner.createLearnParams matrix, name

    createRxLearnFromSources = (streams) ->
        source = Rx.Observable.merge streams...
        source.toArray().map (data) -> learner.learn data