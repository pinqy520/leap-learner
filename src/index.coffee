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
data_1 = require '../data/nosense-1.json'
data_2 = require '../data/nosense-2.json'
data_right = require '../data/right.json'

{ createRxFrameFromLeap, createRxFrameFromJson, createRxResultFromFrames, createRxLearnSourceFromFrames, createRxLearnFromSources } = require './streams'

leapIn = createRxFrameFromLeap (fn) -> Leap.loop fn


inputsNoSense1 = createRxFrameFromJson data_1
inputsNoSense2 = createRxFrameFromJson data_2
inputsRight = createRxFrameFromJson data_right

sourceNoSense1 = createRxLearnSourceFromFrames inputsNoSense1
sourceNoSense2 = createRxLearnSourceFromFrames inputsNoSense2
sourceRight = createRxLearnSourceFromFrames inputsRight, 'right'

netStream = createRxLearnFromSources [sourceNoSense1, sourceNoSense2, sourceRight]

netStream.subscribe (net) ->
    console.log net

createRxResultFromFrames leapIn
