$(document).on "turbolinks:load", ->
		format_price_u = undefined
		$("#lotes input.lote_precio_unitario").each (e) ->
			$(this).on "focus", ->
				if $(this).val() == "$0.00"
					$(this).val("")
			
			$(this).on("keyup", ->
				id = $(this).data("lote")
				amount = $(this).closest("tr").find("td[data-cantidad]").data("cantidad")
				unit_price = $(this).val()
				if unit_price.trim() == ""
					unit_price = 0
				input = $(this)
				$.post("/lotes/"+id+"/total_price",{
					lote: {
						amount: amount,
						unit_price: unit_price
					}
				}, 
				(data, status) ->
					input.closest("tr").find("td.total").text(data['total'])	
					format_price_u = data['unit']
				)
			).focusout ->
				if $(this).val().trim() == ""
					$(this).val("$0.00")
				else
					$(this).val(format_price_u)
				
	return
	# "Fin document turbolinks:load"