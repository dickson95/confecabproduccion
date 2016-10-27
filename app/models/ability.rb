class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user
    if user.has_rol? :admin
      can :manage, :all
    elsif user.has_rol? :coor_tiempos
      can :manage, :all
    elsif user.has_rol? :coor_integracion
      can [:manage], [Lote, Programacion, ControlLote]
    elsif user.has_rol? :aux_insumos
      can [:read, :create, :update], Lote
      can [:read], Programacion
    elsif user.has_rol? :gerente
      can :read, :all
      can :total_price, Lote
    end
  end
end
