module ClientesHelper
  def fields_one(name, f, association, classe=nil)
    new_object = association.to_s.camelize.constantize.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |relation|
      render(association.to_s.pluralize+"/"+association.to_s.singularize + "_fields", f: relation)
    end
    link_to(name, '', class: "add_fields #{classe}", data: { id: id, fields: fields.gsub("\n", "")})
  end

  def fields(name, f, association, classe=nil)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |relation|
      render(association.to_s+"/"+association.to_s.singularize + "_fields", f: relation)
    end
    link_to(name, '', class: "add_fields #{classe}", data: { id: id, fields: fields.gsub("\n", "")})
  end


  # Determina el tamaño del rowspan en el número de teléfono en la tabla de detalles de los clientes
  def rowspan_count(extensiones)
    exten = extensiones.count
    corre = count_correos_from_cliente(extensiones)
    ret = exten > corre ? exten : corre
  end

  def count_correos_from_cliente(extensiones)
    result = 0
    extensiones.each do |ext|
      count = correos_from_conta_count ext.contacto
      result +=  count < 1 ? 0 : count
    end
    result
  end

  # Cuenta los correos que un contacto tiene
  def correos_from_conta_count(contacto)
    contacto_any(contacto).correos.count
  end

  def tel_count(contacto)
    contacto.telefonos.count
  end

  def correo_count(contacto)
    contacto.correos.count
  end


  def first_ext(telefono)
    ext = first_ext_from_tel(telefono)
  end

  def tel_any(tel)
    tel || Telefono.new
  end

  def ext_eny(ext)
    ext || Extension.new
  end

  def contacto_any(conta)
    conta || Contacto.new
  end

  def correo_any(correo)
    correo || Correo.new
  end

  def first_ext_from_tel(telefono)
    tel = tel_any(telefono)
    ext_eny tel.extensiones.first
  end

  def first_telefono(telefonos)
    if telefonos.any?
      telefonos.first.telefono
    else
      "-"
    end
  end

  def first_contacto(telefonos)
    ext = first_ext_from_tel(telefonos.first)
    contacto_any ext.contacto
  end

  def first_correo(telefonos)
    if telefonos.any?
      exts = telefonos.first.extensiones
      conts = exts.first.contacto if exts.any?
      correos = conts.correos if conts
      corr = correos.first if correos
      corr = corr ? corr.correo : "-"
      corr
    end
  end
end
