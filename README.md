## What?
A simple Hubot adapter for gitter.im

## How?

* Go to `developer.gitter.im` , login and get your own **Personal Access** token (not your app token).
* Install hubot with `npm install -g hubot coffeescript`
* Create your own bot `hubot --create mybot`
* Go to `mybot` folder and `npm install` to install dependencies
* Add `hubot-gitter` as dependency by using `npm install --save hubot-gitter`
* Start the bot `TOKEN=<your token> ROOM_ID=<the room you want to join> ./bin/hubot -a gitter`

## Notes

* `ROOM_ID` could be "GitHub Org, a GitHub Repo or a Gitter Channel". For examples,
`ROOM_ID=kcjpop` or `ROOM_ID=kcjpop/hubot-gitter`.
See [https://developer.gitter.im/docs/rooms-resource](https://developer.gitter.im/docs/rooms-resource)

* Default name is `Hubot`, so if you want to have another name, use `TOKEN=<your token> ROOM_ID=<the room you want to join> ./bin/hubot --name yourname -a gitter`