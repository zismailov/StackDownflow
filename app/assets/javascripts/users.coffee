$ ->
  $(".user-profile-tabs li:first").addClass("active")
  $(".pane:first").show()

  $(".user-profile-tabs li").click (e) ->
    e.preventDefault()
    $this = $(this)
    $this.siblings().removeClass("active")
    $this.addClass("active")
    $(".pane").hide().eq($this.index()).show()
