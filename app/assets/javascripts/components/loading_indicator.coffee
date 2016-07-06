{div, i, p, label} = React.DOM
@LoadingIndicator = React.createClass
  displayName: 'LoadingIndicator'

  mixins: [ScrollToOnMountMixin]

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
