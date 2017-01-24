Leap = require 'leapjs'
LeapLearner = require '../rx'
NeuralNetwork = require '../modules/neural-network'

keys = [
    # 'bad'
    #  'good'
     'left'
     'right'
     'ok'
    #   'no'
       'tap'
   ]

data = ({key, value: require "../../data/#{key}.json"} for key in keys)

net = NeuralNetwork {}

source = LeapLearner.createRxDataStreams net
learner = LeapLearner.createRxLearnerStreams net

createSourceFromData = (d) ->
    learner.createRxLearnSource (source.createRxData LeapLearner.createRxFrameFromJson d.value), d.key

sources = (createSourceFromData d for d in data)

netStream = learner.createRxLearn sources

netStream.subscribe()

recognize = learner.createRxRecognition source.createRxData LeapLearner.createRxFrameFromLeap (fn) -> Leap.loop fn
recognize.subscribe (result) -> console.log result
