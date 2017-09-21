module QuestionsHelper
  def active?(page)
    "active" if params[:action] == page
  end
end
