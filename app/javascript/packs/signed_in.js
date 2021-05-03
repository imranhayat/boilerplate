import "../stylesheets/signed_in";

$(document).on('turbolinks:load',function(){
  "use strict";

  var page_height = $('.page-center').outerHeight() + $('nav').outerHeight() + $('footer').outerHeight();
  var window_height = $(window).height();
  if(page_height < window_height){
    $('.page-center').closest('main').removeClass('flex-shrink-0').addClass('h-100');
  }

  // Stripe
  $('[name="plan[interval]"]').on('change',function(){
    var t = $(this);
    var i_count = $('.i_count')
    if(t.val() == "year"){
      i_count.addClass("d-none");
    }
    else{
      i_count.removeClass("d-none");
    }
  })

  $('.btn-choose-plan.choose').on('click', function(){
    $('#spinner').modal('show');
  })
})

// Image Preview
function readURL(input) {
  if (input.files && input.files[0]) {
    var reader = new FileReader();
    reader.onload = function(e) {
      $('#imagePreview').prop('src', e.target.result);
      $('#imagePreview').show();
      $('.first-letter.edit-profile').hide();
      $('#imagePreview').fadeIn(650);
    }
    reader.readAsDataURL(input.files[0]);
  }
}
$(document).on('change','#imageUpload',function() {
  readURL(this);
});

// Telephone Field Validation
$(document).on('change keydown keyup paste','input[type="tel"]', function (e) {
  var output,
    $this = $(this),
    input = $this.val();
  if(input != ''){
    if(e.keyCode != 8) {
      input = input.replace(/[^0-9]/g, '');
      var area = input.substr(0, 3);
      var pre = input.substr(3, 3);
      var tel = input.substr(6, 4);
      if (area.length < 3) {
        output = "(" + area;
      } else if (area.length == 3 && pre.length < 3) {
        output = "(" + area + ")" + " " + pre;
      } else if (area.length == 3 && pre.length == 3) {
        output = "(" + area + ")" + " " + pre + "-" + tel;
      }
      $this.val(output);
    }
  }
});

// URL Validation
$(document).on('blur','input[type="url"]', function (){
  var string = $(this).val();
  if (!~string.indexOf("http")) {
    string = "http://" + string;
  }
  $(this).val(string);
});