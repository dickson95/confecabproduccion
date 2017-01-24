$(document).on "ready", ->
  # Para eliminar un registro de una tabla solo hay que agregarle data-remote=true y data-action=delete.
  # Esto retira la fila de la tabla después de eliminar el registro.
  $("body").on("ajax:success", "a[data-action='delete']", (e, data, status, xhr)->
    $(this).closest("tr").remove()
    $.floatingMessage data.message || "Registro eliminado con éxito", {
      position: "bottom-right"
      height: 80
      time: 4000
      className: "ui-state-active"
    }
    $(this).closest("body").find("div.box .overlay").remove()
  ).on("ajax:error", "a[data-action='delete']", (e, xhr, status, error) ->
    $.floatingMessage xhr.responseText || "Ocurrión un error", {
      position: "bottom-right"
      height: 80
      time: 6000
      className: "ui-state-error"
    }
    $(this).closest("body").find("div.box .overlay").remove()
  )