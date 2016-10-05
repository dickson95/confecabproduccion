$(document).on "turbolinks:load", ->
	# Cambiar la clase active entre las pestañas y la carga de los datos
	$("ul.nav-tabs a").click (e)->
		e.preventDefault()
		$(this).closest("ul").find(".active").removeClass("active")


	# Ancho de las columnas mientras es arrastrada la fila
	fixHelper = (e, ui) ->
	  ui.children().each ->
	    $(this).width $(this).width()
	    return
	  ui

	fix_update = (e, ui) ->
    item_id = ui.item.data('item-id')
    array = []
    table = "#"+$(this).attr("id")
    $(table+" > tbody > tr").each (i) ->
      array.push
        lote_id: $(this).data('item-id')
        position: $(this).index() + 1
      return
    position = ui.item.index() # this will not work with paginated items, as the index is zero on every page
    $.ajax(
      type: 'POST'
      url: '/programaciones/update_row_order'
      dataType: 'json'
      data: { programacion: {updated_positions: array} }
    )
	

	# Sortable para las tablas de la programación
	$ ->
	  if $('.sortable').length > 0
	    array = new Array  

	    $('.sortable').sortable(
	      axis: 'y'
	      items: '.item'
	      cursor: 'move'
	      helper: fixHelper

	      sort: (e, ui) ->
	        ui.item.addClass('active-item-shadow')

	      stop: (e, ui) ->
	        ui.item.removeClass('active-item-shadow')
	        # Resalta la fila indicada en la actualización
	        ui.item.children('td').effect('highlight', {}, 1000)

	      update: fix_update
	    )


	# nav tabs responsive
	tab = $(".tab-content").find(".nav-tabs")
	if $(document).load 
		if $(document).width() < 1263
			tab.removeClass("nav-justified")
		else
			tab.addClass("nav-justified")

	$(window).resize ->
		if $(document).width() < 1263
			tab.removeClass("nav-justified")
		else
			tab.addClass("nav-justified")

return
