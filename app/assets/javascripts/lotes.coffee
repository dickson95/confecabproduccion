# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  
  if !gon.rol_user
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
                      'targets': [ 6, 7 ]
                      'orderable': false
                    }
                  ]
  else
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
      responsive: true
      order: [[0, "desc"]]
      columnDefs:[
                    {
                      'targets': [ 0 ]
                      'visible': false
                      'searchable': false
                    }
                    {
                      'targets': [ 5, 6 ]
                      'orderable': false
                    }
                  ]
  
  $('.dataTables_filter label').after $('.dataTables_filter label input[type="search"]').detach()
  
  # Inputs con fecha administrada por parte de jQuery
  $("input.datepicker").each (i) ->
    $(this).datepicker
      dateFormat: "yy-mm-dd"
      altFieldTimeOnly: false
      altFormat: "yy-mm-dd"
      altField: $(this).next()
  
    
  $('.cantidad').click ->
    color = $('#color_all').val()
    $('.color_uniq').val color
    return
  
  # Nuevos campos para la tabla con las cantidades y colores
  $('.add_fields').on 'click',  (event) ->
  	time = new Date().getTime()
  	regexp = new RegExp($(this).data('id'), 'g')
  	$('#table_form_lote').children().children().find('#row_sp_color').attr 'rowspan', (i, rs) ->
      rs = parseInt rs
      rs + 1
      
  	newRowContent = '<tr>'+$(this).data('fields').replace(regexp, time)+'</tr>'
  	$(newRowContent).appendTo($("#table_form_lote"))
  	event.preventDefault()
  
  # Sumar las columnas 
  $('table').keyup '.cantidad1', ->
    sum = 0
    $('.cantidad1').each ->
      if @value.trim() == ''
        $(this).val 0
      else
        n = parseInt(@value)
        sum += n
      return
    $('#total1').val String(sum)
    $('.total1').val String(sum)
    return
    
  $('table').keyup '.cantidad2', ->
    sum = 0
    $('.cantidad2').each ->
      if @value.trim() == ''
        $(this).val 0
      else
        n = parseInt(@value)
        sum += n
      return
    $('#total2').val String(sum)
    $('.total2').val String(sum)
    return
    
  $('table').keyup '.cantidad3', ->
    sum = 0
    $('.cantidad3').each ->
      if @value.trim() == ''
        $(this).val 0
      else
        n = parseInt(@value)
        sum += n
      return
    $('#total3').val String(sum)
    $('.total3').val String(sum)
    return
    
  $('table').keyup '.cantidad4', ->
    sum = 0
    $('.cantidad4').each ->
      if @value.trim() == ''
        $(this).val 0
      else
        n = parseInt(@value)
        sum += n
      return
    $('#total4').val String(sum)
    $('.total4').val String(sum)
    return
    
  $('table').keyup '.cantidad5', ->
    sum = 0
    $('.cantidad5').each ->
      if @value.trim() == ''
        $(this).val 0
      else
        n = parseInt(@value)
        sum += n
      return
    $('#total5').val String(sum)
    $('.total5').val String(sum)
    return
    
  $('table').keyup '.cantidad6', ->
    sum = 0
    $('.cantidad6').each ->
      if @value.trim() == ''
        $(this).val 0
      else
        n = parseInt(@value)
        sum += n
      return
    $('#total6').val String(sum)
    $('.total6').val String(sum)
    return
    
  $('table').keyup '.cantidad7', ->
    sum = 0
    $('.cantidad7').each ->
      if @value.trim() == ''
        $(this).val 0
      else
        n = parseInt(@value)
        sum += n
      return
    $('#total7').val String(sum)
    $('.total7').val String(sum)
    return
    
  $('table').keyup '.cantidad8', ->
    sum = 0
    $('.cantidad8').each ->
      if @value.trim() == ''
        $(this).val 0
      else
        n = parseInt(@value)
        sum += n
      return
    $('#total8').val String(sum)
    $('.total8').val String(sum)
    return
    
  $('table').keyup '.cantidad9', ->
    sum = 0
    $('.cantidad9').each ->
      if @value.trim() == ''
        $(this).val 0
      else
        n = parseInt(@value)
        sum += n
      return
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
    $("#lote_precio_t").val(total)
  
  # Horas requeridas para terminar el lote
  valHReq = ->
    cantidad = $("#lote_cantidad").val()
    meta = $("#lote_meta").val()
    if meta > 0
      total = parseInt(cantidad) / parseInt(meta)
      total = Math.round total
    else
      total = 0
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
    
  # Validación del formulario
  $('#lote_referencia').keyup ->
    referencia = $('#lote_referencia')
    if referencia.val().trim() == ""
      $("#fa-check").remove()
      referencia.parent().parent().parent()
      .removeClass("has-error has-success has-feedback")
      .addClass("has-error has-feedback")
      referencia.parent()
      .append("<span id='fa-check' class='fa fa-times form-control-feedback'></span>")
    else
      $("#fa-check").remove()
      referencia.parent().parent().parent()
      .removeClass("has-error has-success has-feedback")
      .addClass("has-success has-feedback")
      referencia.parent()
      .append("<span id='fa-check' class='fa fa-check form-control-feedback'></span>")
      
  $("#lote_cliente_id").click ->
    cliente = $("#lote_cliente_id")
    if cliente.val().trim() == ""
      cliente.parent().removeClass("has-error has-success")
      .addClass("has-error")
      cliente.parent().children(".input-group-btn").children()
      .removeClass("btn-default btn-danger btn-outline btn-success")
      .addClass("btn-outline btn-danger")
    else
      cliente.parent().removeClass("has-error has-success")
      .addClass("has-success")
      cliente.parent().children(".input-group-btn").children()
      .removeClass("btn-default btn-danger btn-success")
      .addClass("btn-outline btn-success")
      
  return
  # Fin del document ready
  
 $ ->
  $('a[data-remote]').on 'ajax:success', (e, data, status, xhr) ->
