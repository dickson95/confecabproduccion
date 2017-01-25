module ClientesHelper
  def fields(name, f, association, classe=nil)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |relation|
      render(association.to_s+"/"+association.to_s.singularize + "_fields", f: relation)
    end
    link_to(name, '', class: "add_fields #{classe}", data: { id: id, fields: fields.gsub("\n", "")})
  end

  def first_telefono(contactos)
    if contactos.any?
      contactos.each do |c|
        $tel = c.telefonos.first
        $tel = $tel ? $tel.telefono : "-"
      end
      $tel
    else
      "-"
    end
  end

  def first_extension(contactos)
    if contactos.any?
      contactos.each do |c|
        puts c.class
        $ext = c.telefonos.first
        $ext = tel.extensiones.first if $ext
        $ext = $ext ? $ext.extension : "-"
      end
      $ext
    else
      "-"
    end
  end

  def first_correo(contactos)
    if contactos.any?
      contactos.each do |c|
        $email = c.correos.first
        $email = $email ? $email.correo : "-"
      end
      $email
    else
      "-"
    end
  end

  def spans(objects, attr)
    spans = ""
    show_first = false
    if objects.any?
      objects.each do |o|
        $options = ({class: "hide"} if show_first)
        puts $options
        spans += span o.public_send(attr), $options
        show_first = true
      end
    else
      spans = "-"
    end
    spans.html_safe
  end

  def span(content, options={})
    content_tag :span, content, options
  end

  # Retorna true en caso de que un objeto sí tenga la relación indicada
  def has_relation?(object, relation)
    object.reflect_on_all_associations.each do |rel|
      return true if rel.name.to_s == relation
    end
    false
  end
end
