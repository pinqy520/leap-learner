Rx = require 'rxjs/Rx'


createLearnStream = (learner) ->
    createRxRecognitionFromTransform = (stream) ->
        stream.map (matrix) -> learner.recognize matrix

    createRxLearnSourceFromData = (stream, name) -> 
        stream.map (matrix) -> learner.createLearnParams matrix, name

    createRxLearnFromSources = (streams) ->
        source = Rx.Observable.merge streams...
        source.toArray().map (data) -> learner.learn data
    
    createRxRecognition = (stream) -> createRxRecognitionFromTransform stream
    createRxLearn = (stream) -> createRxLearnFromSources createRxLearnSourceFromData stream

    { createRxRecognition, createRxLearn }

module.exports = createLearnStream
module.exports.default = createLearnStream