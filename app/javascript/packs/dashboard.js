import "../stylesheets/dashboard";

$(document).on('turbolinks:load',function(){
  "use strict";
  
  // Toggle the side navigation
  if(window.matchMedia("(min-width: 992px)").matches){
    $('#sidebarToggle').on("click", function(e) {
      e.preventDefault();
      $("body").toggleClass("sidenav-toggled");
    });
  }

})

if(window.matchMedia("(max-width: 991.98px)").matches){
  $(document).on("click",'.sidebar-toggle, #sidebarToggle', function(e) {
    e.preventDefault();
    $("body").toggleClass("sidenav-toggled");
    $("#layoutSidenav_content").toggleClass("sidebar-toggle");
  });
}
