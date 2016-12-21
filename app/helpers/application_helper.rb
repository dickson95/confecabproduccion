module ApplicationHelper
	def name_flash(flash)
		if flash.eql?("notice")
			"info"
		elsif flash.eql?("alert")
			"warning"
		else
			flash
		end
	end

	# Definir cual es el enlace que debe quedar activo
	def active_navigation(link_path)
	  current_page?(link_path) ? 'active' : ''
	end

	def name_company_logo
		session[:selected_company] ? "CAB" : "D&C"
	end

	def color_row(state, strong)
		case state
			when 1; strong ? "bg-gray" : "active"
			when 2; strong ? "bg-light-blue": "info"
			when 3; strong ? "bg-red-active": "danger"
			when 4; strong ? "bg-orange-active": "warning"
			when 5; strong ? "bg-green-active": "success"
		end
	end
end
