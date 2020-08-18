### Prerequisites
Have Node.js installed on your localhost. On MacOs you can install it using brew by running:
```
brew install node
```

### Deploying
```
# enable appsscript API
# https://script.google.com/home/usersettings
npm install
./node_modules/.bin/clasp login
# follow this guide to set up .clasp.json
# https://medium.com/@bajena3/building-a-custom-google-data-studio-connector-from-a-z-part-1-basic-setup-445a6d965d3f
npm run push
```

### Running the connector
```
npm run try_latest
```
