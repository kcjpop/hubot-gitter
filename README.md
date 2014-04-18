## What?
A simple Hubot adapter for gitter.im

## How?

* Go to `developer.gitter.im` , login and get your own **Personal Access** token (not your app token).
* Install hubot with `npm install -g hubot coffeescript`
* Create your own bot `hubot --create mybot`
* Go to `mybot` folder and `npm install` to install dependencies
* Add `hubot-gitter` as dependency by using `npm install --save hubot-gitter`
* Start the bot `TOKEN=<your token> ROOM=<room URIs> ./bin/hubot -a gitter`

`ROOM` could be "GitHub Org, a GitHub Repo or a Gitter Channel" (see [https://developer.gitter.im/docs/rooms-resource](https://developer.gitter.im/docs/rooms-resource)) and comma-separated for multiple rooms, e.g.
`ROOM=kcjpop,kcjpop/hubot-gitter`.

## Notes

* Default name is `Hubot`. If you want to have another name, use `TOKEN=<your token> ROOM=<room URIs> ./bin/hubot --name yourname -a gitter`
* If you are deploying your bot on Heroku, follow the instruction [here](https://github.com/github/hubot/blob/master/docs/deploying/heroku.md). Do not forget to change startup command in `Procfile`. A useful service that helps to keep your bot alive is [http://unidler.herokuapp.com/](http://unidler.herokuapp.com/)

## Changelog

**0.0.2**

Utilize module `node-gitter` to interact with Gitter API

Allow bot to join multiple rooms

Change `ROOM_ID` to `ROOM` for shorter param name. `ROOM_ID` is still usable.


**0.0.1**

Initial release
