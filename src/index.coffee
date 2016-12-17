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

{ createRxFrameFromLeap, createRxResultFromFrames } = require './streams'

frames = createRxFrameFromLeap (fn) -> Leap.loop(fn)
stream = createRxResultFromFrames frames

stream.subscribe (item) ->
    console.log item