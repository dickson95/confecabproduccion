module CalendarioHelper
  def color_event_extern(lote)
    return "bg-black" if lote.programacion_id.nil? && lote.ingresara_a_planta.nil?
    return "bg-red" if lote.programacion_id.nil?
    return "bg-aqua" if lote.ingresara_a_planta.nil?
  end
end
