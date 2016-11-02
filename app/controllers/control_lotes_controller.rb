class ControlLotesController < ApplicationController
  #Solicitar prueba de permisos antes de cargar cualquier acción
  load_and_authorize_resource 
  
  # GET /control_lotes
  # GET /control_lotes.json
  def index
    company = session[:selected_company]
    @lote = Lote.find(control_lote_params[:lote_id])
    @ciclo_lote = @lote.control_lotes
    @sub_estado = {}
    @sub_estados = SubEstado.all.each{ |e|  @sub_estado[e.id] = e.sub_estado}
    @user = {}
    @users = User.select("id, name").each{ |e|  @user[e.id] = e.name}
  end
  
  private
    def control_lote_params
      params.permit(:lote_id)
    end
end
