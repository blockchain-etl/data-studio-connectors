### Prerequisites
Have Node.js installed on your localhost. On MacOs you can install it using brew by running:
```
brew install node
```

* [Enable the Apps Script API](https://script.google.com/home/usersettings)
* Follow this guide to [create a new Apps Script project](https://medium.com/@bajena3/building-a-custom-google-data-studio-connector-from-a-z-part-1-basic-setup-445a6d965d3f)
  * Get the script ID from the project URL when editing it. For example, if you are editing `https://script.google.com/d/1BMTO81eIdQ9-xOLdB_68p3DcYcMBgKDSCcUml1H4wwLQYSS2URU-_5bn/edit`, the script ID is `1BMTO81eIdQ9-xOLdB_68p3DcYcMBgKDSCcUml1H4wwLQYSS2URU-_5bn`. Make note.

### Deploying
```
npm install
./node_modules/.bin/clasp login
npm run push
```

### Running the connector
```
npm run try_latest
```
