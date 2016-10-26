module LotesHelper
    def link_to_add_fields(name, clase = nil, f, association)
        new_object = f.object.send(association).klass.new
        id = new_object.object_id
        fields = f.fields_for(association, new_object, child_index: id) do |colores_lotes_for_form|
          render( partial: association.to_s.singularize + "_fields", locals:{
              f: colores_lotes_for_form, b: true, col:"", total:""})
        end
        link_to name, '', class: "#{clase}", 
        data: { id: id, fields: fields.gsub("\n", "")}, :title => "Más cantidades"
    end

    def date_form_value(lote)
        if !@lote.programacion.nil?
            I18n::localize(@lote.programacion.mes, :format => "%B %Y")
        end
    end

    # Cambio de estados. Las opciones son todas las disponibles en el helper link_to
    def next_state(route, state, link_to_options=nil, content_tag_options=nil, options=nil)
        state_final = nil
        men = nil
        boolean = true
        case state.to_i
          when 1
            state_final = 2
            men = {:view => 'Integrar'}
          when 2
            state_final = 3
            men = {:view =>'Confeccionar', :controller => "integración"}
          when 3
            state_final = 4
            men = {:view => 'Terminar', :controller => "confección"}
          when 4
            state_final = 5
            men = {:view => 'Completar', :controller => "terminación"}
          when 5
            boolean = false
            state_final = 6
            men = {:controller => "completado"}
          else
            boolean = false
            men = ""
        end
        if boolean && params[:action] != "cambio_estado"
            link_to_options[:title] = men
            link_to "#{route}?btn=#{state_final}", link_to_options do
                content_tag(:i, "", content_tag_options).html_safe + men[:view]
            end
        elsif params[:action] == "cambio_estado"
            {:message => men[:controller], :state => state_final - 1}
        end
    end
end
