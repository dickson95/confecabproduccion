class Util
  # Convertir string a boolean
  def to_boolean(str)
    str == "true"
  end

  # hyphen = Guion. Determina si el atributo está nil par entonces retornar un guion en vez de una cadena vacía
  def hyphen_or_string(str)
    str ? str : "-"
  end
end