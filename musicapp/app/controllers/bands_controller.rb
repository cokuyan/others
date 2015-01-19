class BandsController < ApplicationController
  before_action :require_current_user!
  before_action :require_admin_user!, only: [:edit, :update, :new, :create, :destroy]

  def index
    @bands = Band.all
  end

  def edit
    @band = Band.find(params[:id])
  end

  def update
    @band = Band.find(params[:id])
    if @band.update(band_params)
      flash[:notice] = "#{@band.name} updated successfully"
      redirect_to band_url(@band)
    else
      flash.now[:errors] = @band.errors.full_messages
      render :edit
    end
  end

  def show
    @band = Band.find(params[:id])
  end

  def new
    @band = Band.new
  end

  def create
    @band = Band.new(band_params)
    if @band.save
      flash[:notice] = "#{@band.name} added successfully"
      redirect_to band_url(@band)
    else
      flash.now[:errors] = @band.errors.full_messages
      render :new
    end
  end

  def destroy
    @band = Band.find(params[:id])
    @band.destroy
    flash[:notice] = "#{@band.name} removed successfully"
    redirect_to bands_url
  end

  private

  def band_params
    params.require(:band).permit(:name)
  end
end
