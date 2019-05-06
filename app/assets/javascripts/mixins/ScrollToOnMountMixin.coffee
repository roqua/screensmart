@ScrollToOnMountMixin =
  componentDidMount: ->
    $('html,body').scrollTop @positionInPage() - @marginTop()

  positionInPage: ->
    parseFloat @jQueryElement().offset().top

  marginTop: ->
    parseFloat @jQueryElement().css('margin-top').replace('px', '')

  jQueryElement: ->
    $(ReactDOM.findDOMNode(this))
