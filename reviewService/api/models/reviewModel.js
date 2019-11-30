'use strict';
var mongoose = require('mongoose');
var Schema = mongoose.Schema;
//var Comment = require('commentModel.js');


var Comment_Schema = new Schema({
  authorID: {
   type: Number,
   required: true
  },
  Text: {
   type: String,
   required: true
  }, 
  parents: {
    type: [String],
    default: []
   }
});

module.exports = mongoose.model('Comment', Comment_Schema);
var Review_Schema = new Schema({
  reviewdObjectID: {
    type: String,
    required: true
  },
  authorID: {
    type: String,
    required: true
  },
  rating: {
    type: Number,
    required: true
  },

  reviewText: String,

  date: {
    type: Date,
    default: Date.now()
  },

  comments:{
    type:[Comment_Schema],
    default:[]

  } });

module.exports = mongoose.model('Review', Review_Schema);