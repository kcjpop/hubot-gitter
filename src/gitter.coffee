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
        @faye.subscribe '/api/v1/rooms/'+roomId+'/chatMessages', handler, {}

    joinRoom: ->
        @opt.url = host+'/rooms'
        payload =
            uri: roomId
        
        r = request.post @opt, (err, res, body) ->
            console.log err if err
            console.log 'Joined room '+roomId
        r.form payload

    send: (content) ->
        @opt.url = host+'/rooms/'+roomId+'/chatMessages'
        payload =
            text: content
        
        r = request.post @opt, @cb
        r.form payload

module.exports = GitterIm