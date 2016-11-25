
class DeviseMailer < Devise::Mailer
  helper :application
  default template_path: 'devise/mailer'
  default parts_order: [ "text/plain" ]

  def confirmation_instructions(record, opts={})
    opts[:subject] =  "Recuperar contraseña para Sistema de producción"
    opts[:from] = "correosconfecab@gmail.com"
    super
  end
end