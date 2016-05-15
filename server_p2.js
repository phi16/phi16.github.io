var http = require("http");
var express = require("express");
var path = require("path");
var filed = require("filed");

var app = express();
app.get('/',function(req,res){
  res.sendFile('C:\\Users\\16\\Desktop\\Poyo\\P2\\index.html');
});
app.use(express.static('.'));
http.createServer(app).listen(3000);
console.log(":)");
