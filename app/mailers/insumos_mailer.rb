class InsumosMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.insumos_mailer.insumos.subject
  #
  def insumos(cliente)
    @cliente = cliente
    puts "Mensaje desde el método #{@cliente.mensaje}"
    mail(to: @cliente.email, subject: @cliente.asunto)
  end
end
