//SCROLL NAV
$('body').scrollspy({
  target: '#mainNav',
  offset: 80
});




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

//Sidebar

/*
$("#sidebar").mCustomScrollbar({
  scrollInertia: 100,
  theme: "minimal"
});

$('#dismiss, .overlay').on('click', function () {
  $('#sidebar').removeClass('active');
  $('.overlay').removeClass('active');
});

$('#sidebarCollapse').on('click', function () {
  $('#sidebar').addClass('active');
  $('.overlay').addClass('active');
  $('.collapse.in').toggleClass('in');
  $('a[aria-expanded=true]').attr('aria-expanded', 'false');
});
 */



// jquery ready start
$(document).ready(function() {
	// jQuery code

	//////////////////////// Prevent closing from click inside dropdown
    $(document).on('click', '.dropdown-menu', function (e) {
      e.stopPropagation();
    });

    // make it as accordion for smaller screens
    if ($(window).width() < 992) {
	  	$('.dropdown-menu a').click(function(e){
	  		e.preventDefault();
	        if($(this).next('.submenu').length){
	        	$(this).next('.submenu').toggle();
	        }
	        $('.dropdown').on('hide.bs.dropdown', function () {
			   $(this).find('.submenu').hide();
			})
	  	});
	}
	
}); // jquery end