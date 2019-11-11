var express = require('express'),
  app = express(),
  port = process.env.PORT || 3000,
  mongoose = require('mongoose'),
  Review,Comment = require('./api/models/reviewModel.js'),
  RevObject = require('./api/models/objectModel.js'),
  Author = require('./api/models/authorModel.js'),
  bodyParser = require('body-parser');

mongoose.Promise = global.Promise;
mongoose.connect('mongodb://localhost/reviewDB', { 
  useNewUrlParser: true,
  useUnifiedTopology: true,
  useCreateIndex: true }); 

//body Parser
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

//route resolve
var routes = require('./api/routes/reviewServiceRoutes'); //importing route
routes(app); //register the route

//error handling

app.use(function(err, req,res, next){
  res.status(422).send({error :err.message});
});

app.listen(port);

console.log('reviewService started on port: ' + port);