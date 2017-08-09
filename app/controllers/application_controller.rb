class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

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
      flash.now[:success] = "#{resource.class} is edited!"
      render json: resource, root: false, status: 200
    else
      flash.now[:danger] = "#{resource.class} is not edited! See errors below."
      render json: resource.errors.as_json, status: :unprocessable_entity
    end
  end

  def destroy_resource(resource)
    resource.destroy
    flash.now[:success] = "#{resource.class} is deleted!"
    render json: :nothing, status: 204
  end
end
