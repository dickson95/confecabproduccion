class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user
    print "\nAsignación de permiso a usuario segun rol\n"
    if user.has_rol? :admin
      can :manage, :all
    elsif user.has_rol? :coor_tiempos
      can :manage, :all
    elsif user.has_rol? :coor_integracion
      can [:manage], [Lote, @programacion, ControlLote]
    elsif user.has_rol? :aux_insumos
      can [:manage], [Lote, @programacion]
    elsif user.has_rol? :gerente
      can :read, :all
    end
  end
end
