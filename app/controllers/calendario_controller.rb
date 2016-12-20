class CalendarioController < ApplicationController
  def index
    gon.lote = Lote.limit 2
    @lotes = Lote.where("(ingresara_a_planta IS NULL OR programacion_id IS NULL) AND empresa = ?", company )
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
end
