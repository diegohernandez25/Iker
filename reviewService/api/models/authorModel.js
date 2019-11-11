'use strict';
var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var Author_Schema = new Schema({
    id:{
        type: Number,
        required: true,
        unique: true
    },
    name:{
        type: String,
        required:true
    },
    tags: [String]
 });

 module.exports = mongoose.model('Author', Author_Schema);