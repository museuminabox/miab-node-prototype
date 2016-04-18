# Museum in a Box, node prototype

This is a bunch of very scrappy code while I feel my way around the edges of what node can do on a PI.

The main aims are to...

1. Play sound.
2. Read RFID tags.
3. Write RFID tags.
4. ...
5. Profit?

One the 1st three are done, then I'll try tying them all together to close the loop.

## Development Install instructions

1. Make sure `npm`, `coffee` and `nodemon` are all installed
1. Grab the code: `git clone https://github.com/museuminabox/miab-node-prototype.git`
1. `cd miab-node-prototype`
1. `npm install` to install all the packages
1. In one terminal window type `coffee start.coffee` this will kick off coffee (and later compass) to watch for code updates
1. In a second terminal window type `env $(cat ./profile) nodemon server.js` which will make `nodemon` run and monitor the actual code

## Pi Install instructions (good luck)

- Install the latest version of Raspbian onto the PI, I used [NOOBS](https://www.raspberrypi.org/downloads/noobs/)
- Remove all traces of old node, and install the latest version...
```Shell
sudo apt-get remove nodered
sudo apt-get remove nodejs nodejs-legacy
sudo apt-get remove npm
sudo apt-get autoremove
sudo apt-get clean
sudo apt-get autoclean
sudo apt-get update
sudo apt-get upgrade
curl -sL https://deb.nodesource.com/setup_4.x | sudo bash -
sudo apt-get install nodejs
```
- Now we need to install the files needed to run miab-node-prototype...
```Shell
sudo apt-get install ruby-full
sudo apt-get install libasound2-dev
sudo npm install -g coffee-script
sudo gem update --system
sudo gem install compass
mkdir Projects
cd Projects
git clone https://github.com/museuminabox/miab-node-prototype.git
cd miab-node-prototype
npm install
coffee -c ./
compass compile app/public
amixer cset numid=3 1
env $(cat ./profile) node server.js
```

From them on run `git pull`, `npm install` then `coffee -c ./` and `compass compile app/public` to snag the latest files and create the javascript & css whenever there's an update. Followed by `env $(cat ./profile) node server.js` to once again run it.

The trick is obviously to get it to run and keep running at startup, probably using `forever` or `pm2`

### Testing/running

Once the code is running, with `env $(cat ./profile) node server.js` you can visit the homepage running on port `8000`. There is nothing there apart from a "chat box" into which messages will appear.

You can view a "fake RFID" reader UI at `*:8000/fake-rfid` this will give you 12 virtual "tags" to play with, moving them over the larger white "reader" will send tag detected and lost messages to the brain's backend end-points. These are the same ones called by the hardware.

The two api endpoints are...

```
*:8000/api/miab.tag.detected?id=12345abcdef
*:8000/api/miab.tag.lost
```

These endpoints are used to tell the app that a tag has been detected and when it's lost.

All the urls are...

```
*:8000/
*:8000/fake-rfid
*:8000/api/miab.tag.detected?id=12345abcdef
*:8000/api/miab.tag.lost
```
