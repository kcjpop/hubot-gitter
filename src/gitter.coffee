request      = require 'request'
EventEmitter = require('events').EventEmitter

host   = process.env.HOST || 'https://api.gitter.im/v1';
token  = process.env.TOKEN;
roomId = process.env.ROOM_ID

if not token or not roomId
    console.log 'Please provide TOKEN and ROOM_ID as env var'
    process.exit 1

class GitterIm extends EventEmitter
    constructor: ->
        @opt =
            headers:
                'Accept': 'application/json'
                'Authorization': 'Bearer '+token
    
    cb: (err, res, body) ->
        console.log err if err

    setFaye: (faye, handler) ->
        @faye = faye
        @faye.subscribe '/api/v1/rooms/'+@roomId+'/chatMessages', handler, {}

    joinRoom: ->
        self = @
        @opt.url = host+'/rooms'
        payload =
            uri: roomId
        
        r = request.post @opt, (err, res, body) ->
            console.log err if err

            body = JSON.parse body
            unless body.allowed
                console.log 'You do not have permission to join '+roomId 
                process.exit 1

            room = body.room
            # Save room ID for later use
            self.roomId = room.id
            console.log 'Welcome to room: '+room.name

            self.emit 'room:connected', room
        r.form payload

    send: (content) ->
        @opt.url = host+'/rooms/'+@roomId+'/chatMessages'
        payload =
            text: content
        
        r = request.post @opt, @cb
        r.form payload

module.exports = GitterIm