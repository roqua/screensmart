React = require 'react'
ReactDOM = require 'react-dom'
ScreensmartApp = require './components/screensmart_app'

ReactDOM.render React.createElement(ScreensmartApp, null, 'bla'),
                document.getElementById 'app'
