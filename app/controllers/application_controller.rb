class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end

  def variables_for_question_show
    @answers = @question.answers.order("best DESC, created_at")
    @comments = @question.comments.order("created_at DESC")
    @comment = Comment.new
  end
end
