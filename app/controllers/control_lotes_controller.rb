class ControlLotesController < ApplicationController
  #Solicitar prueba de permisos antes de cargar cualquier acción
  load_and_authorize_resource 
  
  # GET /control_lotes
  # GET /control_lotes.json
  def index
    @control_lotes = ControlLote.order('lote_id').all
  end
end
