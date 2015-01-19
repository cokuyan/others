class AlbumsController < ApplicationController
  before_action :require_current_user!
  before_action :require_admin_user!, only: [:edit, :update, :new, :create, :destroy]

  def show
    @album = Album.find(params[:id])
  end

  def new
    @album = Album.new
    @band = Band.find(params[:band_id])
  end

  def create
    @album = Album.new(album_params)
    if @album.save
      flash[:notice] = "#{@album.title} added successfully"
      redirect_to album_url(@album)
    else
      @band = Band.find(@album.band_id)
      flash.now[:errors] = @album.errors.full_messages
      render :new
    end
  end

  def edit
    @album = Album.find(params[:id])
    @band = @album.band
  end

  def update
    @album = Album.find(params[:id])
    if @album.update(album_params)
      flash[:notice] = "#{@album.title} updated successfully"
      redirect_to album_url(@album)
    else
      flash.now[:errors] = @album.errors.full_messages
      render :edit
    end
  end

  def destroy
    @album = Album.find(params[:id])
    @album.destroy
    flash[:notice] = "#{@album.title} removed successfully"
    redirect_to band_url(@album.band)
  end

  private

  def album_params
    params.require(:album).permit(:title, :band_id, :kind)
  end
end
