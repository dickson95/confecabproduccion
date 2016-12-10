$(document).on "ready", ->
  $(".show_filter").on "ajax:success", (e, data, status, xhr) ->
    $(".dropdown-menu").hide()
    panel_body = $(this).closest(".panel").find(".panel-body")
    panel_body.children("div:eq(1)").remove()
    panel_body.append(data)

  $(".panel-body").on "click", ".close", ->
    $(this).parent().parent().remove()
return
