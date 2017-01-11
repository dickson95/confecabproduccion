# Funciones que son manejadas únicamente por el controlador de los lotes
$(document).on "ready", ->
  $("input.cantidades").on("focus", ->
    if $(this).val().trim() == "0"
      $(this).val("")
  ).focusout ->
    $(this).popover("hide")
    if $(this).val().trim() == ""
      $(this).val("0")

  $("input.cantidades").on "keyup", ->
    $(this).attr("data-placement", "left")
    cantidad = $(this).val()
    control_id = $(this).data("control-id")
    input = $(this)
    $.ajax(
      url: "control_lotes/" + control_id + "/update_cantidad"
      data: {control_lote: {cantidad: cantidad}}
      type: "PATCH"
      success: (data, status, xhr) ->
        if data.after != null
          input.attr("data-content", data.after)
          input.popover("show")
        else
          input.popover("hide")
        $("#cantidad_proceso").text(data.total)
    )
    return


  $("form[data-remote]").on("ajax:success", (e, data, status, xhr)->
    $.floatingMessage "Dato registrado", {
      position: "bottom-right"
      height: 50
      width: 130
      time: 4000
      className: "ui-state-active"
    }
  ).on("ajax:error", (e, xhr, status, error) ->
    mess = ""
    $.each xhr.responseJSON.cantidad, (i, v)->
      m =  v + "<br>"
      mess = mess + m

    mess = mess + "<br> Click para cerrar"
    $.floatingMessage mess, {
      position: "bottom-right"
      height: 80
      className: "ui-state-error"
    }
  )
return