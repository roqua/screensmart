@ScrollToOnMountMixin =
  componentDidMount: ->
    console.log "positionInPage: #{@positionInPage()}, marginTop: #{@marginTop()}"
    $('body').animate scrollTop: @positionInPage() - @marginTop(), 700

  positionInPage: ->
    @jQueryElement().offset().top

  marginTop: ->
    @jQueryElement().css('margin-top').replace('px', '')

  jQueryElement: ->
    $(ReactDOM.findDOMNode(this))
