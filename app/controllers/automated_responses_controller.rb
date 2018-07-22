class AutomatedResponsesController < ApplicationController
  
  
  def new
  
    if params[:format].present?
      @response=AutomatedResponse.find_by_id(params[:format])
    else
      @response=AutomatedResponse.new
    end
    @responses=AutomatedResponse.all.where(vendor_id:current_vendor.id)
  end
  
  def create
    @response = AutomatedResponse.new(response_params)
    @response.vendor_id=current_vendor.id
    @response.save
    redirect_to new_automated_response_path
  end
  
  def update
    @response=AutomatedResponse.find_by_id(params[:id])
    @response.update(response_params)
    redirect_to new_automated_response_path

  end

  def show
    @response=AutomatedResponse.find_by_id(params[:id])
    @response.destroy
    redirect_to new_automated_response_path
  end
  
  private
   def response_params
     params.require(:automated_response).permit(:name_of_response,:trigger, :subject, :response, :vendor_id)

   end
  
end
