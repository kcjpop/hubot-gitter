## What?
A simple Hubot adapter for gitter.im

## How?

* Go to `developer.gitter.im` , login and get your own token.
* Install hubot with `npm install -g hubot coffeescript`
* Create your own bot `hubot --create mybot`
* Go to `mybot` folder and `npm install` to install dependencies
* Add `hubot-gitter` as dependency by using `npm install --save hubot-gitter`
* Start the bot `TOKEN=<your token> ROOM_ID=<the room you want to join> ./bin/hubot -a gitter`

## Notes

* Currently `ROOM_ID` must be a valid MongoDB ID, i.e, `5330777dc3599d1de448e194`
* Default name is `Hubot`, so if you want to have another name, use `TOKEN=<your token> ROOM_ID=<the room you want to join> ./bin/hubot --name yourname -a gitter`