const PORT = process.env.PORT || 5000;

const express = require('express');
const app = express();
const cors = require('cors');
const nocache = require('nocache');

app.use(express.static(__dirname + '/public'));
app.use(express.json({ limit: 30000000 }));
app.use(cors());
app.use(nocache());

const filemanager = require('./filemanager');

//GET /filemanager/systems
app.get('/filemanager/systems', filemanager.getSystems);
//GET /filemanager/description?system=&name=
app.get('/filemanager/description', filemanager.getDescription);
//GET /filemanager/image?system=&name=
app.get('/filemanager/image', filemanager.getImage);
//GET /filemanager/systemimage?system=
app.get('/filemanager/systemimage', filemanager.getSystemImage);
//GET /filemanager/download?folder=&filename=
app.get('/filemanager/download', filemanager.downloadFile);
//GET /filemanager/list?folder=
app.get('/filemanager/list', filemanager.listFolderContents);
//POST /filemanager/savestate { system, name, state, screenshot }
app.post('/filemanager/savestate', filemanager.saveState);
//GET /filemanager/loadstate?system=&name=
app.get('/filemanager/loadstate', filemanager.loadState);

app.listen(PORT, () => {
    console.log(`App listening at http://localhost:${PORT}`)
})

