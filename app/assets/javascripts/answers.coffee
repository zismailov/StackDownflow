$ ->
  $("#show-answer-comment-textarea").click((e)->
    e.preventDefault()
    $(this).parents('.answer').find(".new_comment").slideToggle()
  )
