module QuestionsHelper
  def active?(page)
    "active" if params[:action] == page.to_s
  end
end
