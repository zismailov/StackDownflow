class QuestionsSerializer < ApplicationSerializer
  attributes :id, :title, :body, :files, :tags_array, :list_of_tags, :best_answer, :votes_sum

  has_many :comments

  def tags_array
    object.tags.map(&:name)
  end

  def list_of_tags
    object.tag_list
  end

  def best_answer
    object.best_answer?
  end
end
