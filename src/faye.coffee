Faye = require 'faye'

token  = process.env.TOKEN
roomId = process.env.ROOM_ID

class ClientAuthExt
    outgoing: (message, cb) ->
        if message.channel == '/meta/handshake'
            message.ext ?= {}
            message.ext.token = token
        cb message

    incoming: (message, cb) ->
        if message.channel == '/meta/handshake'
            if message.successful
                console.log 'Successful subscribed to room:', roomId
            else
                console.log 'Something went wrong: ', message.error
        cb message

class SnapshotExt
    incoming: (message, cb) ->
        if message.channel == '/meta/subscribe' && message.ext && message.ext.snapshot
            console.log 'Snapshot: ', message.ext.snapshot
        cb(message)

options =
    timeout : 60
    retry   : 5
    interval: 1
client = new Faye.Client 'https://ws.gitter.im/faye', options
client.addExtension(new ClientAuthExt)

module.exports = client;