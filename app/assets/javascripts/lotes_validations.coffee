$(document).on "ready", ->
  $("#lote_op").keyup ->
    value = $(this).val()
    this_op = $(this)
    lote_id = $(this).closest("form").data("lote-id")
    $.post(
      "/lotes/" + lote_id + "/validate_op",
      {
        op: value
      },
      (data, status, xhr) ->
        div = this_op.closest("div")
        div.find(".help-block").remove()
        if !data
          div.addClass("has-error")
          div.append("<span class='help-block'>Ya existe esta OP</span>")
        else
          div.removeClass("has-error")
    )
    return
return