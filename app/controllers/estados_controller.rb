class EstadosController < ApplicationController
  before_action :set_estado, only: [:edit, :update, :destroy, :unlock]

  def index
    this = Estado
    @estados = this.where(active: true)
    @estados_inactive = this.where(active: false)
  end

  def edit
    puts action_name
    respond_to do |format|
      format.js { render "new_edit" }
    end
  end

  def new
    @estado = Estado.new
    respond_to do |format|
      format.js { render "new_edit" }
    end
  end

  def update
    respond_to do |format|
      if @estado.update(params_estado)
        format.js { "create_update" }
      else
        format.js { "create_update" }
      end
    end
  end

  def create
    @estado = Estado.new(params_estado)
    respond_to do |format|
      if @estado.save
        format.js { "create_update" }
      else
        format.js { "create_update" }
      end
    end
  end

  def destroy
    @estado.update(active: false)
    respond_to :js
  end

  def unlock
    @estado.update(active: true)
    respond_to :js
  end

  private

  def set_estado
    @estado = Estado.find(params[:id])
  end

  def params_estado
    params.require(:estado).permit(:estado, :nombre_accion, :pasa_cantidad, :color, :color_claro, :secuencia)
  end
end
