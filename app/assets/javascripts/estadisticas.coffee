$(document).on "ready", ->
  $(".show_filter").on("ajax:before", (e) ->
    $(this).closest(".box").append('<div class="overlay"><i class="fa fa-refresh fa-spin"></i></div>')
  ).on("ajax:success", (e, data, status, xhr) ->
    $(".dropdown-menu").hide()
    box_body = $(this).closest(".box").find(".box-body")
    box_body.children("div:eq(1)").remove()
    console.log data
    $(data).appendTo(box_body)
  ).on("ajax:complete", (e, xhr, status) ->
    $(this).closest(".box").find(".overlay").remove()
  )

  $(".box").on "click", ".close", ->
    $(this).closest(".box").find(".box-body").children("div:eq(1)").remove()
return
