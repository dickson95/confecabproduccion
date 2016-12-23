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
//= require jquery-ui/draggable
//= require jquery-ui/effect-highlight
//= require jquery-ui/effect-drop
//= require jquery-ui/datepicker
//= require jquery-ui/autocomplete
//= require jquery.floatingmessage
//= require bootstrap-sprockets
//= require plugins/colorpicker/bootstrap-colorpicker.min
//= require plugins/fullcalendar/moment.min
//= require plugins/fullcalendar/fullcalendar
//= require plugins/slimScroll/jquery.slimscroll.min
//= require plugins/datatables/jquery.dataTables.min
//= require plugins/datatables/dataTables.bootstrap.min
//= require plugins/morris/raphael-min
//= require plugins/morris/morris.min
//= require dist/js/app
//= require autocomplete-rails
//= require_tree .


$(document).on("ready", function () {
    //Remover mensajes informativos
    setTimeout(function () {
        $("#notice").slideUp("normal", function () {
            $(this).remove();
        });
    }, 7000);

    $("body").on('show.bs.dropdown', '.dropdown', function (e) {
        $(this).find('.dropdown-menu').first().stop(true, true).slideDown();
    }).on('hide.bs.dropdown', '.dropdown', function (e) {
        $(this).find('.dropdown-menu').first().stop(true, true).slideUp();
    });
});




