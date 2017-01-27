=begin
  MÓDULO PARA VALIDACIONES ANTES DE ALGÚN EVENTO COMÚN
Por ejemplo la clase dentro del módulo delete y el método child_records sirve para varificar si hay más registros
dependientes y se puede usar para evitar que se elimine el registro
=end
module Before
  class Delete
    # Define si un registro tiene registros que dependen del mismo. Retorna true en caso de ser así
    def child_records(model)
      # Tomar las relaciones que tiene el modelo
      associations = get_has_many_relations get_class(model)
      associations.each do |association|
        # Contar cada una de las relaciones de los modelos de acuerdo al nombre de la relación
        amount_records = model.public_send(association.name).count
        return true if amount_records > 0
      end
      false
    end

    def child_of_relation(obj, rel)
      associations = get_has_many_relations(get_class(obj))
      associations.each do |ass|
        if ass.name == rel.to_sym
          amount_records = obj.public_send(ass.name).count
          return true if amount_records > 0
        end
      end
      false
    end

    # Consigue el nombre de la clase como objeto
    def get_class(object)
      object.class
    end

    # Recupera un array con las relaciones que tiene el modelo
    def get_has_many_relations(model)
      model.reflect_on_all_associations(:has_many)
    end
  end
end