Leap = require 'leapjs'
LeapLearner = require '../rx'
NeuralNetwork = require '../modules/neural-network'

data_no = require '../../data/nosense-1.json'
data_right = require '../../data/right.json'
data_two_1 = require '../../data/two-1.json'
data_two_2 = require '../../data/two-2.json'
data_two_3 = require '../../data/two-3.json'
data_tap = require '../../data/tap.json'
data_left = require '../../data/left.json'


net = NeuralNetwork {}

source = LeapLearner.createRxDataStreams net
learner = LeapLearner.createRxLearnerStreams net

inputsNoSense = source.createRxData LeapLearner.createRxFrameFromJson data_no
inputsRight = source.createRxData LeapLearner.createRxFrameFromJson data_right
inputsTwo1 = source.createRxData LeapLearner.createRxFrameFromJson data_two_1
inputsTwo2 = source.createRxData LeapLearner.createRxFrameFromJson data_two_2
inputsTwo3 = source.createRxData LeapLearner.createRxFrameFromJson data_two_3
inputsTap = source.createRxData LeapLearner.createRxFrameFromJson data_tap
inputsLeft = source.createRxData LeapLearner.createRxFrameFromJson data_left

sourceNoSense = learner.createRxLearnSource inputsNoSense
sourceRight = learner.createRxLearnSource inputsRight, 'right'
sourceTwo1 = learner.createRxLearnSource  inputsTwo1, 'two'
sourceTwo2 = learner.createRxLearnSource inputsTwo2, 'two'
sourceTwo3 = learner.createRxLearnSource inputsTwo3, 'two'
sourceTap = learner.createRxLearnSource inputsTap, 'tap'
sourceLeft = learner.createRxLearnSource inputsLeft, 'left'

netStream = learner.createRxLearn [sourceNoSense, sourceRight, sourceTwo3, sourceTap, sourceLeft]

netStream.subscribe()