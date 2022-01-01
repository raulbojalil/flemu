# Flemu

A responsive web frontend for [Emulator JS](https://github.com/ethanaobrien/emulatorjs) powered by Flutter and Screenscraper.fr (for automatic downloading of game boxes). No database needed.

## Getting started

### How to build and run in development mode

* First of all, configure your game folders in flemu\backend\game_paths.json. These paths should contain valid game files according to the specific system

``
{
   "snes": "C:\\Games\\SNES"
   ...
}
``

* Using the CLI, go to the `` flemu\backend `` directory and run ``npm install``
* Run ``npm start`` to start the Node.js backend server.
* Run the Flutter app using Visual Studio Code in Web mode (use Chrome (web-javascript))

### How to build for release

* Run the build.bat script
* Copy the `` build\web `` directory to your server
* Configure your game folders in game_paths.json
* Start the server by running ``npm start`` (or use pm2/forever/nginx etc.)

## Screenshots

![Flemu](https://github.com/raulbojalil/flemu/blob/master/screenshot.png?raw=true "demo")
