class CatRentalRequestsController < ApplicationController

  before_action :only_owner_can_approve_or_deny_requests, only: [:approve, :deny]
  before_action :redirect_unless_logged_in, only: [:create, :new]

  def new
    @request = CatRentalRequest.new
  end

  def create
    params = cat_rental_request_params
    params[:user_id] = current_user.id
    @request = CatRentalRequest.new(params)

    if @request.save
      flash[:notice] = "Request pending"
      @cat = Cat.find(params[:cat_id])
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @request.errors.full_messages
      render :new
    end
  end

  def destroy
  end

  def update
  end

  def edit
  end

  def approve
    @request = CatRentalRequest.find(params[:id])
    @request.approve!
    @cat = Cat.find(@request.cat_id)
    redirect_to cat_url(@cat)
  end

  def deny
    @request = CatRentalRequest.find(params[:id])
    @request.deny!
    @cat = Cat.find(@request.cat_id)
    redirect_to cat_url(@cat)
  end


  private

    def cat_rental_request_params
      params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date)
    end

    def only_owner_can_approve_or_deny_requests
      @request = CatRentalRequest.find(params[:id])
      @cat = Cat.find(@request.cat_id)
      redirect_to cat_url(@cat) unless @cat.owner == current_user
    end
end
