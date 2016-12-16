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

	def set_date(date, format)
		I18n::localize(date, format: format) if !date.nil?
	end
end
