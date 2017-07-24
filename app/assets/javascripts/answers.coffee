$ ->
  $(".show-answer-comment-textarea").click((e)->
    console.log $(this).parents(".answer")
    e.preventDefault()
    $(this).parents(".answer").find(".new_comment").slideToggle()
  )
