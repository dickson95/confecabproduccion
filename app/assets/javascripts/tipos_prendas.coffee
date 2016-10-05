# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  
  if !gon.rol_user
    $('#t_clientes').DataTable
      'scrollY': '400px'
      'paging': false
      language:
        processing: 'Cargando...'
        search: 'Buscar&nbsp;:'
        info: 'Resultados _START_ a _END_ de _TOTAL_ '
        infoEmpty: 'No hay datos o intente de nuevo'
        infoFiltered: '(filtrado de _MAX_ registros)'
        infoPostFix: ''
        loadingRecords: 'Cargando...'
        zeroRecords: 'No se encuentran registros'
        emptyTable: 'No hay datos disponibles'
      columnDefs:[
                    {
                      'targets': [ 1..4 ]
                      'orderable': false
                    }
                  ]
  else
    $('#t_clientes').DataTable
      'scrollY': '400px'
      'scrollCollapse': true
      'paging': false
      language:
        processing: 'Cargando...'
        search: 'Buscar&nbsp;:'
        info: 'Resultados _START_ a _END_ de _TOTAL_ '
        infoEmpty: 'No hay datos o intente de nuevo'
        infoFiltered: '(filtrado de _MAX_ registros)'
        infoPostFix: ''
        loadingRecords: 'Cargando...'
        zeroRecords: 'No se encuentran registros'
        emptyTable: 'No hay datos disponibles'
      columnDefs:[
                    {
                      'targets': [ 1..3 ]
                      'orderable': false
                    }
                  ]
  $('.dataTables_filter label').after $('#t_clientes_filter label input[type="search"]').detach()
  $('.tablas2').DataTable
      'scrollY': '190px'
      'scrollCollapse': true
      'paging': false
      language:
        processing: 'Cargando...'
        search: 'Buscar&nbsp;:'
        info: 'Resultados _START_ a _END_ de _TOTAL_ '
        infoEmpty: 'No hay datos o intente de nuevo'
        infoFiltered: '(filtrado de _MAX_ registros)'
        infoPostFix: ''
        loadingRecords: 'Cargando...'
        zeroRecords: 'No se encuentran registros'
        emptyTable: 'No hay datos disponibles'  
        
  $('#DataTables_Table_0_filter label').after $('#DataTables_Table_0_filter label input[type="search"]').detach()
  $('#DataTables_Table_1_filter label').after $('#DataTables_Table_1_filter label input[type="search"]').detach()
  
  $('#on_cliente').on 'click', ->
    #muestra solo el pánel de referencias
    $('#tip_est').slideUp 600 
    $('#p_clientes').show 600
    return
  $('#on_prenda').on 'click', ->
    # Muestra solo el pánel para las prendas
    $('#p_estados').hide 600
    $('#p_tipos_prendas').removeClass().addClass 'col-lg-12 page-header'
    $('#p_tipos_prendas').show 600
    $('#p_clientes').hide 600
    $('#tip_est').show 600
    
    $('#p_referencias').hide(400).removeClass()
    
    $('#p_clientes').hide 400
    return
  $('#on_proceso').on 'click', ->
    # Muestra solo el pánel para los procesos
    $('#p_estados').removeClass().addClass 'col-lg-12 page-header'
    $('#p_estados').show 600
    $('#p_tipos_prendas').hide 600
    $('#p_clientes').hide 600
    $('#tip_est').show 600
    return
  $('#all').on 'click', ->
    # Muestra todos los paneles
    $('#p_clientes').show 600
    $('#p_estados').removeClass().addClass 'col-lg-6 page-header'
    $('#p_tipos_prendas').removeClass().addClass 'col-lg-6 page-header'
    $('#p_estados').show 600
    $('#p_tipos_prendas').show 600
    $('#tip_est').show 600
    
    return
  return