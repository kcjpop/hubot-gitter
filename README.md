## What?
[![Gitter](https://img.shields.io/gitter/room/kcjpop/hubot-gitter.svg?style=flat-square)](https://gitter.im/kcjpop/hubot-gitter)
A simple Hubot adapter for gitter.im

## How?

* Go to [https://developer.gitter.im](https://developer.gitter.im), login and get your own **Personal Access Token** (NOT your app token).
* Follow [the instruction here](https://hubot.github.com/docs/) to create your bot.
* In your bot folder, run `npm i -S hubot-gitter`
* Start your bot using this command,
```bash
TOKEN=<your Gitter Personal Access Token> ROOM="org/room1,org2/room3" ./bin/hubot -a gitter
```
You can let your bot join multiple rooms, each separates by comma (,)

* (Optional) Edit your `package.json` and add this to `scripts`

```json
{
  "scripts": {
    "start": "./bin/hubot --name tien -a gitter"
  }
}
```
Then you can start your bot with `npm start`. This is useful for deployment with Zeit (see below).

## Deployment with Zeit

You can deploy your bot for free with [Zeit](https://zeit.co/docs). Assume that you are currently in your bot folder, the deploy command is:

```bash
now -e TOKEN=<your Gitter Personal Access Token> -e ROOM="org/room1,org2/room3" 
```

Zeit will automatically run `npm start`. Please note that **Your code and logs will be made public.** so be careful there.

It is possible that you would have multiple deployment with Zeit, resulting multiple instances of your bot joining the same rooms. To cure this, use `now ls` and `now rm` to delete old deployment.

## Changelog

**1.0.0**
- Upgrade after a long time
- BREAKING: `ROOM_ID` was removed. Use `ROOM` instead.

**0.0.2**
- Utilize module `node-gitter` to interact with Gitter API
- Allow bot to join multiple rooms
- Change `ROOM_ID` to `ROOM` for shorter param name. `ROOM_ID` is still usable.

**0.0.1**
- Initial release
