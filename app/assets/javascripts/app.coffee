this.Downflow = {}
$ ->
  Downflow.question = new Question

  $(".answers .answer").each((i, e) ->
    answer = new Answer(e.id)
    answer.$el.find(".comment").each((i, e) ->
      answer.comments.push(new Comment(e.id, "answers", answer.id))
    )
    Downflow.question.answers.push(answer)
  )

  $(".question .comment").each((i, e) ->
    Downflow.question.comments.push(new Comment(e.id, "questions", Downflow.question.id))
  )

  Shadowbox.init()
