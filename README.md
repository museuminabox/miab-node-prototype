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
sudo npm install -g coffee-script
sudo apt-get install libasound2-dev
mkdir Projects
cd Projects
git clone https://github.com/museuminabox/miab-node-prototype.git
cd miab-node-prototype
npm install
coffee -c ./
amixer cset numid=3 1
env $(cat ./profile) node server.js
```

From them on run `git pull`, `npm install` then `coffee -c ./` to snag the latest files and create the javascript whenever there's an update. Followed by `env $(cat ./profile) node server.js` to once again run it.

The trick is obviously to get it to run and keep running at startup, probably using `forever` or `pm2`

### NB

There is nothing there yet that actually does anything.
