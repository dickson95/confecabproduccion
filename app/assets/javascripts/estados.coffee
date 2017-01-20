# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
  $("body.estados").on("click keyup mouseover", "#estado_color, #estado_color_claro, .colorpicker", ->
    $("#preview-td").css("background-color",  $("#estado_color").val())
    $("#preview").css("background-color", $("#estado_color_claro").val())
  ).on "click", ".edit_estado button[type='button'], .new_estado button[type='button']", ->
    $(".edit_estado, .new_estado").parent().remove()
    $("#box-estados").removeClass("col-md-6").addClass("col-md-12")