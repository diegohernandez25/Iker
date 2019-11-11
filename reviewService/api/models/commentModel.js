/*'use strict';
var mongoose = require('mongoose');
var Schema = mongoose.Schema;


var Comment_Schema = new Schema({
   authorID: {
    type: Number,
    required: true
   },
   Text: {
    type: String,
    required: true
   }, 
});

//module.exports = Comment_Schema;
module.exports = mongoose.model('Comment', Comment_Schema);
*/