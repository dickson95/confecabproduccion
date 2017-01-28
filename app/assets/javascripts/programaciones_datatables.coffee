### Crear un array con los valores de los input de una columna y parsear (convertir) a números ###
$.fn.dataTable.ext.order['dom-text-numeric'] = (settings, col) ->
  @api().column(col, order: 'index').nodes().map (td, i) ->
    $('input', td).val() * 1


$(document).on "ready", ->
  update_foot = (data)->
    foot = $("tfoot div");
    foot.find(".total_unities").html(data.unidades);
    foot.find(".prices").html(data.precio_total);

  ###  Definir que con base a los permisos qué coluna es la que define el orden principal ###
  columns = ->
    remover = $("info").data("remove")
    reorder = $("info").data("reorder")
    prices = $("info").data("prices")
    order_numeric = {"orderDataType": "dom-text-numeric"}
    targets =
      if remover && reorder && prices
        [null, null, order_numeric, null, null, null, null, null, null, null, null, null]
      else if !remover && !reorder && prices
        [null, null, null, null, null, null, null, null, null, null, null]
      else if remover && reorder && !prices
        [null, null, order_numeric, null, null, null, null, null, null, null]
      else
        [null, null, null, null, null, null, null, null, null]

    return targets

  orders = ->
    remover = $("info").data("remove")
    reorder = $("info").data("reorder")
    prices = $("info").data("prices")
    if remover && reorder && prices
      return [[11, "asc"]]
    else if !remover && !reorder && prices
      return [[9, "asc"]]
    else
      return [[8, "asc"]]

  table_current = undefined
  build_datatable = (element) ->
    col = columns()
    orders_c = orders()
    table_current.destroy() if table_current
    # identificador con las columnas que deben tener ciertas clases
    target = $("#target")
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
      order: orders_c
      columns: col
      columnDefs: [
        {
          className: "state",
          targets: target.data("state")
        },
        {
          className: "no-padding",
          targets: target.data("no-padding")
        },
        {
          targets: [0]
          orderable: false
        }
      ]

    $(element).parent().addClass("table-responsive")

  bind_datatable = ->
    selector = $("div.box-body > div.tab-content > div.active").find(".active table")
    if selector.find("#row_generate").length < 1
      table = "#" + selector.attr("id")
      build_datatable(table)

  reload_datatables = ->
    bind_datatable()

  bind_datatable()

  new_rows_datatables = (data)->
    $.each data.rows, (id, lote) ->
      rowNode = table_current.row.add(lote.row).draw().node()
      $(rowNode).attr("data-item-id", id).addClass("item").css("background-color", lote.color_claro)
      $(rowNode).find(".state").css("background-color", lote.color)
    disable_active_buttons(data)

  disable_active_buttons = (data)->
    add = $("#add-lote")
    manage = $(".disabled-btn")
    if data.add
      add.removeClass("disabled").removeAttr("disabled")
      add.unbind('click', false)
    else
      add.addClass("disabled")
      add.bind('click', false)

    if data.no_manage
      manage.addClass("disabled")
      manage.bind('click', false)
    else
      manage.removeClass("disabled").removeAttr("disabled")
      manage.unbind('click', false)

  body = $("body")

  ###
  Retirar: De acuerdo al valor del botón del submit se remueve la fila para
  ###
  body.on "submit", "form[data-remote]", ->
    val = $("input[type=submit][clicked=true]").val()
    if val == "Retirar"
      $(this).on "ajax:success", (e, data, status, xhr) ->
        $.each data.rows, (id, lote) ->
          table_current.row($("tr[data-item-id=" + id + "]")).remove()
        update_foot(data)
        disable_active_buttons(data)

  body.on "click", "form input[type=submit]", ->
    $("input[type=submit]", $(this).parents("form")).removeAttr("clicked")
    $(this).attr("clicked", "true");


  body.on("click", "#generate_programacion", (e)->
    $this = $(this)
    $.ajax(
      url: $this.data("url")
      type: "PATCH"
      dataType: "JSON"
      beforeSend: (xhr, settings)->
        load_state = '<div class="overlay"><i class="fa fa-refresh fa-spin"></i></div>'
        $this.closest("body").find("div.box").append(load_state)
      success: (data, status, xhr)->
        $this.closest("tr").remove()
        reload_datatables()
        new_rows_datatables(data)
      complete: (xhr, status) ->
        $("div.box .overlay").remove()
    )
    return false
  )

  ###
  Cuando se cambian las pestañas u ordenan los lotes en la programación
  ###
  body.on "ajax:success", "a[data-remote], form[data-remote]", (e, data, status, xhr) ->
    reload_datatables()

  $("li.year").click ->
    id = $(this).children().attr("href")
    table = $(id).find(".active").attr("id")
    build_datatable("#" + table + "t")

  ###
  Al añadir nuevos lotes
  ###
  body.on "ajax:success", "#new_lotes_to_programacion", (e, data, status, xhr)->
    selector = $("div.box-body > div.tab-content > div.active").find(".active table")
    row_generate = selector.find("#row_generate")
    if row_generate.length > 0
      row_generate.remove()
      bind_datatable()
    new_rows_datatables(data)
    $("#myModal").modal("toggle")
    update_foot(data)

  ###
  Cuando se hace el cambio de estado
  ###
  body.on "ajax:success", ".change", (e, data, status, xhr)->
    lote_id = data.lote.id
    row = $("tr[data-item-id=" + lote_id + "]")
    row.removeAttr("style").css("background-color", data.estado.color_claro)
    row.find(".state").removeAttr("style").css("background-color", data.estado.color)
    $.ajax(
      url: "programaciones/get_row"
      data: {lote_id: lote_id}
      dataType: "json"
      success: (data, status, xhr)->
        $.each data.rows, (id, lote)->
          table_current.row(row).data(lote.row)
    )
    $.floatingMessage data.message, {
      position: "bottom-right"
      height: 80
      time: 4000
      className: "ui-state-active"
    }


return