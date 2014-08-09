# Hubot dependencies
Client                 = require 'node-gitter'
{Adapter, TextMessage} = require 'hubot'

class Gitter extends Adapter
  # we need to save the known rooms to be able to find them by URI/name/...
  joinedRooms: null

  run: ->
    @joinedRooms = []
    @token = process.env.TOKEN
    @rooms = process.env.ROOM || process.env.ROOM_ID
    unless @token? and @rooms? and @token isnt '' and @rooms isnt ''
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
        .then((room) =>
          @robot.logger.debug 'Joined room: '+room.name
          @joinedRooms.push room unless room in @joinedRooms

          # Listen to room event
          events = room.streaming().chatMessages()
          events.on 'chatMessages', (evt) =>
            msg = evt.model

            # Attach room to TextMessage
            msg.fromUser.room = room
            obj = new TextMessage msg.fromUser, msg.text, msg.id
            @receive obj
            undefined

          # When the adapter wants to send message to this room
          @on 'gitter:send:'+room.id, (envelope, strings) ->
            strings.forEach (text) ->
              room.send text
            undefined
        )
        .fail((err) ->
          @robot.logger.debug 'Cannot join room: '+err
          console.log 'Cannot join room: '+err
        )

  send: (envelope, strings...) ->
    # Emit `send` to a specific room
    send = (roomId) =>
      @emit "gitter:send:#{ roomId }", envelope, strings
      yes
    # be sure we resolve the room object if a room name is given
    if typeof envelope.room is 'string' or envelope.room instanceof String
      if (room = @_roomForUri envelope.room)
        send room.id
      else
        @robot.logger.error "Cannot send message to unknown room #{ envelope.room }"
        no
    else
      send envelope.room.id


  _roomForUri: (uri) ->
    # find a joined room object by its URI
    for room in @joinedRooms when room.uri is uri
      return room

exports.use = (robot) ->
  new Gitter robot
