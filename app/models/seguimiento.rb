class Seguimiento < ApplicationRecord
  # Seguimientos utilizados por cada control_lote para registrar los movimientos de las cantidades entre los procesos.
  # Proposito: Registrar información de las fechas en que se han pasado físicamente unidades de un lote a otro proceso.

  belongs_to :control_lote
  validates :proceso, inclusion: {in: [true, false]}
  validates :cantidad, presence: true, numericality: true
  # Para el proceso actual ( que si se ingresa manualmente es porque su id es mayor a 3 ), se valida que la cantidad
  # ingresada más la suma del último seguimiento registrado (en caso de que exista), no sean mayores a la cantidad que
  # hay en el proceso anterior ( Pasar el proceso hacia adelante )
  validate :cant_vs_cant, if: "!cantidad.nil? && proceso", on: [:create, :cambio_estado]
  
  # Esta validación es si se va a registrar un reproceso en el lote, entonces se hace se valida que el proceso del cual
  # se pretende devolver sí tenga las unidades solicitadas.
  validate :cant_return, if: "!cantidad.nil? && !proceso", on: [:create]

  def prev
    self.control_lote.seguimientos.order("id desc").offset(1).limit(1).first
  end

  # Se verifica que la cantidad ingresada corresponda a la cantidad que tiene el control_lote anterior al actual
  # en su último registro de seguimientos. Al restar la nueva cantidad no debe dar un número negativo.
  def cant_vs_cant
    puts "validación normal"
    set_control(control_lote_id)
    this = Seguimiento
    @control_prev = this.control_prev(@control)
    @lote = @control.lote
    last_amount = @control.cantidad_last
    amount_new = cantidad - last_amount
    # el único caso donde se presenta que la nueva cantidad sea menor es cuando se registra la resta en el proceso anterior
    # al actual.
    @amount_new = amount_new < 0 ? cantidad : amount_new
    res = this.have_seguimientos(@lote) ? subtract : equal_amount(@amount_new)  # Esta es la linea que define la validez de la cantidad
    errors.add(:cantidad, "No hay suficientes unidades en el proceso anterior") if res
  end

  # Esta validación funciona donde el objeto actual tiene una instacia del proceso anterior al que se le
  # quiere restar la cantidad.
  # La cantidad que se pase debe ser la suma del último seguimiento registrado con la cantidad que el usuario pasó
  def cant_return
    control = ControlLote.find(self.control_lote.id)
    control_next = ControlLote.next(control, control.lote)  # control siguiente al actual
    amount = cantidad - control.cantidad_last # recuperar la cantidad real que el usuario ingresó
    invalid = (control_next.cantidad_last - amount) < 0
    errors.add(:cantidad, "No hay suficientes unidades en el proceso del que se pretende devolver") if invalid
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

  def return_units(amount)
    control = ControlLote.find(self.control_lote.id)
    control_prev = ControlLote.prev(control, control.lote)
    # Crear seguimiento nuevo para el previo control con la suma de lo pasado como cantidad a retornar
    amount_final = amount + control_prev.cantidad_last if amount > 0
    @seguimiento = control_prev.seguimientos.new(cantidad: amount_final, proceso: self.proceso)
    save = @seguimiento.save
    if save
      time = Time.new
      control_prev.seguimientos.last.prev.update(fecha_salida: time)
      @seguimiento = control.seguimientos.new(cantidad: control.cantidad_last - amount, proceso: self.proceso)
      @seguimiento.save(validate: false)
      control.seguimientos.last.prev.update(fecha_salida: time)
    end
    { seguimiento: @seguimiento, save: save }
  end

  private

  def self.continue
    @control_prev = control_prev
    first_seguimiento if !have_seguimientos(@lote)
    $save = (@state < 4 || @action!="cambio_estado") ? seguimientos_register(@amount) : false
    if $save
      close_seguimientos          # Cerrar seguimiento del proceso anterior
      reduce_previous_seguimiento # Restar cantidad para el lote en el proceso anterior
      # Cerrar seguimiento anterior al que acaba de registrarse para el proceso actual
    end
    {seguimiento: @seguimiento, save: $save}
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
    p "fisrt seguimiento"
    aux = @control
    @control =  @control_prev
    sev = seguimientos_register(@lote.cantidad)
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
    @control_prev.seguimientos.new(:cantidad => total).save
  end

  def set_control(control)
    @control = ControlLote.find(control)
  end
  # Retorna el resultado de la validación
  def equal_amount(cantidad)
    cantidad != @lote.cantidad
  end

  def subtract
    if @control_prev
      seguimiento = @control_prev.seguimientos.last
      if seguimiento
        res = seguimiento.cantidad - @amount_new  # Restar cantidad del proceso anterior con la cantidad ingresada
        # Si la resta es mayor o igual que 0 retorna false, lo que permite en a la hora de determinar si se adjunta
        # la advertencia o no, se pueda preguntar por un valor verdadero
        valid = !(res >= 0)
        valid
      else
        true
      end
    end
  end
end
