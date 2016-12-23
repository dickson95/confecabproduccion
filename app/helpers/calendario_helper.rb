module CalendarioHelper
  def color_event_extern(lote)
    return "bg-black" if lote.programacion_id.nil? && lote.ingresara_a_planta.nil?
    return "bg-red" if lote.programacion_id.nil?
    return "bg-aqua" if lote.ingresara_a_planta.nil?
  end

  def color_row(state)
    case state
      when 1; "#d2d6de"
      when 2; "#3c8dbc"
      when 3; "#d33724"
      when 4; "#ff7701"
      when 5; "#008d4c"
    end
  end
end
