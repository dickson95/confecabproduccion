# Funciones que se realizan en la vista de control_lotes o de seguimientos.
# Si se ejecutan en la vista de seguimientos es porque la acción es administrada principalmente por el controlador y
# el modelo que corresponde a Seguimiento

$(document).on "ready", ->
  $("table").on "ajax:success", "form[data-remote]", (e, data, status, xhr) ->
    # Celda de arriva del formulario que se cambia
    $(".popover").popover("hide")
    tr_prev = $(this).closest("tr").prev()
    tr_prev.children("td").last().find("span").text(data.seg_prev.cantidad)
    tr_prev.find("td[data-date]").text(data.date_range)
    $(this).closest("td").find("span").text(data.seguimiento.cantidad)
    $(this).find("input").val('')
    $()

  $("body.control_lotes").on "click", "span[data-action='close']", ->
    $(".popover").popover("hide")
