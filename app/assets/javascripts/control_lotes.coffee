# Funciones que son manejadas directamente por el controlador de control_lotes
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

  $(".control_lotes").on("ajax:success", "form[data-remote]", (e, data, status, xhr)->
    $.floatingMessage "Dato registrado", {
      position: "bottom-right"
      height: 50
      width: 130
      time: 4000
      className: "ui-state-active"
    }
  ).on("ajax:error", "form[data-remote]", (e, xhr, status, error) ->
      input = $(this).find("input[type='number']")
      parent = input.parent().parent()
      parent.find("span.help-block").remove()
      parent.children().addClass("has-error")
      input.next().children().removeClass("btn-default btn-primary").addClass("btn-danger")
      parent.append("<span class='help-block text-red'></span>")
      span = parent.find("span.help-block")
      $.each xhr.responseJSON.cantidad, (i, v)->
        span.append(v + "<br>")
  )

return