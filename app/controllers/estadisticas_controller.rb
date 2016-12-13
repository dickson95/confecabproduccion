class EstadisticasController < ApplicationController
  before_action :set_years, only:[:clientes, :programaciones]
  before_action :meses, only:[:clientes, :show_programaciones, :programaciones]
  def index
    company = session[:selected_company] ? "CAB" : "D&C"
    time = Time.new() 
    month = (time - 1.month).strftime("%Y-%m")
    year = time.strftime("%Y")
    year_month = time.strftime("%Y%m")
    month_cliente(company, month)
    # Datos mensuales de los clientes
    @amount_annual = annual_cliente(company, year)
    com_progr = "lotes.empresa = ?  and EXTRACT(year_month from programaciones.mes) = ?"
    @wip_integracion = Lote.current_state.state_filtered(2).joins(:programacion).where(com_progr, company, year_month).sum("lotes.cantidad")
    @wip_planta = Lote.current_state.state_filtered(3).joins(:programacion).where(com_progr, company, year_month).sum("lotes.cantidad")
    @wip_terminacion = Lote.current_state.state_filtered(4).joins(:programacion).where(com_progr, company, year_month).sum("lotes.cantidad")
    @wip_facturado = Lote.current_state.state_filtered(5).joins(:programacion).where(com_progr, company, year_month).sum("lotes.cantidad")
    # Programaciones
    set_data_programaciones(time.strftime("%Y%m"))
  end

  # /estadísticas/clientes
  # Detalles anuales de las cantidades por clientes
  def clientes
    company = session[:selected_company] ? "CAB" : "D&C"
    @year_clientes = Hash.new
    # Con los años que hay de las programaciones se suma la cantidad total de cada cliente
    @years.each do |year|
      clientes = annual_cliente(company, year)
      # al final el array queda con objetos de los lotes que tienen 
      # la cantidad y el cliente diponibles
      @year_clientes[year] = clientes
    end
  end

  def show_month_cliente
    company = session[:selected_company] ? "CAB" : "D&C"
    month_cliente(company, params[:year_month])
    respond_to do |format|
      format.html{ render partial: 'show_month_cliente' }
    end
  end

  def show_cliente
    company = session[:selected_company] ? "CAB" : "D&C"
    time = Time.new() 
    month = (time - 1.month).strftime("%Y-%m")
    @meses = meses
    @cliente = Cliente.where(:cliente => params[:cliente])
    @programaciones = Programacion.where("extract(year from mes)=? and programaciones.empresa = ? ", 
      params[:year] , session[:selected_company]).order(:mes)
    respond_to do |format|
      format.html{ render partial: 'show_cliente' }
    end
  end

  # /estadisticas/clientes
  # Detalles anuales de las cantidades por clientes
  def programaciones
    # Datos de las programaciones
    # Porcentajes relativos, es decir el 100% de producción en cada planta
    @year_programaciones = Hash.new
    @years.each do |year|
      @year_programaciones[year] = year
      months = Hash.new
      # m representa cada mes de los 12 del año
      @meses.each do |k, m|
        set_data_programaciones "#{year}#{m[:number]}"
        months[m[:string]] = @global_percente
      end
      @year_programaciones[year] = months
    end
  end 

  def show_programaciones
    year_month = params[:year]+params[:month]
    set_data_programaciones year_month
    # respuesta ajax desde el controlador http://stackoverflow.com/a/11897418
    respond_to do |format|
      format.html { render partial: 'show_programaciones' }
    end
  end

  private
    def set_years
      @years = Programacion.years_db
    end 

    def meses
      @meses = Programacion.meses
    end

    def set_data_programaciones(year_month)
      # Datos de las programaciones
      # Porcentajes relativos, es decir el 100% de producción en cada planta
      @confeccion_relative = Programacion.percentage_planta(year_month, 4, session[:selected_company])
      @terminacion_relative = Programacion.percentage_planta(year_month, 5, session[:selected_company])

      # Porcenteje absoluto de progreso en la programación
      absolute1 = @confeccion_relative * 0.7
      absolute2 = @terminacion_relative * 0.3

      @global_percente = absolute1 + absolute2 
    end


    def str_max_date_control
      "control_lotes.fecha_ingreso = (SELECT MAX(fecha_ingreso) FROM control_lotes cl GROUP BY lote_id HAVING cl.lote_id = control_lotes.lote_id)"
    end

    def annual_cliente(company, year)
      Lote.select("SUM(lotes.cantidad) as cantidad, cliente_id").joins(:programacion, :control_lotes).where(str_max_date_control + " and lotes.empresa = ? and EXTRACT(year from programaciones.mes) = ? and control_lotes.estado_id = 5", company, year).group(:cliente_id)
    end

    def month_cliente(company, month)
      @amount_monthly = Lote.select("SUM(lotes.cantidad) as cantidad, cliente_id")
        .joins(:programacion, :control_lotes)
        .where(str_max_date_control + " and control_lotes.estado_id = 5 and lotes.empresa = ? 
          and programaciones.mes = ?", company, month+"-01")
        .group(:cliente_id, :mes)
    end
end
