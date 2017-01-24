class EstadosController < ApplicationController
  before_action :set_estado, only: [:edit, :update, :destroy, :unlock, :lock]

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
        puts @estado.facturar_al
        format.js { render "create_update" }
      else
        puts @estado.errors.full_messages
        @estado.reload
        format.js { render "create_update" }
      end
    end
  end

  def create
    @estado = Estado.new(params_estado)
    respond_to do |format|
      @save = @estado.save
      if @save
        @estado = Estado.last
        format.js { render "create_update" }
      else
        puts  @estado.errors.full_messages
        format.js { render "create_update" }
      end
    end
  end

  def destroy
    before = Before::Delete.new
    @removed = false
    if !before.child_records(@estado)
      @id = @estado.id
      @removed = true
      @estado.destroy
    end
    respond_to :js
  end

  def lock
    @estado.update_attribute(:active, false)
    respond_to :js
  end

  def unlock
    @estado.update_attribute(:active, true)
    respond_to :js
  end

  private

  def set_estado
    @estado = Estado.find(params[:id])
  end

  def params_estado
    params.require(:estado).permit(:estado, :nombre_accion, :pasa_cantidad, :color, :color_claro, :secuencia, :facturar, :facturar_al, :pasa_manual)
  end
end
