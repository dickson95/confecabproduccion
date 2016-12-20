class CalendarioController < ApplicationController
  def index
    @lotes = Lote.where("(ingresara_a_planta IS NULL OR programacion_id IS NULL) AND empresa = ?", company)
    respond_to do |format|
      format.html
      format.json { render json: lotes_calendar }
    end
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def company
    @company = session[:selected_company] ? "CAB" : "D&C"
  end

  def lotes_calendar
    lotes = Lote.joins(:referencia).where("(programacion_id IS NOT NULL AND ingresara_a_planta IS NOT NULL)
                  AND ingresara_a_planta BETWEEN ? AND ?", params[:start], params[:end])
                .pluck("lotes.id", "referencias.referencia", "ingresara_a_planta")
    lotes_to_json_calendar(lotes)
  end

  def lotes_to_json_calendar(lotes)
    events = Array.new
    lotes.each do |lote|
      events.push(
          {
              title: lote.fetch(1),
              start: lote.fetch(2)
          }
      )
    end
    events
  end
end
