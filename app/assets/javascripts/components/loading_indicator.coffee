{div, i, p, label} = React.DOM
@LoadingIndicator = React.createClass
  displayName: 'LoadingIndicator'

  render: ->
    div
      className: 'loading-indicator'
      div
        className: 'loading-indicator-inner'
        for [0..6]
          label
            className: 'dot'
            '●'

