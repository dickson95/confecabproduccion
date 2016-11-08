class EstadisticasController < ApplicationController
  def index
    company = session[:selected_company] ? "CAB" : "D&C"
    time = Time.new() 
    month = (time - 1.month).strftime("%Y-%m")
    year = time.strftime("%Y")
    @amount_monthly = Lote.select("SUM(cantidad) as cantidad, cliente_id")
      .joins(:programacion)
      .where("lotes.empresa = ? and programaciones.mes = ?", company, month+"-01")
      .group(:cliente_id, :mes)
    @amount_annual = Lote.select("SUM(cantidad) as cantidad, cliente_id")
      .joins(:programacion, :control_lotes)
      .where("lotes.empresa = ? and EXTRACT(year from programaciones.mes) = ? and 
        control_lotes.estado_id = 5", company, year)
      .group(:cliente_id)
    
    # Porcentajes relativos, es decir el 100% de producción en cada planta
    @confeccion_relative = Programacion.percentage_planta(time.strftime("%Y%m"), 4, session[:selected_company])
    @terminacion_relative = Programacion.percentage_planta(time.strftime("%Y%m"), 5, session[:selected_company])

    # Porcenteje absoluto de progreso en la programación
    absolute1 = @confeccion_relative * 0.7
    absolute2 = @terminacion_relative * 0.3

    @global_percente = absolute1 + absolute2 
  end

  # /estadísticas/clientes
  # Detalles anuales de las cantidades por clientes
  def clientes
    company = session[:selected_company] ? "CAB" : "D&C"
    @years = Programacion.years_db
    @year_clientes = Hash.new
    # Con los años que hay de las programaciones se suma la cantidad total de cada cliente
    @years.each do |year|
      clientes =  Lote.select("SUM(cantidad) as cantidad, cliente_id")
      .joins(:programacion, :control_lotes).where("lotes.empresa = ? and 
        EXTRACT(year from programaciones.mes) = ? and 
        control_lotes.estado_id=5", company, year).group(:cliente_id)
        # al final el array queda con objetos de los lotes que tienen 
        # la cantidad y el cliente diponibles
      @year_clientes[year] = clientes
    end
  end

  # /estadisticas/clientes
  # Detalles anuales de las cantidades por clientes
  def programaciones      
  end  

end
