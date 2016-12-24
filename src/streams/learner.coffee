Rx = require 'rxjs/Rx'


create = (learner) ->
    createRxRecognition = (stream) ->
        stream.map (matrix) -> learner.recognize matrix

    createRxLearnSource = (stream, name) -> 
        stream.map (matrix) -> learner.createLearnParams matrix, name

    createRxLearn = (streams) ->
        source = Rx.Observable.merge streams...
        source.toArray().map (data) -> learner.learn data

    { createRxRecognition, createRxLearn, createRxLearnSource }

module.exports = create
module.exports.default = create