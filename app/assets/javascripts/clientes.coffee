$(document).on "ready", ->
  $("body.clientes").on 'click', '.remove_fields', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault()

  $("body.clientes").on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()

		target = if gon.clientes then [ 0, 1, 3, 4, 5 ] else [ 1..3 ]
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
