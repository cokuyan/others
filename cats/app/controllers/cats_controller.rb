class CatsController < ApplicationController

  before_action :only_owner_can_edit_cat, only: [:edit, :update, :destroy]

  def index
    @cats = Cat.all.order(:id)
  end

  def show
    @cat = Cat.find(params[:id])
  end

  def new
    @cat = Cat.new
  end

  def create
    params = cat_params
    params[:user_id] = current_user.id
    @cat = Cat.new(params)
    if @cat.save
      flash[:notice] = "Created #{@cat.name}"
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    @cat = Cat.find(params[:id])
  end

  def update
    @cat = Cat.find(params[:id])
    if @cat.update(cat_params)
      flash[:notice] = "Edited #{@cat.name}"
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :edit
    end
  end

  def destroy
    @cat = Cat.find(params[:id])
    @cat.destroy
    flash[:notice] = "#{@cat.name} deleted"
    redirect_to cats_url
  end


  private

  def cat_params
    params.require(:cat).permit(:birth_date, :name, :color, :sex, :description, :user_id)
  end

  def only_owner_can_edit_cat
    @cat = Cat.find(params[:id])
    redirect_to cats_url unless @cat.owner == current_user
  end
end
