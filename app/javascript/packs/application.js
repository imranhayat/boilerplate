// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

require("bootstrap");
import "../stylesheets/application";
$(document).on('turbolinks:load',function(){
  "use strict";

  var page_height = $('.page-center').outerHeight();
  var window_height = $(window).height();
  if(page_height < window_height){
    $('.page-center').closest('main').removeClass('flex-shrink-0').addClass('h-100');
  }

  // Bootstrap Custom File Input
  bsCustomFileInput.init();
  
  // Add active class to Header links
  var path = window.location.href; // because the 'href' property of the DOM element is the absolute path
  $("a.nav-link").each(function() {
    if (this.href === path) {
      $(this).addClass("active");
      $(this).closest('.sidebar-collapse').addClass("show");
      $(this).closest('.sidebar-collapse').prev('.nav-link').addClass('active').removeClass("collapsed");
    }
  });

  $('[type="password"]').closest('.form-group').addClass('password_show');
  $('.password_show').append('<i class="fas fa-eye"></i>');
})

// Password Show/Hide
$(document).on('click','.password_show .fas', function(){
  var password_field =  $(this).closest('.password_show').find('input');
  if($(this).hasClass('fa-eye')){
    password_field.attr('type','text');
    $(this).removeClass('fa-eye').addClass('fa-eye-slash');
  }
  else{
    password_field.attr('type','password');
    $(this).removeClass('fa-eye-slash').addClass('fa-eye');
  }
});
