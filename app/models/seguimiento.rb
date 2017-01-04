class Seguimiento < ApplicationRecord
  # Seguimientos utilizados por cada control_lote para registrar los movimientos de las cantidades entre los procesos.
  # Proposito: Registrar información de las fechas en que se han pasado físicamente unidades de un lote a otro proceso.

  belongs_to :control_lote

  validates :cantidad, presence: true, numericality: true
  validate :cant_vs_cant, if: "!cantidad.nil?", on: [:create, :cambio_estado]

  def prev
    self.control_lote.seguimientos.order("id desc").offset(1).limit(1).first
  end

  # Se verifica que la cantidad ingresada corresponda a la cantidad que tiene el control_lote anterior al actual
  # en su último registro de seguimientos. Al restar la nueva cantidad no debe dar un número negativo.
  def cant_vs_cant
    @control = ControlLote.find(control_lote_id)
    this = Seguimiento
    @control_prev = this.control_prev(@control)
    @lote = @control.lote
    last_amount = @control.cantidad_last
    puts "cantidad pasada #{cantidad}"
    puts "cantidad última a restar #{last_amount}"
    amount_new = cantidad - last_amount
    puts "resultado #{amount_new}"
    # el único caso donde se presenta que la nueva cantidad sea menor es cuando se registra la resta en el proceso anterior
    # al actual.
    @amount_new = amount_new < 0 ? cantidad : amount_new
    puts "resultado si negativo #{@amount_new}"
    res = this.have_seguimientos(@lote) ? subtract : equal_amount(@amount_new)  # Esta es la linea que define la validez de la cantidad
    puts "res #{res}"
    errors.add(:cantidad, "Ingresaste #{@total}. La cantidad real del lote #{@lote.cantidad}") if res
  end


  def self.have_seguimientos(lote)
    have = false
    lote.control_lotes.each do |control|
      amount = control.seguimientos.count
      (have = true; break) if amount > 0
    end
    have
  end

  # Al cambiar de un proceso a otro para que funcione en armonía con las validaciones de Seguimiento, se sigue el
  # orden proporcionado por este método.
  # 1. Nuevo seguimiento para el control_lote (proceso) actual con la cantidad "amount" suministrada
  # 2. Cerrar con fecha de salida el seguimiento para el proceso anterior al actual
  # 3. Crear nuevo seguimiento para el proceso anterior al actual
  def self.seguimientos_status_change(amount, control, action) # este método se debe llamar después de cerrar y registrar los estados del lote
    @time = Time.new
    @control = control
    @lote = control.lote
    @amount = amount
    @action = action
    @state = @control.estado_id
    continue
  end

  private

  def self.continue
    @control_prev = control_prev
    first_seguimiento if !have_seguimientos(@lote)
    save = (@state < 4 || @action!="cambio_estado") ? seguimientos_register(@amount) : false
    if save
      close_seguimientos          # Cerrar seguimiento del proceso anterior
      reduce_previous_seguimiento # Restar cantidad para el lote en el proceso anterior
    end
    {seguimiento: @seguimiento, save: save}
  end

  def self.close_seguimientos(control=nil)
    @control ||= control
    @time ||= Time.new
    @control_prev ||= control_prev
    @control_prev.seguimientos.last.update(:fecha_salida => @time)
  end

  def self.seguimientos_register(cantidad) # Crea un nuevo seguimiento
    @seguimiento = @control.seguimientos.new(:cantidad => cantidad)
    @seguimiento.save
  end

  def self.first_seguimiento # En caso de no tener ningún seguimiento este método lo registra  para el proceso anterior al último
    aux = @control
    @control =  @control_prev
    sev = seguimientos_register(@lote.cantidad)
    puts "registrando primer seguimietno #{sev}"
    @control =  aux
  end

  def self.control_prev(control=nil)
    @control ||= control
    ControlLote.prev(@control.id, @control.lote.id)
  end

  # Registra un seguimiento nuevo para el proceso anterior al actual pero restando la nueva cantidad agregada al
  # siguiente proceso. Para este método ya se habrá validado que la nueva cantidad corresponda con las existencias
  def self.reduce_previous_seguimiento
    prev = @control_prev.cantidad_last
    curr_prev = @control.seguimientos.last.prev
    total = prev - (@amount - (curr_prev ? curr_prev.cantidad : 0))
    puts "total #{total}, amount #{@amount}, prev #{prev}"
    @control_prev.seguimientos.new(:cantidad => total).save
  end

  # Retorna el resultado de la validación
  def equal_amount(cantidad)
    cantidad != @lote.cantidad
  end

  def subtract
    if @control_prev
      puts "substract"
      seguimiento = @control_prev.seguimientos.last
      if seguimiento
        puts "seguimiento #{seguimiento.cantidad}, control #{@control_prev.seguimientos.count}"
        puts "ultima cantidad #{seguimiento.cantidad}"
        res = seguimiento.cantidad - @amount_new
        puts "candidad despues de restarla #{res}"
        valid = !(res >= 0)
        valid
      else
        true
      end
    end
  end
end
