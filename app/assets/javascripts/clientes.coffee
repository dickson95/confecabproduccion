$(document).on "ready", ->
		target = if gon.clientes then [ 1..4 ] else [ 1..3 ]
		$('#clientes').DataTable
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
      columnDefs:[
                    {
                      'targets': target
                      'orderable': false
                    }
                  ]
    $("#clientes").parent().addClass("table-responsive")
  return
