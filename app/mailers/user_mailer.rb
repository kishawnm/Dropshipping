class UserMailer < ApplicationMailer
  default from: 'mail@parse.swirblesolutions.com'
  
  def message_email
    @message = params[:message]
    @vendor_email=params[:vendor_dispute]
    @url  = 'http://example.com/login'
    mail(to: @vendor_email.email, subject: 'Issue#' +"#{@vendor_email.order_number}")
  end
end