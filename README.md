# Epicbot

![Build
Status](https://github.com/drewolson/epicbot/actions/workflows/test.yml/badge.svg?branch=master)


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

```text
npm install -g purescript spago
```

### Install Dependencies

```text
spago install
npm install .
```

### Create a Self-Contained JavaScript Bundle

```text
npm run bundle
```

Running this command results in the file `dist/bundle/index.js` being created.
It includes all dependencies required for running the slack bot and can be run
directly with `node`. You'll need to provide your Slack signing secret as an
environment variable.

```bash
SLACK_SIGNING_SECRET=<your slack signing secret> node dist/bundle/index.js
```

Once you have your bot running, you'll want to follow the guide for creating a
[slash command](https://api.slack.com/interactivity/slash-commands) to use the
bot. We recommend using `/epic` as your slash command.

## Contributing

### Install Tool Chain

```text
npm install -g purescript spago
npm install .
```

### Test

```text
spago test
```

### Run

```text
spago run
```

### Format

```text
npm run format:check
```

```text
npm run format
```

### Lint

```text
npm run lint
```
