class Ability
  include CanCan::Ability
  
  def initialize(user)
    user ||= User.new # guest user

    alias_action :total_price, :to => :prices
    alias_action :view_details, :show, :to => :read
    alias_action :edit, :update, :to => :billing

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
      can :create, [Cliente, TipoPrenda]
      cannot :prices, Lote
    elsif user.has_rol? :aux_insumos
      can [:read, :update], Lote
      can [:read, :export], Programacion
      can :read, [ControlLote, Cliente]
    elsif user.has_rol? :gerente
      can :read, :all
      can [:read, :export], Programacion
      can :prices, Lote
      cannot :manage, [Referencia, Talla, Rol]
    elsif user.has_rol? :aux_facturacion
      can [:read, :billing], Lote
    end
  end
end
