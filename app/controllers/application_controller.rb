require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  self.responder = ApplicationResponder
  # respond_to :html

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
    if resource.update(send(:"#{resource.class.to_s.downcase}_params"))
      render json: resource, root: false, status: 200
    else
      render json: resource.errors.as_json, status: :unprocessable_entity
    end
  end

  def destroy_resource(resource)
    resource.destroy
    render json: :nothing, status: 204
  end
end
