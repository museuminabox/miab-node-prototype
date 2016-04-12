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
1. Grab the code: `git clone https://github.com/museuminabox/miab-node-prototype.git miab-node-prototype`
1. `cd miab-node-prototype`
1. `npm install` to install all the packages
1. In one terminal window type `coffee start.coffee` this will kick off coffee (and later compass) to watch for code updates
1. In a second terminal window type `env $(cat ./profile) nodemon server.js` which will make `nodemon` run and monitor the actual code

## Pi Install instructions (good luck)

These instructions are loooong, for the moment, until I pin down a problem with installing the `rfid-sl030` module. At some point these will become a nice clean install.

1. Install the latest version of raspbian
1. Make sure `apt-get` is updated, and remove the current version of node and npm, then build a slighly old but `rfid-sl030` compatible version of node.
```shell
sudo apt-get update
sudo apt-get upgrade
sudo apt-get -y remove nodejs-legacy nodejs-dev nodejs nodered npm
wget https://nodejs.org/dist/v0.10.40/node-v0.10.40.tar.gz
tar xvzf node-v0.10.40.tar.gz
cd node-v0.10.40
./configure
make
[go and make a cup of tea]
sudo make install
node -v
```

1. Uncomment out the line `#dtparam-i2c_arm=on` in '/boot/config.txt' (with sudo)
1. Reboot the pi
1. Optional, install i2c-tools to check i2c is working...
  1. `sudo apt-get install i2c-tools`
  1. Check is working with `sudo i2cdetect -y 1`
1. Install CoffeeScript `sudo npm install --save -g coffee-script`
1. Change to the directory where you want miab-node-prototype and go grab it...
1. `git clone https://github.com/museuminabox/miab-node-prototype.git`
1. `cd miab-node-prototype`
1. `git pull` just to be sure, do this to grab the latest builds
1. `sudo npm install` to install all the packages
1. `coffee -c ./` to generate the javascript files
1. `amixer cset numid=3 1` to set the audio output to the aux jack (code will automate this in future)
1. Start the server with `env $(cat ./profile) node server.js`

From them on run `git pull`, `sudo npm install` then `coffee -c ./` to snag the latest files and create the javascript

The trick is obviously to get it to run and keep running at startup, probably using `forever` or `pm2`

### NB

There is nothing there yet that actually does anything.
