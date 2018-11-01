class AutomatedResponsesController < ApplicationController
  before_action :set_response
  
  def new
    if params[:format].present?
      @response=AutomatedResponse.find_by_id(params[:format])
    else
      @response=AutomatedResponse.new
    end
  end
  
  def create
    @response          = AutomatedResponse.new(response_params)
    @response.vendor_id=current_vendor.id
    @response.save
    respond_to do |format|
      format.js
      format.html
    end
  end
  
  def update
    @response=AutomatedResponse.find_by_id(params[:id])
    @response.update(response_params)
    respond_to do |format|
      format.js
      format.html
    end
  end
  
  def turn_off
    @responses.update_all(is_active:false)
    redirect_to new_automated_response_path
  end
  
  def destroy
    @response=AutomatedResponse.find_by_id(params[:id])
    @response.destroy
    redirect_to new_automated_response_path
  end
  
  private
  def response_params
    params.require(:automated_response).permit(:name_of_response, :trigger, :subject, :response, :vendor_id,:is_active)
  end
  
  def set_response
    @responses=AutomatedResponse.all.where(vendor_id: current_vendor.id)
  end

end
