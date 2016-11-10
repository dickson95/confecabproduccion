// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui/sortable
//= require jquery-ui/effect-highlight
//= require jquery-ui/datepicker
//= require jquery-ui/autocomplete
//= require autocomplete-rails
//= require bootstrap_sb_admin_base_v2
//= require rails.validations
//= require rails.validations.simple_form
//= require turbolinks
//= require_tree .

$(document).on("turbolinks:load", function(){
  //Remover mensajes informativos
  setTimeout(function() {
    $("#notice").slideUp("normal", function() { $(this).remove(); } );
  }, 7000);

	$('.dropdown').on('show.bs.dropdown', function(e) {
    $(this).find('.dropdown-menu').first().stop(true, true).slideDown()
  })
    
  $('.dropdown').on('hide.bs.dropdown', function(e){
    $(this).find('.dropdown-menu').first().stop(true, true).slideUp()
  })
})


document.addEventListener("turbolinks:before-cache", function() {
  var tablelotes = $('#lotes').DataTable();
  var tablecontrol = $('#control').DataTable();
  var tableclientes = $('#t_clientes').DataTable();
  var tables2 = $('.tablas2').DataTable();
	tablelotes.destroy();
	tablecontrol.destroy();
	tableclientes.destroy();
	tables2.destroy();
})



