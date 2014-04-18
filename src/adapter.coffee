# Hubot dependencies
Client                 = require 'node-gitter'
{Adapter, TextMessage} = require 'hubot'

class Gitter extends Adapter
  run: ->
    @token = process.env.TOKEN
    @rooms = process.env.ROOM || process.env.ROOM_ID
    unless @token? and @rooms?
      err = 'You must give me your personal access TOKEN and a list of ROOM'
      console.log err
      process.exit 1

    # Create new Gitter client
    @createClient()

    # Remember to emit this event to make hubot working
    @emit 'connected'

  createClient: ->
    @gitter = new Client @token

    @gitter.rooms.join(@rooms)
    .then (room) =>
      @robot.logger.debug 'Connected to room: '+room.name
      # Listen to room event
      events = room.listen()
      events.on 'message', @onMessage.bind @

      # When the adapter wants to send message to room
      @on 'send', (envelope, strings) ->
          strings.forEach (text) ->
              room.send text
    .fail (err) ->
      console.log 'Cannot join room: '+err
      process.exit 1

  send: (envelope, strings...) ->
    # Emit `send` for room
    @emit 'send', envelope, strings

  onMessage: (msg) ->
    obj = new TextMessage msg.fromUser, msg.text, msg.id
    @receive obj

exports.use = (robot) ->
  new Gitter robot
