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
	def nav_link(link_text, link_path, link_to_options=nil, content_tag_options=nil)
	  class_name = current_page?(link_path) ? 'active' : ''
	  link_to_options[:class] = "#{class_name} #{link_to_options[:class]}"
	  content_tag  :li do
		  link_to link_path, link_to_options do
		  	content_tag(:i,"", content_tag_options).html_safe + " #{link_text}"
		  end
		end
	end
end
