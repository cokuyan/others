class TracksController < ApplicationController
  before_action :require_current_user!
  before_action :require_admin_user!, only: [:edit, :update, :new, :create, :destroy]

  def show
    @track = Track.find(params[:id])
  end

  def new
    @track = Track.new
    @album = Album.find(params[:album_id])
  end

  def create
    @track = Track.new(track_params)
    if @track.save
      flash[:notice] = "#{@track.title} added successfully"
      redirect_to track_url(@track)
    else
      @album = Album.find(@track.album_id)
      flash.now[:errors] = @track.errors.full_messages
      render :new
    end
  end

  def edit
    @track = Track.find(params[:id])
    @album = @track.album
  end

  def update
    @track = Track.find(params[:id])
    if @track.update(track_params)
      flash[:notice] = "#{@track.title} updated successfully"
      redirect_to track_url(@track)
    else
      flash.now[:errors] = @track.errors.full_messages
      render :edit
    end
  end

  def destroy
    @track = Track.find(params[:id])
    @track.destroy
    flash[:notice] = "#{@track.title} removed successfully"
    redirect_to album_url(@track.album)
  end

  private

  def track_params
    params.require(:track).permit(:title, :album_id, :kind, :lyrics)
  end
end
