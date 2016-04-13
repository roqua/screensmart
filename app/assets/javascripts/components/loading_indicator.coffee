{div, i, p, label} = React.DOM
@LoadingIndicator = React.createClass
  displayName: 'LoadingIndicator'

  render: ->
    div
      className: 'loading-indicator'
      div
        className: 'loading-indicator-inner'
        for i in [0..6]
          label
            key: i
            className: 'dot'
            '●'
