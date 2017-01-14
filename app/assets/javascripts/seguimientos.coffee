# Funciones que se realizan en la vista de control_lotes o de seguimientos.
# Si se ejecutan en la vista de seguimientos es porque la acción es administrada principalmente por el controlador y
# el modelo que corresponde a Seguimiento

$(document).on "ready", ->
  $("table").on "ajax:success", "form[data-remote]", (e, data, status, xhr) ->
    # Celda de arriva del formulario que se cambia
    $(this).closest("tr").prev().children("td").last().find("span").text(data.seg_prev.cantidad)
    $(this).closest("td").find("span").text(data.seguimiento.cantidad)
    $(this).find("input").val('')
