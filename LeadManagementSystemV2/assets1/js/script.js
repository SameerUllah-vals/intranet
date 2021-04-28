//SCROLL NAV
$('body').scrollspy({
    target: '#mainNav',
    offset: 80
  });  
  var navbarCollapse = function() {
    if ($("#mainNav").offset().top > 100) {
      $("#mainNav").addClass("navbar-shrink");
    } else {
      $("#mainNav").removeClass("navbar-shrink");
    }
  };    
  navbarCollapse();
  $(window).scroll(navbarCollapse);  


//SCROLL TOP
$('body').append('<div id="scrollTop" class="btn btn-descon"> <span class="fa fa-chevron-circle-up"></span></div>');
$(window).scroll(function () {
  if ($(this).scrollTop() != 0) {
    $('#scrollTop').fadeIn();
  } else {
    $('#scrollTop').fadeOut();
  }
});
$('#scrollTop').click(function () {
  $("html, body").animate({
    scrollTop: 0
  }, 1000);
  return false;
});

