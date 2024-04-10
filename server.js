const express = require('express');
const os = require('os')

const app = express();
const port = 3000;

const { networkInterfaces } = require('os');

const nets = networkInterfaces();
const results = Object.create(null);
console.log(nets)
console.log(results)

app.get('/', (req, res) => {
  var ipAdress = nets['eth0'][0]['address']
  var hostname = os.hostname()
  var version = process.env.APP_VERSION
  var result = "adress ip: " + ipAdress + "</br>"
   + "nazwa serwera: " + hostname + "</br>"
   + "wersja aplikacji: " + version + "</br>"
  res.send(result);
});

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});