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
end
