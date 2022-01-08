const PORT = process.env.PORT || 5000;

const express = require('express');
const app = express();
const cors = require('cors');

app.use(express.static(__dirname + '/public'));
app.use(express.json());
app.use(cors());

const filemanager = require('./filemanager');

//GET /filemanager/systems
app.get('/filemanager/systems', filemanager.getSystems);
//GET /filemanager/description?system=&name=
app.get('/filemanager/description', filemanager.getDescription);
//GET /filemanager/image?system=&name=
app.get('/filemanager/image', filemanager.getImage);
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

