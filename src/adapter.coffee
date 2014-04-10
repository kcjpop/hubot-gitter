# Hubot dependencies
{Adapter, TextMessage} = require 'hubot'

GitterIm = require './gitter'
faye     = require './faye'

class Gitter extends Adapter
    run: ->
        self = @
        @gitter = new GitterIm
        @gitter.joinRoom()

        @gitter.on 'room:connected', () ->
            self.gitter.setFaye faye, self.handlr.bind self

        console.log self.robot.name+' now running...'
        @emit 'connected'

    send: (envelope, strings...) ->
        console.log 'Sending...'
        strings.forEach (text) =>
            @gitter.send text

    reply: (envelope, strings...) ->
        console.log 'Replying...'
        @send envelope, strings

    handlr: (obj) ->
        if obj.operation == 'create'
            msg = new TextMessage obj.model.fromUser, obj.model.text, obj.model.id
            @receive msg

exports.use = (robot) ->
    new Gitter robot
    