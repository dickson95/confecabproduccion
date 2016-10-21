# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on "turbolinks:load", ->
		$("div[data-company]").on "click", ->
				company = $(this).data("company")
				window.location.href="/lotes?company="+company
			return
	return