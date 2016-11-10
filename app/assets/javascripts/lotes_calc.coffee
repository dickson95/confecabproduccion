$(document).on "turbolinks:load", ->
		format_price_u = undefined
		$("tbody").on "click focus", "tr > td > input.lote_precio_unitario", ->
			if $(this).val() == "$0.00"
				$(this).val("")
		
		$("tbody").on("click keyup", "tr > td > input.lote_precio_unitario", ->	
			unit_price = $(this).val()
			id = $(this).data("lote")
			amount = $(this).closest("tr").find("td[data-cantidad]").data("cantidad")
			if unit_price.trim() == ""
				unit_price = 0
			input = $(this)
			$.ajax(
				type: "PATCH"
				url: "/lotes/"+id+"/total_price",
				data: { lote: { amount: amount, unit_price: unit_price } }, 
				success: (data, status) ->
					input.closest("tr").find("td.total").text(data['total'])	
					format_price_u = data['unit']
			)
		).on "focusout", "input.lote_precio_unitario", ->
			if $(this).val().trim() == ""
				$(this).val("$0.00")
				format_price_u = undefined
			else if format_price_u != undefined
				$(this).val(format_price_u)
				format_price_u = undefined
	return
	# "Fin document turbolinks:load"