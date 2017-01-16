class ControlLote < ApplicationRecord
  has_many :seguimientos, :dependent => :destroy
  belongs_to :lote, optional: true
  belongs_to :estado
  belongs_to :sub_estado, optional: true
  belongs_to :resp_ingreso_id, class_name: 'User', foreign_key: 'resp_ingreso_id'
  belongs_to :resp_salida_id, class_name: 'User', foreign_key: 'resp_salida_id', 
  optional: true
  
  # Validaciones
  validates :estado, :fecha_ingreso, presence: true

  scope :prev, ->(id, lote_id) { where("id < ? and lote_id = ?", id, lote_id).last }
  scope :next, ->(id, lote_id) { where("id > ? and lote_id = ?", id, lote_id).first }

  # Métodos
  # Get para la última cantidad
  def cantidad_last
    last = self.seguimientos.last
    return last.cantidad if last
    0
  end

  def sub_estado_id=(val)
    val = val.strip.eql?("") ? "0" : val
    write_attribute(:sub_estado_id, val)
  end

  def date_range
    date1 = self.fecha_ingreso
    date2 = self.fecha_salida
    if !date2.nil?
      with_month = nil
      if date1.strftime("%m") == date2.strftime("%m")
        with_month = I18n::l(date1, format: "%d")
      else
        with_month = I18n::l(date1, format: "%d de %b")
      end
      "#{with_month} - #{I18n::l(date2, format: "%d de %b")}"
    else
      I18n::l(date1, format: "%d de %b")
    end
  end

  def fecha_ingreso_input
    return  I18n::localize( self.fecha_ingreso, :format => "%Y-%m-%d %H:%M:%S") if !self.fecha_ingreso.nil?
    I18n::localize( Time.zone.utc_to_local(Time.new) + 60, :format => "%Y-%m-%d %H:%M:%S")
  end

  def self.hash_ids
    result = ControlLote.select("lote_id, fecha_ingreso").where("control_lotes.fecha_ingreso = (SELECT MIN(fecha_ingreso) FROM control_lotes cl GROUP BY lote_id HAVING cl.lote_id = control_lotes.lote_id)")
    hash_ids = Hash.new
    result.each do |r|
      hash_ids[r.lote_id] = r.fecha_ingreso
    end
    return hash_ids
  end

  # Retorna un hash con opciones de la resta de los días
  def self.date_operated(date_initial, date_final)    
    {
      :days => days_absolute(date_initial, date_final)
    }
  end

  def self.after_before(lote)
    amount_lote = lote.cantidad
    control_lotes = lote.control_lotes.sum(:cantidad)
    if amount_lote < control_lotes
      res = control_lotes - amount_lote
      return "Sobran #{res}"
    elsif amount_lote > control_lotes
      res = amount_lote - control_lotes
      return "Faltan #{res}"
    else
      return nil
    end
  end

  private
    # Parametros
    # d1: Día inicial 
    # d2: Dia final
    # return: Días absolutos entre dos fechas
    def self.days_absolute(d1, d2)
      di = d1 + 1.day 
      di = Time.local(di.year, di.month, di.day)
      df = Time.local(d2.year, d2.month, d2.day)
      ((df - di) / (24 * 60 * 60)).ceil + 2
    end
end
