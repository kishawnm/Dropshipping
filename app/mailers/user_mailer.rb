class UserMailer < ApplicationMailer
  default from: 'mail@parse.swirblesolutions.com'
  
  def message_email
    @message     = params[:message]
    @vendor_email=params[:vendor_dispute]
    @vendor_name = params[:name]
    mail(to: @vendor_email.email, subject: @vendor_email.subject)
  end
end