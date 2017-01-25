module ClientesHelper

  def first_telefono(contactos)
    if contactos.any?
      contactos.each do |c|
        tel = c.telefonos.first
        tel ? tel.telefono : "-"
      end
    else
      "-"
    end
  end

  def first_extension(contactos)
    if contactos.any?
      contactos.each do |c|
        tel = c.telefonos.first
        $ext = tel.extensiones.first if tel
        $ext ? ext.extension : "-"
      end
    else
      "-"
    end
  end

  def first_correo(contactos)
    if contactos.any?
      contactos.each do |c|
        email = c.correos.first
        email ? email.correo : "-"
      end
    else
      "-"
    end
  end

  def spans(objects, attr)
    spans = "-"
    show_first = true
    if objects.any?
      objects.each do |o|
        $options = {class: "hide"} if show_first
        spans += span o.public_send(attr), $options
        show_first = false
      end
    end
    spans
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
