class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_attachment
  before_action :attachment_belongs_to_current_user?

  respond_to :json

  def destroy
    respond_with @attachment.destroy
  end

  private

  def set_attachment
    @attachment = Attachment.find(params[:id])
  end

  def attachment_belongs_to_current_user?
    render json: :nothing, status: 401 unless @attachment.user == current_user
  end
end
