// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function() {
    
  $('[data-confirm]').click(function(e) {
    var message = $(this).attr('data-confirm');
    if (!confirm(message)) e.preventDefault();
  });
  
  $('.expand_guest_list').click(function() {
    $('ol.guest_list').toggle();
    if ($('ol.guest_list').css('display') == 'none') {
      $(this).html('show guest list');
    } else {
      $(this).html('hide guest list');
    }
  });
});

function logout() {
  window.location = "/logout"
}