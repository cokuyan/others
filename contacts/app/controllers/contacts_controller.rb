class ContactsController < ApplicationController
  def index
    contacts = Contact.where(user_id: params[:user_id])
    shared_contacts = User.find(params[:user_id]).shared_contacts
    all_contacts = contacts + shared_contacts
    render json: all_contacts
  end

  def create
    contact = Contact.new(contact_params)
    if contact.save
      render json: contact
    else
      render(
      json: contact.errors.full_messages, status: :unprocessable_entity
      )
    end
  end

  def show
    contact = Contact.find(params[:id])
    comments = contact.comments
    render json: {contact => comments}
  end

  def update #
    contact = Contact.find(params[:id])
    if contact.nil?
      render text: "not found", status: :not_found
    else
      if contact.update(contact_params)
        render json: contact
      else
        render(
        json: contact.errors.full_messages, status: :unprocessable_entity
        )
      end
    end
  end

  def destroy
    contact = Contact.find(params[:id])
    if contact.nil?
      render text: "not found", status: :not_found
    else
      contact.destroy
      render json: contact
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :user_id)
  end
end
