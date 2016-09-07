# Preview all emails at http://localhost:3000/rails/mailers/insumos_mailer
class InsumosMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/insumos_mailer/insumos
  def insumos
    InsumosMailer.insumos
  end

end
