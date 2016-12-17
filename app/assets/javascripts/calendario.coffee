# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$ ->
  $.each gon.lote, (key, lote)->
    console.log typeof lote.ingresara_a_planta

  date = new Date
  d = date.getDate()
  m = date.getMonth()
  y = date.getFullYear()
  event = new Array()
  $.each gon.lote, (key, lote)->
    event.push({
      title: lote.op
      start: new Date(y, m, 1)
      backgroundColor: '#f56954'
      borderColor: '#f56954'
    })

  $('#calendar').fullCalendar
    header:
      left: 'prev,next today'
      center: 'title'
      right: 'month,agendaWeek,agendaDay'
    buttonText:
      today: 'hoy'
      month: 'mes'
      week: 'semana'
      day: 'día'
    events: event
    editable: true
    droppable: true
    monthNames: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio',
      'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre']
    monthNamesShort: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic']
    dayNames: ['Domingo','Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado']
    dayNamesShort: ['Dom','Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb']
  return

  return




