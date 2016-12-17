createRecorder = ->
    configuration =
        interval: 2000 # ms
        count   : 5
        hands   : 1

    frames      = []
    results     = []
    recording   = false
    timer       =  0

    events = 
        recordDone  : []
        done        : []
        start       : []
        stop        : []
    
    listener = (frame) ->
        if frame.hands.length is configuration.hands and recording
            frames.push frame

    reset = ->
        frames = []
        results = []

    start = ->
        if not recording
            frames = []
            emitEvent 'start', [results.length]
            recording = true
            timer = setTimeout stop, configuration.interval
        else
            console.warn 'recording'
            
    stop = ->
        # console.log 'stop'
        console.log frames
        recording = false
        clearTimeout timer
        emitEvent 'stop', [results.length]
        parse frames

    emitEvent = (name, args) ->
        callbacks = events[name]
        cb(args...) for cb in callbacks if callbacks

    addEventListener = (name, cb) ->
        events[name].push cb if events[name] and cb not in events[name]
        
    removeEventListener = (name, cb) ->
        callbacks = events[name]
        if callbacks and cb in callbacks
            index = callbacks.indexOf cb
            events[name] = callbacks.splice index, 1

    getResult = -> results

    preprocess = (frames) -> 
        if frames.length > configuration.count + 1
            count = 0
            inc = (frames.length - 1) / configuration.count
            while count < frames.length - inc
                count += inc
                console.log  frames.length, count
                frames[Math.floor count]
        else frames

    parse = (frames) ->
        frameMatrixes = (parseToFrameMatrix frame for frame in preprocess frames)
        results.push [].concat frameMatrixes...
        # console.log frames.length, results
        emitEvent 'done', [results.length]
        
    parseToFrameMatrix = (frame) ->
        handMatrixes = (parseToHandMatrix hand for hand in frame.hands)
        [].concat handMatrixes...
        
    parseToHandMatrix = (hand) ->
        itemMatrixes = [
            parseToItemMatrix hand.palmPosition, hand.palmVelocity
            (parseToItemMatrix finger.tipPosition, finger.tipVelocity for finger in hand.fingers)...
        ]
        [].concat itemMatrixes...
    
    # createItem = (position, velocity) -> position: position, velocity: velocity

    parseToItemMatrix = (position, velocity) ->
        [
            position...
            velocity...
        ]
    
    recorder = 
        listener: listener
        reset: reset
        start: start
        stop: stop
        on: addEventListener
        off: removeEventListener
        getResult: getResult

    recorder

module.exports = 
    createRecorder: createRecorder
