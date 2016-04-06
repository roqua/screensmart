{div, i, p, label} = React.DOM
@LoadingIndicator = React.createClass
  displayName: 'LoadingIndicator'

  render: ->
    div
      className: 'cs-loader'
      div
        className: 'cs-loader-inner'
        label
          className: 'dot'
          '●'
        label
          className: 'dot'
          '●'
        label
          className: 'dot'
          '●'
        label
          className: 'dot'
          '●'
        label
          className: 'dot'
          '●'
        label
          className: 'dot'
          '●'

