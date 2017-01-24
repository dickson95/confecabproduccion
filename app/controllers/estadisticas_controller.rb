class EstadisticasController < ApplicationController
  before_action :set_years, only: [:clientes, :programaciones]
  before_action :meses, only: [:clientes, :show_programaciones, :programaciones]
  before_filter :authorize

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
    @wip = []
    # Tomar los estados activos para hacer la estadística de cada uno
    Estado.active.each do |estado|
      lotes = Lote.joins(:programacion).where(com_progr, company, year_month)
      amount = 0
      # Despues de tener los lotes para la programación en la variable "lotes" se recorre para tomar los controles
      # que tiene en el estado que se está tratando y sumar lo que hay realmente en cada estado
      lotes.each do |lote|
        # Acumular la cantidad que hay en el proceso
        amounts = lote.control_lotes.where(estado_id: estado.id).each{ |control| amount += control.cantidad_last}
      end
      @wip.push({estado: estado, amount: amount})
    end
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
      format.html { render partial: 'show_month_cliente' }
    end
  end

  def show_cliente
    company = session[:selected_company] ? "CAB" : "D&C"
    time = Time.new()
    month = (time - 1.month).strftime("%Y-%m")
    @meses = meses
    @cliente = Cliente.where(:cliente => params[:cliente])
    @programaciones = Programacion.where("extract(year from mes)=? and programaciones.empresa = ? ",
                                         params[:year], session[:selected_company]).order(:mes)
    respond_to do |format|
      format.html { render partial: 'show_cliente' }
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
    @relatives = []
    last_id = Estado.select(:id).last_estado
    estados = Estado.active.where("id <> ? AND facturar = ? ", last_id, true)
    absolute = 0
    estados.each do |estado|
      next_estado = estado.next
      relative =  Programacion.percentage_planta(year_month, next_estado.id, session[:selected_company])
      @relatives.push({estado: estado, relative: relative} )
      absolute += relative * (estado.facturar_al / 100)
    end

    # Porcenteje absoluto de progreso en la programación
    @global_percente = absolute
  end

  def annual_cliente(company, year)
    Lote.current_state.state_filtered(last_estado.id).select("SUM(lotes.cantidad) as cantidad, cliente_id").joins(:programacion, :control_lotes)
        .where("lotes.empresa = ? and EXTRACT(year from programaciones.mes) = ?", company, year).group(:cliente_id)
  end

  # Suma las cantidades completadas para determinado cliente
  def month_cliente(company, month)
    @amount_monthly = Lote.current_state.state_filtered(last_estado.id).select("SUM(lotes.cantidad) as cantidad, cliente_id")
                          .joins(:programacion, :control_lotes)
                          .where("lotes.empresa = ? and programaciones.mes = ? and control_lotes.fecha_salida IS NOT NULL", company, month+"-01")
                          .group(:cliente_id, :mes)
  end

  def authorize
    authorize! :read, :estadisticas
  end

  def last_estado
    Estado.last_estado
  end
end
