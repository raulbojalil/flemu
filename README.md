# Flemu

A responsive web frontend for [Emulator JS](https://github.com/ethanaobrien/emulatorjs) powered by Flutter and Screenscraper.fr (for automatic downloading of game boxes). No database needed.

## Getting Started

Flemu is still a work in progress and not ready for release yet. Follow the next steps to run the application in development mode:

* First of all, configure your game folders in flemu\backend\game_paths.json. These paths should contain valid game files according to the specific system

``
{
   "snes": "C:\\Games\\SNES"
   ...
}
``

* Start the Node.js backend server by going to `` flemu\backend ``  and running ``npm start``.
* Run the Flutter app using Visual Studio Code or any other IDE.

## Screenshots

![Flemu](https://github.com/raulbojalil/flemu/blob/master/screenshot.png?raw=true "demo")