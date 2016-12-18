Leap = require 'leapjs'
fs = require 'fs'

{ parseFrameToRecordableRaw } = require './parsers'

interval = 5000

recording = false

frames = []

onFrame = (frame) ->
    frames.push parseFrameToRecordableRaw frame if recording

start = ->
    console.log 'start'
    frames = []
    recording = true
    setTimeout stop, interval

stop = ->
    console.log 'stop'
    recording = false
    write JSON.stringify frames, null, 2
    console.log 'done'

write = (str) ->
    fs.writeFileSync "data/#{Date.now()}.json", str

Leap.loop onFrame

setTimeout start, 1000

