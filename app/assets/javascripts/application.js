//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require activestorage
//= require swiper/swiper-bundle.js

$(document).ready(function() {
  $('#scroll-top-btn').click(function(e) {
    e.preventDefault(); 
    $('html, body').animate({ scrollTop: 0 }, 'slow');
  });
});