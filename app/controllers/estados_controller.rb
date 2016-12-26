class EstadosController < ApplicationController
  before_action :set_estado, only: [:edit, :update]

  def index
    @estados = Estado.all
  end

  def edit
    respond_to :js
  end

  def update
    respond_to do |format|
      if @estado.update(params_estado)
        format.js
        format.json { render json: @estado, status: :ok }
      else
        format.js
        format.json { render json: @estado.errors, status: :unprocessable_entity }
      end
    end
  end


  private

  def set_estado
    @estado = Estado.find(params[:id])
  end

  def params_estado
    params.require(:estado).permit(:estado, :nombre_accion, :color, :color_claro)
  end
end
