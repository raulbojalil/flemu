const client = require('https');
const fs = require('fs');

exports.downloadGameImage = function(gameId, outputFilepath) {
  return new Promise((resolve, reject) => {
    const imageUrl = `https://www.screenscraper.fr/image.php?gameid=${gameId}&media=box-2D&hd=0&region=us&num=&version=&maxwidth=500`;

    client.get(imageUrl, (imageRes) => {
      console.log(`Writing to ${outputFilepath}...`);
      imageRes.pipe(fs.createWriteStream(outputFilepath))
        .on('error', () => reject())
        .once('close', () => resolve());
    });
  });
}

exports.downloadGameDescriptions = function(gameId, outputFilepath) {
  return new Promise((resolve, reject) => {
    const htmlUrl = `https://www.screenscraper.fr/gameinfos.php?gameid=${gameId}`;

    client.get(htmlUrl, (htmlRes) => {
      let data = '';

      htmlRes.on('data', (chunk) => {
          data += chunk;
      });

      htmlRes.on('end', () => {
        const lines = data.split('\n');

        let descriptionsMap = {};
        let readingLanguages = false;
        let readingDescription = false;
        let currentLang = '';

        for(let i=0; i < lines.length; i++) {
          const line = lines[i];

          if (line.includes('Languages')) readingLanguages = true;

          if (!readingLanguages) continue;

          if (line.includes('cssadmintabletdwhite') && readingDescription) {
            readingDescription = false; 
          }
          else if (currentLang && readingDescription) {
            descriptionsMap[currentLang] = descriptionsMap[currentLang] || '';
            descriptionsMap[currentLang] += line.replace("</td>", "").trim() + ' ';
          } else if (line.includes('Anglais')) currentLang = 'en';
          else if (line.includes('Français')) currentLang = 'fr';
          else if (line.includes('Espagnol')) currentLang = 'es';
          else if (line.includes('Allemand')) currentLang = 'de';
          else if (line.includes('Italien')) currentLang = 'it';
          else if (line.includes('Portugais')) currentLang = 'pt';
          else if (line.includes('Japonais')) currentLang = 'ja';
          else if (line.includes("cssadmintabletdwhite") && currentLang) {
            readingDescription = true;
          }
        }

        const languages = Object.keys(descriptionsMap).map(key => { return { description: descriptionsMap[key], lang: key } });
        fs.writeFileSync(outputFilepath, JSON.stringify(languages));

        resolve();
      });

    }).on("error", (err) => {
      reject(err);
    });
  });
}

