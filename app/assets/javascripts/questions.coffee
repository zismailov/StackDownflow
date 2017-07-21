$ ->
  $("#show-question-comment-textarea").click((e)->
    e.preventDefault()
    $("#new_comment").slideToggle()
  )
