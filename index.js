try {
  var { Adapter, TextMessage } = require('hubot')
} catch (e) {
  const prequire = require('parent-require')
  var { Adapter, TextMessage } = prequire('hubot')
}
const GitterClient = require('node-gitter')

const DEBUGGING = process.env.HUBOT_LOG_LEVEL === 'debug'

class Gitter extends Adapter {
  constructor(robot) {
    super(robot)
    this.robot.logger.info('Gitter adapter started')
    this.user = null
    this.options = {}
  }

  run() {
    this.getOptions()

    this.client = new GitterClient(this.options.token)

    this.client
      .currentUser()
      .then(user => (this.user = user))
      .then(_ => Promise.all(this.options.rooms.map(this.join, this)))
      .catch(this.robot.logger.debug)

    this.emit('connected')
  }

  getOptions() {
    const token = process.env.TOKEN
    if (!token || token.length === 0) throw new Error('Missing value for process.env.TOKEN')

    const rooms = this.extractRooms(process.env.ROOM || '')
    if (rooms.length === 0) throw new Error('Missing values for process.env.ROOM')

    this.options = { token, rooms }
  }

  extractRooms(rooms) {
    return rooms.split(',').map(str => str.trim()).filter(str => str.length)
  }

  join(roomName) {
    return this.client.rooms.join(roomName).then(room => {
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

      DEBUGGING && room.send(`${this.robot.name} connected at ${new Date()}`)
    })
  }

  send({ room }, ...messages) {
    messages.forEach(room.send, room)
  }
}

exports.use = robot => new Gitter(robot)
