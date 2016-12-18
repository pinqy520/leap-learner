# Leap = require 'leapjs'
# brain = require 'brain.js'

# { createRecorder } = require './recorder'

# recorder = createRecorder()

# net = new brain.NeuralNetwork

# count = 1

# Leap.loop recorder.listener

# recorder.on 'start', (num) -> 
#     console.log 'start', num

# recorder.on 'stop', (num) ->
#     console.log 'stop', num

# recorder.on 'done', (num) ->
#     console.log 'done', num
#     if num < count
#         start()
#     else
#         train recorder.getResult()

# nonSense = ->
#     nosense = 
#         input: Math.random

# start = ->
#     setTimeout recorder.start, 1000

# train = (results) ->
#     console.log results


# start()


Leap = require 'leapjs'
# data_1 = require '../data/nosense-1.json'
data_2 = require '../data/nosense-1.json'
data_right = require '../data/right.json'
data_two_1 = require '../data/two-1.json'
data_two_2 = require '../data/two-2.json'
data_two_3 = require '../data/two-3.json'
data_tap = require '../data/tap.json'

{ createRxFrameFromLeap, createRxFrameFromJson, createRxResultFromFrames, createRxLearnSourceFromFrames, createRxLearnFromSources } = require './streams'

leapIn = createRxFrameFromLeap (fn) -> Leap.loop fn


# inputsNoSense1 = createRxFrameFromJson data_1
inputsNoSense2 = createRxFrameFromJson data_2
inputsRight = createRxFrameFromJson data_right
inputsTwo1 = createRxFrameFromJson data_two_1
inputsTwo2 = createRxFrameFromJson data_two_2
inputsTwo3 = createRxFrameFromJson data_two_3
inputsTap = createRxFrameFromJson data_tap

# sourceNoSense1 = createRxLearnSourceFromFrames inputsNoSense1
sourceNoSense2 = createRxLearnSourceFromFrames inputsNoSense2
sourceRight = createRxLearnSourceFromFrames inputsRight, 'right'
sourceTwo1 = createRxLearnSourceFromFrames inputsTwo1, 'two'
sourceTwo2 = createRxLearnSourceFromFrames inputsTwo2, 'two'
sourceTwo3 = createRxLearnSourceFromFrames inputsTwo3, 'two'
sourceTap = createRxLearnSourceFromFrames inputsTap, 'tap'

netStream = createRxLearnFromSources [sourceNoSense2, sourceRight, sourceTwo1, sourceTwo2, sourceTwo3, sourceTap]

netStream.subscribe()

createRxResultFromFrames leapIn
