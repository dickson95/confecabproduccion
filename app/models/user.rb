class User < ApplicationRecord
  
  # Validaciones
  validates :name, :username, presence: true
  
  # AUTENTICACIÓN
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :authentication_keys => [:login]
  attr_accessor :login
  
  # RELACIONES
  has_and_belongs_to_many :roles
  has_many :control_lotes, class_name: 'ControlLote', primary_key: 'id', foreign_key: 'resp_ingreso_id'
  has_many :control_lotes, class_name: 'ControlLote', primary_key: 'id', foreign_key: 'resp_salida_id'
  has_many :lotes, class_name: 'Lote', primary_key: 'id', foreign_key: 'respon_insumos_id'
  has_many :lotes, class_name: 'Lote', primary_key: 'id', foreign_key: 'respon_edicion_id'
  
  
  
  # MÉTODOS
  def has_rol?(rol_sym)
    roles.any? { |r| r.name.underscore.to_sym == rol_sym }
  end
  
  #Metodo para iniciar con usuario o correo electrónico
  #Documentación para más información
  #https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign-in-using-their-username-or-email-address
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value",
      { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end
end
