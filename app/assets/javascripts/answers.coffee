$ ->
  $(".answers").on("click", ".comment-answer", (e)->
    e.preventDefault()
    $(this).parents(".answer").find(".comment-answer-form").slideToggle()
  )
