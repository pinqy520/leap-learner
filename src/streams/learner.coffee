Rx = require 'rxjs/Rx'


create = (learner) ->
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

module.exports = create
module.exports.default = create