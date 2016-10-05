class ControlLotesController < ApplicationController
  #Solicitar prueba de permisos antes de cargar cualquier acción
  load_and_authorize_resource 
  
  # GET /control_lotes
  # GET /control_lotes.json
  def index
    @control_lotes = ControlLote.joins([lote: [:referencia]], :estado, :resp_ingreso_id).pluck("control_lotes.id, referencias.referencia, control_lotes.sub_estado_id, lotes.op, control_lotes.fecha_ingreso, control_lotes.fecha_salida, estados.estado, control_lotes.min_u, users.name, control_lotes.resp_salida_id")
    @sub_estado = {}
    @sub_estados = SubEstado.all.each{ |e|  @sub_estado[e.id] = e.sub_estado}
    @user = {}
    @users = User.select("id, name").each{ |e|  @user[e.id] = e.name}
  end
end
