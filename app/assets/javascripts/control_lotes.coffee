# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  $('#control').DataTable
    'lengthMenu': [
      15
      25
      50
      100
    ]
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
    responsive: details: false
  return