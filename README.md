# Flemu

A responsive web frontend for [Emulator JS](https://github.com/ethanaobrien/emulatorjs) powered by Flutter, Node.js and Screenscraper.fr (for automatic downloading of game boxes). No database needed.

## Getting started

### How to build and run in development mode

* First of all, configure your game folders in flemu\backend\systems.json (use the path property). These paths should contain valid game files according to the specific system.

``
{
   ...
   "path": "C:\\Games\\SNES"
   ...
}
``

* Open a terminal and go to the `` flemu\backend `` directory. Run ``npm install``.
* After the packages are installed, run ``npm start`` to start the Node.js backend server.
* Run the Flutter app using Visual Studio Code in Web mode (use Chrome (web-javascript))

### How to create a release build

* Run the build.bat script
* Copy the `` build\web `` directory to your server (make sure Node.js is installed on your server)
* Configure your game folders in game_paths.json
* Start the server by running ``npm start`` (or use pm2/forever/nginx etc.)
* Set the PORT env variable to set to another port other than 5000

## Screenshots

![Flemu](https://github.com/raulbojalil/flemu/blob/master/screenshot.png?raw=true "demo")
