# Epicbot

[![Build
Status](https://travis-ci.org/drewolson/epicbot.svg?branch=master)](https://travis-ci.org/drewolson/epicbot)

Epicbot is a slack bot written in [PureScript](http://www.purescript.org/). It
allows you to search for cards from the [Epic Card
Game](https://www.epiccardgame.com/) and display the results in your slack
channel.

To search for a card, simply type some or all of its name. Epicbot will perform
a full text search to find the correct card.

```text
/epic <search term>
```

You can also generate an example random dark draft draw using the `draft`
command.

```text
/epic draft
```

## Deploying

### Install Tool Chain

```bash
npm install -g purescript spago
```

### Install Dependencies

```bash
spago install
npm install .
```

### Create a Self-Contained JavaScript Bundle

```bash
npm run bundle
```

Running this command results in the file `dist/bundle/index.js` being created.
It includes all dependencies required for running the slack bot and can be run
directly with `node`. When running it in production, you'll want to provide two
environment variables. One tells `epicbot` to pull fresh card information from
the Epic website and one provides the slack bot your slack signing
secret.

```bash
ONLINE=1 SLACK_SIGNING_SECRET=<your slack signing secret> node dist/bundle/index.js
```

Once you have your bot running, you'll want to follow the guide for creating a
[slash command](https://api.slack.com/interactivity/slash-commands) to use the
bot. We recommend using `/epic` as your slash command.

## Contributing

### Test

```bash
spago test
```

### Run

```bash
spago run
```
