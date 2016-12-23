class CalendarioController < ApplicationController
  def index
    @estados = Estado.all
    @lotes = Lote.where("(ingresara_a_planta IS NULL OR programacion_id IS NULL) AND empresa = ?", company)
                 .order("programacion_id desc, secuencia asc")
    respond_to do |format|
      format.html
      format.json { render json: lotes_calendar }
    end
  end

  private
  def company
    @company = session[:selected_company] ? "CAB" : "D&C"
  end

  def lotes_calendar
    lotes = Lote.select(:id, :referencia_id, :ingresara_a_planta, :secuencia).where("(programacion_id IS NOT NULL AND ingresara_a_planta IS NOT NULL)
                  AND ingresara_a_planta BETWEEN ? AND ?", params[:start], params[:end])
    lotes_to_json_calendar(lotes)
  end

  def lotes_to_json_calendar(lotes)
    events = Array.new
    lotes.each do |lote|
      sec = lote.secuencia
      id = lote.id
      color = lote.control_lotes.last.estado.color
      events.push(
          {
              id: id,
              title: "#{lote.referencia.referencia} #{ "Sec: #{sec}" if sec}",
              start: lote.ingresara_a_planta,
              backgroundColor: color,
              borderColor: color,
              'data-url': view_context.update_programacion_lote_path(id)
          }
      )
    end
    events
  end
end
