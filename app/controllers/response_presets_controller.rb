class ResponsePresetsController < ApplicationController
  before_action :set_all_preset
  
  def new
    if params[:format].present?
      @response=ResponsePreset.find_by_id(params[:format])
    else
      @response=ResponsePreset.new
    end
  end
  
  def create
    @response          = ResponsePreset.new(response_params)
    @response.vendor_id=current_vendor.id
    @response.save
    respond_to do |format|
      format.js
      format.html
    end
  end
  
  def update
    @response=ResponsePreset.find_by_id(params[:id])
    @response.update(response_params)
    respond_to do |format|
      format.js
      format.html
    end
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
  
  def set_all_preset
    @responses=ResponsePreset.all.where(vendor_id: current_vendor.id)
  end

end
