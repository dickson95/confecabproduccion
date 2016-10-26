# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  # DataTables
  $('#lotes').DataTable
      language:
        processing: 'Cargando...'
        search: 'Buscar&nbsp;:'
        lengthMenu: 'Mostrar _MENU_ registros'
        info: 'Resultados _START_ a _END_ de _TOTAL_ '
        infoEmpty: 'No hay datos o intente de nuevo'
        infoFiltered: '(filtrado de _MAX_ registros)'
        infoPostFix: ''
        loadingRecords: 'Cargando...'
        zeroRecords: 'No se encuentran registros'
        emptyTable: 'No hay datos disponibles'
        paginate:
          previous: 'Anterior'
          next: 'Siguiente'
      order: [[0, "desc"]]
      columnDefs:[
                    {
                      'targets': [ 0 ]
                      'visible': false
                      'searchable': false
                    }
                    {
                      'targets': [ 1 ]
                      'orderable': false
                    }
                  ]  
  $('.dataTables_filter label').after $('.dataTables_filter label input[type="search"]').detach()
  
  $('.dropdown').on 'show.bs.dropdown', (e) ->
    $(this).find('.dropdown-menu').first().stop(true, true).slideDown()
    return
    
  $('.dropdown').on 'hide.bs.dropdown', (e) ->
    $(this).find('.dropdown-menu').first().stop(true, true).slideUp()
    return

  # Inputs con fecha administrada por parte de jQuery
  minimumDate = ->
    $("#lote_fecha_entrada").val()

  # Doc: http://api.jqueryui.com/datepicker/
  $("input.datepicker").each (i) ->
    $(this).datepicker
      monthNames: [ "Enero", "Febrero", "Marzo", "Abril", 
      "Mayo", "Junio", "Julio", "Agosto", "Septiembre", 
      "Octubre", "Noviembre", "Diciembre" ]
      dayNamesMin: [ "do","lu","ma","mi","ju","vi","sa" ]
      showButtonPanel: true
      beforeShow: (el, dp) -> 
        $('#ui-datepicker-div').toggleClass('hide-calendar', $(el).is('[data-calendar="false"]'))
      currentText: "Hoy"
      closeText: "x"
      dateFormat: "yy-mm-dd"
      altFieldTimeOnly: false
      altFormat: "yy-mm-dd"
      altField: $(this).next()
      maxDate: '0'
      minDate: minimumDate()
  set_up = true

  # funcion para impedir que se establesca la fecha cuando se borra o se tabula en el campo
  $("#lote_programacion_id").on "keyup", ->
    if $(this).val().trim() == ""
      $(this).datepicker( "refresh" )  
      set_up = false
  
  $("#lote_programacion_id").datepicker
      monthNames: [ "Enero", "Febrero", "Marzo", "Abril", 
      "Mayo", "Junio", "Julio", "Agosto", "Septiembre", 
      "Octubre", "Noviembre", "Diciembre" ]
      monthNamesShort: [ "Ene", "Feb", "Mar", "Abr", 
      "May", "Jun", "Jul", "Ago", "Sep", 
      "Oct", "Nov", "Dic" ]
      beforeShow: (el, dp) -> 
        $('#ui-datepicker-div').toggleClass('hide-calendar', $(el).is('[data-calendar="false"]'))
      changeMonth: true
      changeYear: true
      closeText: "Aceptar"
      currentText: "Hoy"
      dateFormat: "MM yy"
      minDate: '0'
      onClose: (dateText, inst) -> 
        if set_up
          $(this).datepicker('setDate', new Date(inst.selectedYear, inst.selectedMonth, 1))
        else
          set_up = true
      showButtonPanel: true


  $('.cantidad').click ->
    color = $('#color_all').val()
    $('.color_uniq').val color
    return
  
  # Nuevos campos para la tabla con las cantidades y colores
  $('.add_fields').on 'click',  (event) ->
  	time = new Date().getTime()
  	regexp = new RegExp($(this).data('id'), 'g')
  	$('#row_sp_color').attr 'rowspan', (i, rs) ->
      rs = parseInt rs
      rs + 1
      
  	newRowContent = '<tr>'+$(this).data('fields').replace(regexp, time)+'</tr>'
  	$(newRowContent).appendTo($("#table_form_lote"))
  	event.preventDefault()

  # Sumar las columnas 
  $('table').keyup '.cantidad1', ->
    sum = 0
    $('.cantidad1').each ->
        n = parseInt(@value)
        sum += n
    $('#total1').val String(sum)
    $('.total1').val String(sum)
    return
    
  $('table').keyup '.cantidad2', ->
    sum = 0
    $('.cantidad2').each ->
        n = parseInt(@value)
        sum += n
    $('#total2').val String(sum)
    $('.total2').val String(sum)
    return
    
  $('table').keyup '.cantidad3', ->
    sum = 0
    $('.cantidad3').each ->
        n = parseInt(@value)
        sum += n
    $('#total3').val String(sum)
    $('.total3').val String(sum)
    return
    
  $('table').keyup '.cantidad4', ->
    sum = 0
    $('.cantidad4').each ->
        n = parseInt(@value)
        sum += n
    $('#total4').val String(sum)
    $('.total4').val String(sum)
    return
    
  $('table').keyup '.cantidad5', ->
    sum = 0
    $('.cantidad5').each ->
        n = parseInt(@value)
        sum += n
    $('#total5').val String(sum)
    $('.total5').val String(sum)
    return
    
  $('table').keyup '.cantidad6', ->
    sum = 0
    $('.cantidad6').each ->
        n = parseInt(@value)
        sum += n
    $('#total6').val String(sum)
    $('.total6').val String(sum)
    return
    
  $('table').keyup '.cantidad7', ->
    sum = 0
    $('.cantidad7').each ->
        n = parseInt(@value)
        sum += n
    $('#total7').val String(sum)
    $('.total7').val String(sum)
    return
    
  $('table').keyup '.cantidad8', ->
    sum = 0
    $('.cantidad8').each ->
        n = parseInt(@value)
        sum += n
    $('#total8').val String(sum)
    $('.total8').val String(sum)
    return
    
  $('table').keyup '.cantidad9', ->
    sum = 0
    $('.cantidad9').each ->
        n = parseInt(@value)
        sum += n
    $('#total9').val String(sum)
    $('.total9').val String(sum)
    return

  # Sumar filas
  newSum = ->
    sum = 0
    thisRow = $(this).closest('tr')
    thisRow.find('td:not(.total, .color) :input[type="number"]').each ->
      sum += parseInt(@value)
      return
    thisRow.find('td.total :input[type="number"]').val sum
    return
  
  # Establecer precio total
  valPrecioT = ->
    precio_u = $("#lote_precio_u").val()
    cantidad = $("#lote_cantidad").val()
    total = parseInt(precio_u) * parseInt(cantidad)
    if isNaN(total) then total = 0
    $("#lote_precio_t").val(total)
  
  # Horas requeridas para terminar el lote
  valHReq = ->
    cantidad = $("#lote_cantidad").val()
    meta = $("#lote_meta").val()
    total = parseInt(cantidad) / parseInt(meta)
    total = Math.round total
    if isNaN(total) then total = 0
    $("#lote_h_req").val(total)
  
  $('table').keyup ->
    $('div input').each ->
      that = this
      newSum.call that
      valPrecioT()
      valHReq()
      return
    return
  
  $("#lote_precio_u").keyup ->
    valPrecioT()
    
  $("#lote_meta").keyup ->
    valHReq()
      
  # Impedir campos numéricos en blanco
  $(".numeric").keyup ->
      if @value.trim() == ''
        $(this).val 0
      return
    return



  # Reorganizamiento cuando la pantalla se encoge
  $(window).resize ->
    element = $("form div").first().children("div")
    if $(document).width() < 992
      element.first().addClass("text-center").removeClass("text-left")
      element.last().prev().removeClass("text-center").addClass("text-left pull-left")
      element.last().addClass("pull-right")
    else
      element.first().addClass("text-left").removeClass("text-center")
      element.last().prev().removeClass("text-left pull-left").addClass("text-center")
      element.last().removeClass("pull-right")


  return
  # Fin del document ready
  
$ ->
  $('.fa-trash-o').on 'ajax:success', (e, data, status, xhr) ->
    $(this).closest("tr").remove()

