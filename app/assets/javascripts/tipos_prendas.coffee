# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  $('#tipos').DataTable
      language:
        processing: 'Cargando...'
        lengthMenu: 'Mostrar _MENU_ registros'
        search: 'Buscar&nbsp;:'
        info: 'Resultados _START_ a _END_ de _TOTAL_ '
        infoEmpty: 'No hay datos o intente de nuevo'
        infoFiltered: '(filtrado de _MAX_ registros)'
        loadingRecords: 'Cargando...'
        zeroRecords: 'No se encuentran registros'
        emptyTable: 'No hay datos disponibles' 
        paginate:
          previous: 'Anterior' 
          next: 'Siguiente'
  $('#tipos').parent().addClass('table-responsive')
  $('.dataTables_filter label').after $('#tipos_filter label input[type="search"]').detach()
  return