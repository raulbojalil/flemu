const fs = require('fs');
const path = require('path');

const screenscraper = require('./services/screenscraper');

let _systems = {};

fs.readFile('./systems.json', 'utf8', (err, data) => {
  _systems = JSON.parse(data);
});

const getGameIdFromName = (system, name) => {

  const tryGetGameId = (csvDataFile) => {

    const csvData = fs.readFileSync(csvDataFile, 'utf8');

    const lines = csvData.split('\n');

    const nameToLowerCase = name.toLowerCase();
    const games = lines.sort((a,b) => b.length - a.length);

    for (let i = 1; i < games.length; i++) {

      if (!games[i]) continue;

      const gameId = games[i].split(';')[0].replace(/"/g, '');
      const gameName = games[i].split(';')[1].replace(/"/g, '');

      if (nameToLowerCase.includes(gameName.toLowerCase())) {
        console.log(`Found game id: ${gameId}: ${gameName}`);
        return gameId;
      }
    }

    return undefined;    
  };

  return new Promise((resolve, reject) => {

    const systemData = _systems.find(x => x.id === system);

    if (!systemData) {
      console.log(`System '${system}' not found`);
      resolve(undefined);
      return;
    }
    
    const cachedGameListsFolder = __dirname + '/gamelists/';

    if (!fs.existsSync(cachedGameListsFolder)) {
      fs.mkdirSync(cachedGameListsFolder, { recursive: true });
    }

    const cachedFilename = path.join(cachedGameListsFolder, system + '.csv');

    if (!fs.existsSync(cachedFilename)) {
      screenscraper.downloadGameList(systemData.ssPlatformId, cachedFilename).then(() => {
        const gameId = tryGetGameId(cachedFilename);
        resolve(gameId);
      });
    }
    else {
      const gameId = tryGetGameId(cachedFilename);
      resolve(gameId);
    }
    
  });
}

const getSystemPlatformId = (system) => {
  const systemData = _systems.find(x => x.id === system);

  if(systemData) return systemData.ssPlatformId;

  return undefined;
};

exports.getSystems = (req, res) => {
  res.json(_systems);
};

exports.getDescription = (req, res) => {
  
  const system = req.query.system;

  const platformId = getSystemPlatformId(system);

  if(!platformId) {
    res.json([]);
    return;
  }

  const cachedDescriptionsFolder = __dirname + '/descriptions/' + system;
  const cachedFilename = path.join(cachedDescriptionsFolder, req.query.name + '.json');

  if(!fs.existsSync(cachedDescriptionsFolder)) {
    fs.mkdirSync(cachedDescriptionsFolder, { recursive: true });
  }

  if (fs.existsSync(cachedFilename)) {
    console.log(`Reading ${cachedFilename}...`);
    fs.readFile(cachedFilename, 'utf8', (err, data) => {
      res.json(JSON.parse(data));
    });
  } else {
    
    getGameIdFromName(system, req.query.name).then((gameId) => {
      if(!gameId) {
        res.json([]);
        return;
      }
  
      screenscraper.downloadGameDescriptions(gameId, cachedFilename).then(() => {
        fs.readFile(cachedFilename, 'utf8', (err, data) => {
          res.json(JSON.parse(data));
        });
      });
    });
  }

};

exports.getImage = (req, res) => {

  const system = req.query.system;
  const fallbackImage = __dirname + '/notfound.jpg';

  const platformId = getSystemPlatformId(system);

  if(!platformId) {
    res.sendFile(fallbackImage);
    return;
  }

  const cachedImagesFolder = __dirname + '/images/' + system;
  const cachedFilename = path.join(cachedImagesFolder, req.query.name + '.jpg');

  if(!fs.existsSync(cachedImagesFolder)) {
    fs.mkdirSync(cachedImagesFolder, { recursive: true });
  }

  if (fs.existsSync(cachedFilename)) {
    res.sendFile(cachedFilename);
    return;
  }

  getGameIdFromName(system, req.query.name).then((gameId) => {

    if(!gameId) {
      res.sendFile(fallbackImage);
      return;
    }
  
    screenscraper.downloadGameImage(gameId, cachedFilename).then(() => {
      res.sendFile(cachedFilename);
    });
  
  });

};

exports.getSystemImage = (req, res) => {

  const system = req.query.system;

  const systemData = _systems.find(x => x.id === system);

  if(systemData.image) {
    res.sendFile(__dirname + systemData.image);
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
  const system = req.query.system;
  const systemData = _systems.find(x => x.id === system);

  const file = path.join(systemData.path, req.query.filename);

  if (fs.existsSync(file)) 
    res.download(file, req.query.filename);
  else 
    res.sendStatus(404);
};

exports.listFolderContents = (req, res) => {
  const system = req.query.system;
  const systemData = _systems.find(x => x.id === system);

  if (systemData.path) {
    const files = fs.readdirSync(systemData.path);
    res.json(files.map(name => { return { name } }));
  }
  else if(systemData.links) {
    res.json(systemData.links);
  }
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
