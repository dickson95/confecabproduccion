# Acciones que el controlador de los usuarios del administrador menipula
$(document).on "ready", ->
  load_tabs = (tab)->
    $.ajax(
      url: tab.data("url")
      dataType: "html"
      success: (data, status, xhr) ->
        id = $(tab.children().attr("href"))
        div = tab.parent().next().find(id)
        div.children().remove()
        div.append(data)
    )

  tabs = $(".users").find(".nav-tabs")
  load_tabs(tabs.children("li.active"))
  tbody = undefined
  $("body.users").on("ajax:before", "a[data-action='delete']", (e)->
    tbody = $(this).closest("tbody")
  ).on "ajax:success", "a[data-action='delete']", (e, data, status, xhr)->
    length = tbody.children("tr").length
    if length < 1
      load_tabs(tabs.children("li.active"))

  tabs.children().on "click", ->
    load_tabs($(this))



