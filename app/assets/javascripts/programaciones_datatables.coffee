$(document).on "ready", ->
  table_current = undefined
  build_datatable = (element) ->
    table_current.destroy() if table_current
    table_current = $(element).DataTable
      language:
        lengthMenu: 'Mostrar _MENU_ registros'
        search: 'Buscar&nbsp;:'
        info: 'Resultados _START_ a _END_ de _TOTAL_ '
        infoEmpty: 'No hay datos o intente de nuevo'
        infoFiltered: '(filtrado de _MAX_ registros)'
        infoPostFix: ''
        zeroRecords: 'No se encuentran registros'
        emptyTable: 'No hay datos disponibles'
      paging: false
      order: [[2, "asc"]]
      columnDefs: [
        {
          targets: [0, 1]
          orderable: false
        }
      ]
    $(element).parent().addClass("table-responsive")

  bind_datatable = ->
    selector = $("div.box-body > div.tab-content > div.active").find(".active table")
    table = "#" + selector.attr("id")
    build_datatable(table)

  reload_datatables = ->
    table = $("div.box-body > div.tab-content > div.active").find(".active table")
    if table.find("#row_generate").length < 1
      bind_datatable()

  bind_datatable()

  $("body").on "ajax:success", "a[data-remote], form[data-remote]", (e, data, status, xhr) ->
    reload_datatables()

  $("li.year").click ->
    id = $(this).children().attr("href")
    table = $(id).find(".active").attr("id")
    console.log table
    build_datatable("#"+table+"t")





return