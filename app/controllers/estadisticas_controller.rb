class EstadisticasController < ApplicationController
  def index
    company = session[:selected_company] ? "CAB" : "D&C"
    time = Time.new() - 1.month
    month = time.strftime("%Y-%m")
    year = time.strftime("%Y")
    @amount_monthly = Lote.select("SUM(cantidad) as cantidad, cliente_id")
      .joins(:programacion)
      .where("lotes.empresa = ? and programaciones.mes = ?", company, month+"-01")
      .group(:cliente_id, :mes)
    @amount_annual = Lote.select("SUM(cantidad) as cantidad, cliente_id")
      .joins(:programacion)
      .where("lotes.empresa = ? and EXTRACT(year from programaciones.mes) = ?", company, year)
      .group(:cliente_id)
    
    @programing = Programacion
      .where("EXTRACT(year_month from mes)=? and empresa= ?", month, session[:selected_company])
  end
end
