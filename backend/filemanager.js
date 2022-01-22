const fs = require('fs');
const path = require('path');

const screenscraper = require('./services/screenscraper');

let _gameDb = {};
let _gameFolders = {};
let _systems = {};

fs.readFile('./game_db.json', 'utf8', (err, data) => {
  _gameDb = JSON.parse(data);
});

fs.readFile('./game_paths.json', 'utf8', (err, data) => {
  _gameFolders = JSON.parse(data);
});

fs.readFile('./systems.json', 'utf8', (err, data) => {
  _systems = JSON.parse(data);
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

const getSystemPlatformId = (system) => {
  const systemData = _systems.find(x => x.core === system);

  if(systemData) return systemData.ssPlatformId;

  return undefined;
};

exports.getSystems = (req, res) => {
  res.json(_systems);
};

exports.getDescription = (req, res) => {
  
  const system = req.query.system;
  const cachedDescriptionsFolder = __dirname + '/descriptions/' + system;
  const cachedFilename = path.join(cachedDescriptionsFolder, req.query.name + '.json');

  if(!fs.existsSync(cachedDescriptionsFolder)) {
    fs.mkdirSync(cachedDescriptionsFolder, { recursive: true });
  }

  if (fs.existsSync(cachedFilename)) {
    fs.readFile(cachedFilename, 'utf8', (err, data) => {
      res.json(JSON.parse(data));
    });
  } else {
    const gameId = getGameIdFromName(system, req.query.name);

    if(!gameId) {
      res.json([]);
      return;
    }

    screenscraper.downloadGameDescriptions(gameId, cachedFilename).then(() => {
      fs.readFile(cachedFilename, 'utf8', (err, data) => {
        res.json(JSON.parse(data));
      });
    });
  }

};

exports.getImage = (req, res) => {

  const system = req.query.system;
  const fallbackImage = __dirname + '/notfound.jpg';

  const cachedImagesFolder = __dirname + '/images/' + system;
  const cachedFilename = path.join(cachedImagesFolder, req.query.name + '.jpg');

  if(!fs.existsSync(cachedImagesFolder)) {
    fs.mkdirSync(cachedImagesFolder, { recursive: true });
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

  screenscraper.downloadGameImage(gameId, cachedFilename).then(() => {
    res.sendFile(cachedFilename);
  });

};

exports.getSystemImage = (req, res) => {

  const system = req.query.system;

  if(system === 'epub') {
    res.sendFile(__dirname + '/epub.png');
    return;
  }

  const fallbackImage = __dirname + '/question_mark.png';

  const cachedImagesFolder = __dirname + '/system_images/' + system;
  const cachedFilename = path.join(cachedImagesFolder, 'logo.png');

  if (!fs.existsSync(cachedImagesFolder)) {
    fs.mkdirSync(cachedImagesFolder, { recursive: true });
  }

  if (fs.existsSync(cachedFilename)) {
    res.sendFile(cachedFilename);
    return;
  }

  const systemId = getSystemPlatformId(system);

  if(!systemId) {
    res.sendFile(fallbackImage);
    return;
  }

  screenscraper.downloadSystemImage(systemId, cachedFilename).then(() => {
    res.sendFile(cachedFilename);
  });

};

exports.downloadFile = (req, res) => {
  const folder = _gameFolders[req.query.folder];  
  res.download(path.join(folder, req.query.filename), req.query.filename);
};

exports.listFolderContents = (req, res) => {
  const folder = _gameFolders[req.query.folder];
  const files = fs.readdirSync(folder);
  res.json(files);
};

exports.saveState = (req, res) => {
  const folder = req.body.system;
  const state = req.body.state;

  //TODO: Save the screenshot
  const screenshot = req.body.screenshot;
  
  const savesFolder = __dirname + '/saves/' + folder;
  const saveState = path.join(savesFolder, req.body.name + '.sav');

  if(!fs.existsSync(savesFolder)) {
    fs.mkdirSync(savesFolder, { recursive: true });
  }

  console.log(`Writing ${saveState}...`);
  fs.writeFile(saveState, state, 'utf-8', () => {
     res.json({});
  });
}

exports.loadState = (req, res) => {
  const folder = req.query.system;
  
  const savesFolder = __dirname + '/saves/' + folder;
  const saveState = path.join(savesFolder, req.query.name + '.sav');

  if(!fs.existsSync(savesFolder)) {
    fs.mkdirSync(savesFolder, { recursive: true });
  }

  if(!fs.existsSync(saveState)) {
    res.json({ state: null });
    return;
  }

  console.log(`Reading ${saveState}...`);
  fs.readFile(saveState, 'utf8', (err, data) => {
     res.json({ state: data });
  });

}
