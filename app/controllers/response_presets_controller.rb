class ResponsePresetsController < ApplicationController
  
  def new
    if params[:format].present?
      @response=ResponsePreset.find_by_id(params[:format])
    else
      @response=ResponsePreset.new
    end
    @responses=ResponsePreset.all.where(vendor_id:current_vendor.id)
  end
  
  def create
    @response = ResponsePreset.new(response_params)
    @response.vendor_id=current_vendor.id
    @response.save
    redirect_to new_response_preset_path
  end
  
  def update
    @response=ResponsePreset.find_by_id(params[:id])
    @response.update(response_params)
    redirect_to new_response_preset_path
  
  end
  
  def destroy
    @response=ResponsePreset.find_by_id(params[:id])
    @response.destroy
    redirect_to new_response_preset_path
  end
  
  
  private
  def response_params
    params.require(:response_preset).permit(:name, :message, :vendor_id)
  
  end


end
