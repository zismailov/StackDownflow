require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder

  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def default_serializer_options
    { root: false }
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end

  def find_parent
    resource, id = request.path.split("/")[1, 2]
    @parent = resource.singularize.classify.constantize.find(id)
  end

  def update_resource(resource)
    respond_with resource.update(send(:"#{resource.class.to_s.downcase}_params")) do |format|
      if resource.errors.any?
        format.json { render json: resource.errors, status: 422 }
      else
        format.json { render json: resource, status: 200 }
      end
    end
  end

  def add_user_id_to_attachments
    model = params[:controller].singularize.to_sym
    params[model][:attachments_attributes]&.each do |_k, v|
      v[:user_id] = current_user.id
    end
  end
end
