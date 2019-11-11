'use strict';
var mongoose = require('mongoose'),
  Review = mongoose.model('Review'),
  Comment=mongoose.model('Comment');


//Validated
exports.listReviews = function(req, res, next) {
    var toFind={};
    if (req.query._id!=null){
      toFind._id=req.query._id;
    }
    if (req.query.rating!=null){
      toFind.rating=req.query.rating;
    }
    if (req.query.authorID!=null){
      toFind.authorID=req.query.authorID;
    }
    if (req.query.reviewdObjectID!=null){
      toFind.reviewdObjectID=req.query.reviewdObjectID;
    }
    Review.find(toFind,{'__v':0}).then(function(review){
      res.send(review);
    }).catch(next);  
  };


//Validated  
exports.addReview = function(req, res,next) {
  var toCreate={reviewdObjectID: req.body.reviewdObjectID, authorID:req.body.authorID, rating: req.body.rating,reviewText: req.body.reviewText }
  Review.create(toCreate).then(function(review){
    res.send({_id: review._id});
  }).catch(next);
};

//Validated
exports.deleteReview = function(req,res,next){
  Review.findByIdAndDelete({_id:req.params._id}).then(function(review){
    res.send({_id:review._id});
  }).catch(next);
};

//Validated
//FIXME - DeprecationWarning: Mongoose: `findOneAndUpdate()` and `findOneAndDelete()` without the `useFindAndModify` option set to false 
//  are deprecated. See: https://mongoosejs.com/docs/deprecations.html#-findandmodify-
exports.updateReview = function(req,res,next){
  var toUpdate={};
  if(req.body.reviewText!=null){
    toUpdate.reviewText=req.body.reviewText;
  }
  if(req.body.rating){
    toUpdate.rating=req.body.rating;
  }
  Review.findByIdAndUpdate({_id: req.params._id},toUpdate).then(function(){
    (Review.findById({_id:req.params._id}).then(function(review){
      res.send({_id: review._id})
    }));
   
  }).catch(next);
};

//Validated
exports.getAvgRating = function(req,res,next){
  Review.find({reviewdObjectID: req.params.reviewdObjectID}).then(function(reviews){
    if(reviews.length!=0){
      var sum=0;
      reviews.forEach(review => {
        console.log(review);
        sum+=review.rating;
      });
      var avg = sum/reviews.length;
      console.log(sum);
      console.log(reviews.length);
      console.log(avg);
      res.send({reviewdObjectID: req.params.reviewdObjectID, avgRating: avg});
    }
    else{
      res.status(404).send(new Error('No reviews for said Object ID'));
    }
  }).catch(next);
};  

//Validated
exports.newComment = function(req, res,next) {
    Comment.create({authorID: req.body.authorID, Text: req.body.Text, parents: req.body.parentComments}).then(function(comment){
      var review=Review.findById({_id: req.params._id}).then(function(review){
        review.comments.push(comment);
        review.save(function (err, review) {
          if (err) return console.error(err);
        });
        res.status(200).send(comment);
      });
  }).catch(next);
};







/*
  var new_task = new Review(req.body);
  new_task.save(function(err, task) {
    if (err)
      res.send(err);
    res.json(task);
  });*/
