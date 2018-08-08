class WelcomeController < ApplicationController
  
  def home
    
    if current_vendor.present?
      redirect_to vendors_dashboard_index_path
    else
      redirect_to new_vendor_session_path
    end
  
  end
  def submit_form
    
  end
  def error_message
    
  end

end
