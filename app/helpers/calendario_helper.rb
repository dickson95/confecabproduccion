module CalendarioHelper
  def color_event_extern(lote)
    return "bg-black-gradient" if lote.programacion_id.nil? && lote.ingresara_a_planta.nil?
    return "bg-red-gradient" if lote.programacion_id.nil?
    return "bg-aqua-gradient" if lote.ingresara_a_planta.nil?
  end
end
