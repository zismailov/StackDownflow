$ ->
  $("#show-question-comment-textarea").click((e)->
    e.preventDefault()
    $(".question .comment-question-form").slideToggle()
  )
