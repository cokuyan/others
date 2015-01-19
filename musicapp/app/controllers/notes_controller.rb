class NotesController < ApplicationController
  before_action :ensure_current_user_is_author_or_admin!, except: :create

  def create
    @note_params = note_params.to_h
    @note_params["user_id"] = current_user.id
    @note = Note.new(@note_params)
    if @note.save
      flash[:notice] = "Note added successfully"
      redirect_to track_url(@note.track)
    else
      flash[:errors] = @note.errors.full_messages
      redirect_to track_url(@note.track_id)
    end
  end

  def destroy
    @note = Note.find(params[:id])
    @note.destroy
    flash[:notice] = "Note removed successfully"
    redirect_to track_url(@note.track)
  end

  private

  def note_params
    params.require(:note).permit(:body, :track_id)
  end

  def ensure_current_user_is_author_or_admin!
    @note = Note.find(params[:id])
    unless current_user.admin || @note.user == current_user
      render text: "How did you get here?", status: :forbidden
    end
  end
end
