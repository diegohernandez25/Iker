'use strict';
var mongoose = require('mongoose');
var Schema = mongoose.Schema;


var RevObject_Schema = new Schema({
  id: {
    type: Number ,
    required: true,
    unique: true,
  },
  name : {
    type: String,
    required: true
  }
});

module.exports = mongoose.model('RevObject', RevObject_Schema);