{ createRxFrameFromLeap, createRxFrameFromJson } = require './streams/source'
createRxDataStreams = require './streams/data'
createRxLearnerStreams = require './streams/learner'

module.exports = { createRxFrameFromLeap, createRxFrameFromJson, createRxDataStreams, createRxLearnerStreams }