$(document).on "turbolinks:load", ->

# métodos con Ajax
  bindDatePicker = (element)->
    $(element).datepicker
      monthNames: ["Enero", "Febrero", "Marzo", "Abril",
        "Mayo", "Junio", "Julio", "Agosto", "Septiembre",
        "Octubre", "Noviembre", "Diciembre"]
      dayNamesMin: ["do", "lu", "ma", "mi", "ju", "vi", "sa"]
      dateFormat: "dd MM yy"
      onClose: (text, obj) ->
        input = $(this)
        date = obj.selectedYear + "-" + (obj.selectedMonth + 1) + "-" + obj.selectedDay
        $.ajax(
          type: "PATCH"
          url: input.data("url")
          data: {lote: {ingresara_a_planta: date}}
        )
  setDatePicker = ()->
    $(".ingresara_a_planta").each ->
      bindDatePicker($(this))

  setDatePicker()

  $("body").on "ajax:success", "a[data-remote], form[data-remote]", (e, data, status, xhr) ->
    setDatePicker()

  # Cambiar la clase active entre las pestañas y la carga de los datos
  $("ul.nav-tabs a").click (e)->
    e.preventDefault()
    $(this).closest("ul").find(".active").removeClass("active")
    has = $(this).parent()
    if has.hasClass('year') && has.hasClass('current')
      year = $(this).text()
      if !$('#' + year).find('div.tab-content div.active').length
        $('#' + year).find('div.current').removeClass('in active').addClass('in active')

  # Ancho de las columnas mientras es arrastrada la fila
  fixHelper = (e, ui) ->
    ui.children().each ->
      $(this).width $(this).width()
      return
    ui

  fix_update = (e, ui) ->
    item_id = ui.item.data('item-id')
    array = []
    table = "#" + $(this).attr("id")
    $(table + " > tbody > tr").each (i) ->
      sec = $(this).index() + 1
      $(this).find("input[type=text]").val(sec)
      array.push
        lote_id: $(this).data('item-id')
        position: sec
      return
    position = ui.item.index() # this will not work with paginated items, as the index is zero on every page
    $.ajax(
      type: 'PATCH'
      url: '/programaciones/update_row_order'
      dataType: 'json'
      data: {programacion: {updated_positions: array}}
    )


  # Sortable para las tablas de la programación
  $ ->
    if $('.sortable').length > 0
      array = new Array

      $('.sortable').sortable(
        axis: 'y'
        items: '.item'
        cursor: 'move'
        helper: fixHelper

        sort: (e, ui) ->
          ui.item.addClass('warning')

        stop: (e, ui) ->
          ui.item.removeClass('active-item-shadow')
          # Resalta la fila indicada en la actualización
          ui.item.removeClass("warning")
          ui.item.addClass("success")

        update: fix_update
      )
      $('table').on "dblclick", "tbody > tr", ->
        if $(this).hasClass("success")
          $(this).removeClass("success")
        else
          $(this).addClass("success")


  # nav tabs responsive
  tab = $(".tab-content").find(".nav-tabs")
  if $(document).load
    if $(document).width() < 1263
      tab.removeClass("nav-justified")
    else
      tab.addClass("nav-justified")

  # Editar la cantidad de la meta mensual
  $("table").on "keyup", "input#programacion_meta_mensual", ->
    target = $(this).val()
    programacion_id = $(this).data("month")
    $.ajax
      url: 'programaciones/' + programacion_id + '/update_meta_mensual'
      type: 'POST'
      data:
        monthly_target: target


  $(window).resize ->
    if $(document).width() < 1263
      tab.removeClass("nav-justified")
    else
      tab.addClass("nav-justified")

return
