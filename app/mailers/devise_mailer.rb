
class DeviseMailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers
  default template_path: 'devise/mailer'
  layout 'mailer'
  add_template_helper MailerHelper
  add_template_helper ApplicationHelper

  def confirmation_instructions(record, token, opts={})
    puts 'confirmation_instrucitions'
    opts[:subject] =  "Recuperar contraseña para Sistema de producción"
    opts[:from] = "info@confecab.com"
    opts[:reply_to] = 'info@confecab.com'
    super
  end
end