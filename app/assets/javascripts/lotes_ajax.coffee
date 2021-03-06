$(document).on 'ready', ->
  # Funciones

  # Cargar datos de las Tabs al inicio de la carga o cuando se da click en una de ellas
  load_tabs = (ele=null)->
    ele ||= $(".nav-tabs").find(".active").data("url-tabs")
    $.ajax(
      url: ele
      type: "GET"
    )

  remove_animate_tr = (tr)->
     tr.children('td').animate(
        padding: 0
      ).wrapInner('<div />')
        .children()
        .slideUp(->
          $(this).closest('tr').remove()
        )
  # Fin zona funciones
  # __________________

  # Tab
  $("li[data-url-tabs]").click ->
    document.cookie = "tab_active="+$(this).data("id")+"; path=/"
    load_tabs($(this).data("url-tabs"))
  load_tabs()

  # Cambio de estado
  $('.lotes .tab-content').on('ajax:complete', '.change', (e, xhr, status) ->
    if xhr.status == 304
      $.floatingMessage "El lote no tiene programación.\n No puede pasar de integración.", {
        position: "bottom-right"
        height: 80
        time: 4000
        className: "ui-state-error"
      }
      $(".dropdown-menu").hide().parent().removeClass("open")
      $(".overlay").remove()
  ).on('ajax:success', '.change', (e, data, status, xhr) ->
    if xhr.status == 200
      $.floatingMessage data.message, {
        position: "bottom-right"
        height: 80
        time: 4000
        className: "ui-state-active"
      }
      dropd = $(this)
      tr = dropd.closest("tr")
      remove_animate_tr(tr)
      $(".overlay").remove()
  )