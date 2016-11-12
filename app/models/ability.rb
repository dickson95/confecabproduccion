class Ability
  include CanCan::Ability
  
  def initialize(user)
    user ||= User.new # guest user

    alias_action :export_excel, :export_pdf, :options_export, :to => :export
    alias_action :read, :to => :prices   # Permiso de lectura para los precios
    alias_action :total_price, :update, :to => :prices_update   # Permiso de escritura para los precios
    alias_action :update, :to => :billing                 # Permiso de escritura para los facturación
    alias_action :create, :update, :to => :integracion
    alias_action :update, :to => :insumos

    if user.has_rol? :admin
      can :manage, :all
      # Evita que el usuario con el id que se le pase sea eliminado
      cannot :destroy, User do |u|
        u.id == 1
      end
    elsif user.has_rol? :coor_tiempos
      can :manage, [Programacion, User, ControlLote, Lote, SubEstado, Cliente, TipoPrenda]
    elsif user.has_rol? :coor_integracion
      can :manage, [Programacion, ControlLote, Lote]
      can :create, [Cliente, TipoPrenda, SubEstado]
      can :read, Cliente
      can :integracion, Lote
      cannot :destroy, ControlLote
      cannot [:prices, :prices_update, :insumos, :billing], Lote
      can [:read, :update], Lote
    elsif user.has_rol? :aux_insumos
      can [:read, :update, :insumos, :cambio_estado, :export], Lote
      can [:read, :export, :program_table], Programacion
      can :read, [ControlLote, Cliente]
      can [:create, :update], ControlLote
      can :create, SubEstado
      cannot [:prices, :prices_update, :integracion, :billing], Lote
      can [:read, :update], Lote
    elsif user.has_rol? :gerente
      can :read, :all
      can [:read, :export, :program_table], Programacion
      can :prices, Lote
      cannot :manage, [Referencia, Talla, Rol]
    elsif user.has_rol? :aux_facturacion
      can [:read, :billing, :prices], Lote
      can :read, Cliente
    end
  end
end
