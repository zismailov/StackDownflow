module QuestionsHelper
  def active?(page)
    "active" if current_scopes.keys.include?(page)
  end
end
