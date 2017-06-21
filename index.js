try {
  var { Adapter, TextMessage } = require('hubot')
} catch (e) {
  const prequire = require('parent-require')
  var { Adapter, TextMessage } = prequire('hubot')
}
const GitterClient = require('node-gitter')

class Gitter extends Adapter {
	constructor(robot) {
    super(robot)
    this.robot.logger.info('Gitter adapter started')
    this.user = null
	}

  run () {
    const token = process.env.TOKEN
    const roomName = process.env.ROOM

    this.client = new GitterClient(token)

    this.client.currentUser()
      .then(user => (this.user = user))
      .then(_ => this.join(roomName))
      .catch(this.robot.logger.error)

    this.emit('connected')
  }

  join(roomName) {
    this.client.rooms.join(roomName)
      .then(room => {
        this.robot.logger.info(`Joined ${room.name}`)

        // Listen to room message
        const events = room.streaming().chatMessages()
        events.on('chatMessages', ({ model }) => {
          // Do not process messages sent by bot
          if (model.fromUser == null || model.fromUser.id === this.user.id) return

          model.fromUser.room = room
          const message = new TextMessage(model.fromUser, model.text, model.id)
          this.receive(message)
        })

        room.send(this.robot.name + ' connected ' + new Date())
      })
  }

  send ({ room }, ...messages) {
    messages.forEach(room.send, room)
  }
}


exports.use = robot => new Gitter(robot)
