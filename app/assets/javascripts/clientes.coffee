$(document).on "ready", ->
  $("body.clientes").on 'click', '.remove_fields', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    fieldset = $(this).closest('fieldset')
    next = fieldset.next()
    if next.parent().data("one")
      next.show()
    fieldset.remove()

    event.preventDefault()

  $("body.clientes").on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    parent = $(this).parent()
    if parent.data("one")
      $(this).hide()
    event.preventDefault()

  target = if gon.clientes then [0, 1, 2, 6, 7, 9, 10] else [0, 4, 5, 7, 8]
  order = if gon.clientes then [[4, "desc"]] else [[2, "desc"]]
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
    order: order
    paging: false
    columnDefs: [
      {
        'targets': target
        'orderable': false
      }
    ]
    $("#clientes").parent().addClass("table-responsive")
  return
