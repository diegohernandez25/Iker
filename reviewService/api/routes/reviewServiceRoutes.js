'use strict';

module.exports = function(app) {
  var reviewService = require('../controllers/reviewServiceController');

  // /review
  app.route('/review')
    .get(reviewService.listReviews)
    .post(reviewService.addReview)
    

  app.route('/review/:_id')
    .delete(reviewService.deleteReview)
    .put(reviewService.updateReview)
/*
  app.route('/review/:_id')
    .delete(reviewService.deleteReview)
    .put(reviewService.updateReview)
*/
  app.route('/review/:_id/comment')
    .post(reviewService.newComment)
    

  app.route('/avgRating/:reviewdObjectID')
    .get(reviewService.getAvgRating)

  //Comments  
  
    //.delete()
    //.put()
    /*
    .put(reviewService.updateReview);
    

  app.route('/review/:reviewId')
  .delete(reviewService.deleteReview);


  // /object
  app.route('/review/:reviewId')
  .delete(reviewService.deleteReview);


  // /author

*/
};