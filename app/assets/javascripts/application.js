// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//


//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require foundation
//= require select2/select2
//= require rails.validations
//= require interleave
//= require turbolinks
//= require_tree .


//Solution to making Turbolinks and Foundation play nicely found here: http://foundation.zurb.com/forum/posts/36244-navigation-drop-down-not-working-with-turbolinks
$(document).on('page:load ready', function () {
  $(document).foundation();
  Foundation.Reveal.defaults.closeOnClick = false;
  Foundation.Reveal.defaults.closeOnEsc = false;
  new Interleave.ConditionOccurencesUI();

  window.ClientSideValidations.callbacks.element.fail = function(element, message, callback) {
    callback();
    if (element.data('valid') !== false) {
      if(element.hasClass('select2-hidden-accessible')) {
        var field_with_errors = element.parent('.field_with_errors');
        if (field_with_errors.has('.select2').length == 0) {
          var select2Hidden = field_with_errors.children('.select2-hidden-accessible')
          select2Hidden.after(field_with_errors.next('.select2'));
        }
      }
    }
  };

  window.ClientSideValidations.callbacks.element.pass = function(element, callback) {
    if(element.hasClass('select2-hidden-accessible')) {
      var field_with_errors = element.parent('.field_with_errors');
      if (field_with_errors.has('.select2').length == 1) {
        var select2 = field_with_errors.children('.select2')
        field_with_errors.after(select2);
      }
    }
    callback();
  }
});