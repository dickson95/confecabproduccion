$(document).on 'ready', ->
  $('#sub_estados').DataTable
      language:
        processing: 'Cargando...'
        lengthMenu: 'Mostrar _MENU_ registros'
        search: 'Buscar&nbsp;:'
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
  $('#sub_estados').parent().addClass('table-responsive')
  $('.dataTables_filter label').after $('#sub_estados_filter label input[type="search"]').detach()
  return
