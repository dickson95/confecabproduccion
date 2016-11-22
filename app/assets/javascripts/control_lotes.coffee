$(document).on "turbolinks:load", ->
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
				url: "control_lotes/"+control_id+"/update_cantidad"
				data: { control_lote: { cantidad: cantidad }}
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
	return