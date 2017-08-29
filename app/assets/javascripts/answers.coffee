class @Answer
  constructor: (@answer_id) ->
    this.$el = $("#" + this.answer_id);
    this.$body = this.$el.find(".answer-body")
    this.$voting = this.$el.find(".voting")
    this.$votes = this.$voting.find(".votes")
    this.$commentBtn = this.$el.find(".show-comment-form")
    this.$commentForm = this.$el.find(".comment-form")
    this.$commentsWrapper = this.$el.find(".comments-wrapper")
    this.$comments = this.$commentsWrapper.find(".comments")
    this.comments = []
    this.id = parseInt(answer_id.split("_")[1])

    this.binds()
    this.setAjaxHooks()

  binds: () ->
    that = this
    this.$commentBtn.click((e) ->
      e.preventDefault()
      that.toggleCommentForm()
    )
    this.$el.on "click", ".edit-answer", (e) ->
      e.preventDefault()
      that.edit(HandlebarsTemplates["edit_answer"]({id: that.id, body: that.$body.text(), question_id: Underflow.question.id}))

  setAjaxHooks: () ->
    that = this
    this.$el.on "ajax:success", "form.edit_answer", (e, data, status, xhr) ->
      that.$body.text(xhr.responseJSON.body)

    this.$el.on "ajax:error", "form.edit_answer", (e, xhr, status) ->
      that.renderFormErrors(this, xhr.responseJSON)

    this.$commentForm.on "ajax:success", (e, data, status, xhr) ->
      that.addComment(xhr.responseJSON)

    this.$commentForm.on "ajax:error", (e, xhr, status) ->
      that.renderFormErrors(this, xhr.responseJSON)

    this.$commentsWrapper.on "ajax:success", "a.delete-comment", (e, xhr, status) ->
      that.removeComment($(this).data("id"))

    this.$voting.on "ajax:success", "a.vote-up", (e, data, status, xhr) ->
      that.$votes.text(xhr.responseJSON.votes)
      $(this).remove()
      that.$voting.find("a.vote-down").remove()

    this.$voting.on "ajax:success", "a.vote-down", (e, data, status, xhr) ->
      that.$votes.text(xhr.responseJSON.votes)
      $(this).remove()
      that.$voting.find("a.vote-up").remove()

  renderFormErrors: (form, response) ->
    $form = $(form)
    this.clearFormErrors(form)
    $form.prepend("<div class='alert alert-danger'>Please review the problems below:</div>")
    for field, error of response
      field = $form.find(".form-control#answer_#{field}")
      formGroup = field.parents(".form-group").addClass("has-error")
      formGroup.append("<span class='help-block error'>#{error[0]}</a>")

  clearFormErrors: (form) ->
    $form = $(form)
    $form.find(".alert.alert-danger").remove()
    formGroup = $form.find(".has-error")
    formGroup.find(".help-block.error").remove()
    formGroup.removeClass("has-error")

  toggleCommentForm: () ->
    this.$commentForm.slideToggle()

  addComment: (comment) ->
    if (this.$comments.length == 0 || this.$comments.find(".comment").length == 0)
      this.$comments = $("<ul class='comments'></ul>").appendTo(this.$commentsWrapper)
    this.$comments.append(HandlebarsTemplates["comment"](comment))
    this.comments.push(new Comment("comment_#{comment.id}", "answers", this.id))
    this.toggleCommentForm()
    this.clearCommentForm()

  removeComment: (commentId) ->
    this.$comments.find("#comment_#{commentId}").remove()
    if (this.$comments.is(":empty"))
      this.$comments.remove()
    for comment in this.comments
      if comment.id == parseInt(commentId, 10)
        this.comments.splice(this.comments.indexOf(comment), 1)

  renderCommentForm: (form) ->
    this.$commentForm.html(form)

  clearCommentForm: () ->
    this.$commentForm.find("textarea").val("")
    this.$commentForm.find(".alert-danger").remove()
    this.$commentForm.find(".has-error").removeClass("has-error").find(".help-block").remove()

  edit: (form) ->
    this.$body.html(form)

  commentById: (id) ->
    for comment in this.comments
      return comment if comment.id == id
    return null