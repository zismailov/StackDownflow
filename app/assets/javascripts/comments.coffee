class @Comment
  constructor: (@commentId, @commentable_type, @commentable_id) ->
    this.$el= $("#" + this.commentId)
    this.$body = this.$el.find(".comment-body")
    this.id = parseInt(commentId.split("_")[1], 10)

    this.binds()
    this.setAjaxHooks()

  binds: () ->
    that = this
    this.$el.on "click", ".edit-comment", (e) ->
      e.preventDefault()
      that.edit(HandlebarsTemplates["edit_comment"]({id: that.id, commentable: that.commentable_type, commentable_id: that.commentable_id, body: that.$body.text()}))

  setAjaxHooks: () ->
    that = this
    this.$el.on "ajax:success", "form.edit_comment", (e, data, status, xhr) ->
      that.$el.html($(HandlebarsTemplates["comment"](xhr.responseJSON)).contents())
      that.$el= $("##{that.commentId}")
      that.$body = that.$el.find(".comment-body")
      that.binds()

    this.$el.on "ajax:error", "form.edit_comment", (e, xhr, status) ->
      that.renderFormErrors(this, xhr.responseJSON)

  edit: (comment) ->
    this.$el.html(comment)

  renderFormErrors: (form, response) ->
    this.clearFormErrors(form)
    $form = $(form)
    $form.prepend("<div class='alert alert-danger'>Please review the problems below:</div>")
    for field, error of response
      field = $form.find(".form-control[id$=#{field}]")
      formGroup = field.parents(".form-group").addClass("has-error")
      formGroup.append("<span class='help-block error'>#{error[0]}</a>")

  clearFormErrors: (form) ->
    $form = $(form)
    $form.find(".alert.alert-danger").remove()
    formGroup = $form.find(".has-error")
    formGroup.find(".help-block.error").remove()
    formGroup.removeClass("has-error")
