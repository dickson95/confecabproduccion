$(document).on "ready", ->
  $(".show_filter").on "ajax:success", (e, data, status, xhr) ->
    $(".dropdown-menu").hide()
    box_body = $(this).closest(".box").find(".box-body")
    box_body.children("div:eq(1)").remove()
    box_body.append(data)

  $(".box").on "click", ".close", ->
    $(this).closest(".box").find(".box-body").children("div:eq(1)").remove()
return
