$(document).on "ready", ->
		target = if gon.clientes then [ 0, 1, 3, 4, 5 ] else [ 2..4 ]
		$('#clientes').DataTable
      language:
        lengthMenu: 'Mostrar _MENU_ registros'
        search: 'Buscar&nbsp;:'
        info: 'Resultados _START_ a _END_ de _TOTAL_ '
        infoEmpty: 'No hay datos o intente de nuevo'
        infoFiltered: '(filtrado de _MAX_ registros)'
        infoPostFix: ''
        zeroRecords: 'No se encuentran registros'
        emptyTable: 'No hay datos disponibles'
        paginate:
          previous: 'Anterior'
          next: 'Siguiente'
      order: [[2, "desc"]]
      columnDefs:[
                    {
                      'targets': target
                      'orderable': false
                    }
                  ]
    $("#clientes").parent().addClass("table-responsive")
  return
