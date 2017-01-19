# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).ready ->
# https://reviblog.net/2014/07/01/sumar-dias-a-una-fecha-en-javascript/
  sumaFecha = (d, fecha) ->
    `var fecha`
    Fecha = new Date
    sFecha = fecha or Fecha.getDate() + '/' + Fecha.getMonth() + 1 + '/' + Fecha.getFullYear()
    sep = if sFecha.indexOf('/') != -1 then '/' else '-'
    aFecha = sFecha.split(sep)
    fecha = aFecha[2] + '/' + aFecha[1] + '/' + aFecha[0]
    fecha = new Date(fecha)
    fecha.setDate fecha.getDate() + parseInt(d)
    anno = fecha.getFullYear()
    mes = fecha.getMonth() + 1
    dia = fecha.getDate()
    mes = if mes < 10 then '0' + mes else mes
    dia = if dia < 10 then '0' + dia else dia
    return new Date(anno, mes - 1, dia)

  ini_events = (ele) ->
    ele.each ->
# create an Event Object (http://arshaw.com/fullcalendar/docs/event_data/Event_Object/)
      eventObject = title: $.trim($(this).text())
      # store the Event Object in the DOM element so we can get to it later
      $(this).data 'eventObject', eventObject
      # make the event draggable using jQuery UI
      $(this).draggable
        zIndex: 1070
        revert: true
        revertDuration: 0
      return
    return

  update_ingresara_a_planta = (date, url) ->
    moment = date
    month = moment.getMonth() + 1
    real_d = sumaFecha(1, moment.getDate() + "-" + month + "-" + moment.getFullYear())
    $.ajax(
      type: 'PATCH'
      url: url
      data: {lote: {year: real_d.getFullYear(), month: real_d.getMonth() + 1, day: real_d.getDate()}}
    )

  drop = (date, allDay) ->
    originalEventObject = $(this).data('eventObject')
    # Es necesario copiar el 'originalEventObject', así múltiples eventos no hacen referencia al mismo objeto
    copiedEventObject = $.extend({}, originalEventObject)
    # asigna los datos pasados
    copiedEventObject.start = date
    copiedEventObject.allDay = allDay
    copiedEventObject.backgroundColor = $(this).data("color")
    copiedEventObject.borderColor = $(this).data("color")
    # renderizar el evento en el calendario
    # El último argumento 'true' causa que el evento quede fijo al calendario (http://arshaw.com/fullcalendar/docs/event_rendering/renderEvent/)
    $('#calendar').fullCalendar 'renderEvent', copiedEventObject, true
    $(this).remove()
    update_ingresara_a_planta(date._d, $(this).data("url"))

  event_drop = (e) ->
    console.log e
    update_ingresara_a_planta(e.start._d, e['data-url'])


  ini_events($('#external-events div.external-event'))


  $('#calendar').fullCalendar
    header:
      left: 'prev,next today'
      center: 'title'
      right: 'month'
    timezone: 'America/Bogota'
    buttonText:
      today: 'hoy'
      month: 'mes'
      week: 'semana'
      day: 'día'
    events: $('#calendar').data("url")
    editable: true
    droppable: true
    monthNames: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio',
      'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre']
    monthNamesShort: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic']
    dayNames: ['Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado']
    dayNamesShort: ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb']
    drop: drop
    eventDrop: event_drop
    $(this).remove()
  return





