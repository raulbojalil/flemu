const PORT = process.env.PORT || 5000;

const express = require('express');
const app = express();
const fs = require('fs');
const cors = require('cors');
const path = require('path');
const client = require('https');

app.use(express.static(__dirname + '/public'));
app.use(express.json());
app.use(cors());

let _gameDb = {};
let _gameFolders = {};

fs.readFile('./game_db.json', 'utf8', (err, data) => {
  _gameDb = JSON.parse(data);
});

fs.readFile('./game_paths.json', 'utf8', (err, data) => {
  _gameFolders = JSON.parse(data);
});

const getGameIdFromName = (system, name) => {

  const nameToLowerCase = name.toLowerCase().replace(", the", "");
  const games = _gameDb[system].sort((a,b) => b.name.length - a.name.length);

  for(var i=0; i < games.length; i++) {

    if(nameToLowerCase.includes(games[i].name.toLowerCase())) {
      const gameId = games[i].id;
      console.log(`Found game id: ${gameId}: ${games[i].name}`);
      return gameId;
    }
  }

  return undefined;
}

app.get('/filemanager/systems', (req, res) => {
  fs.readFile('./systems.json', 'utf8', (err, data) => {
     res.json(JSON.parse(data));
  });
});

app.get('/filemanager/image', (req, res) => {

  const system = req.query.system;
  const fallbackImage = __dirname + '/notfound.jpg';

  const cachedImagesFolder = __dirname + '/images/' + system;
  const cachedFilename = path.join(cachedImagesFolder, req.query.name + '.jpg');

  if(!fs.existsSync(cachedImagesFolder)) {
    fs.mkdirSync(cachedImagesFolder);
  }

  if (fs.existsSync(cachedFilename)) {
    res.sendFile(cachedFilename);
    return;
  }

  const gameId = getGameIdFromName(system, req.query.name);

  if(!gameId) {
    res.sendFile(fallbackImage);
    return;
  }

  const imageUrl = `https://www.screenscraper.fr/image.php?gameid=${gameId}&media=box-2D&hd=0&region=us&num=&version=&maxwidth=500`;

  client.get(imageUrl, (imageRes) => {
    console.log(`Writing to ${cachedFilename}...`);
    imageRes.pipe(fs.createWriteStream(cachedFilename))
      .on('error', () => res.sendFile(fallbackImage))
      .once('close', () => res.sendFile(cachedFilename));
  });
 
});

app.get('/filemanager/download', (req, res) => {
  const folder = _gameFolders[req.query.folder];  
  res.sendFile(path.join(folder, req.query.filename));
});

app.get('/filemanager/list', (req, res) => {
  const folder = _gameFolders[req.query.folder];
  const files = fs.readdirSync(folder);

  res.json(files);

});

app.listen(PORT, () => {
    console.log(`App listening at http://localhost:${PORT}`)
})

