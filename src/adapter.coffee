# Hubot dependencies
Client                 = require 'node-gitter'
{Adapter, TextMessage} = require 'hubot'

class Gitter extends Adapter
  run: ->
    @token = process.env.TOKEN
    @rooms = process.env.ROOM || process.env.ROOM_ID
    unless @token? and @rooms?
      @robot.logger.debug 'Missing TOKEN and ROOM. Exiting...'
      err = 'You must give me your personal access TOKEN and a list of ROOM'
      console.log err
      process.exit 1

    # Create new Gitter client
    @createClient()

    # Remember to emit this event to make hubot working
    @emit 'connected'

  createClient: ->
    @robot.logger.debug 'Creating new Gitter client'
    @gitter = new Client @token

    # If we have multiple rooms to join
    @rooms.split(',').forEach (roomUri) =>
      unless roomUri.trim() is ''

        @robot.logger.debug 'Trying to join room '+roomUri
        @gitter.rooms.join(roomUri)
        .then (room) =>
          @robot.logger.debug 'Joined room: '+room.name

          # Listen to room event
          events = room.listen()
          events.on 'message', (msg) =>
            # Attach room to TextMessage
            msg.fromUser.room = room
            obj = new TextMessage msg.fromUser, msg.text, msg.id
            @receive obj

          # When the adapter wants to send message to this room
          @on 'gitter:send:'+room.id, (envelope, strings) ->
            strings.forEach (text) ->
              room.send text

        .fail (err) ->
          @robot.logger.debug 'Cannot join room: '+err
          console.log 'Cannot join room: '+err

  send: (envelope, strings...) ->
    # Emit `send` to a specific room
    @emit 'gitter:send:'+envelope.room.id, envelope, strings

exports.use = (robot) ->
  new Gitter robot
