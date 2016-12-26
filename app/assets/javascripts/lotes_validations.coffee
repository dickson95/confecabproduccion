$(document).on "ready", ->
  $("#lote_op").keyup ->
    $this = $(this)
    value = $this.val()
    $.post(
      $this.data("url"),
      {
        op: value
      },
      (data, status, xhr) ->
        div = $this.closest("div")
        div.find(".help-block").remove()
        if !data
          div.addClass("has-error")
          div.append("<span class='help-block'>Ya existe esta OP</span>")
        else
          div.removeClass("has-error")
    )
    return
return