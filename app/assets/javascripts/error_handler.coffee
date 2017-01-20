email = 'support@roqua.nl'
message = "Onbekende fout. Mail naar <a href='mailto:#{email}'>#{email}</a> voor hulp"

applicationInitialized = ->
  Screensmart? && typeof Screensmart.store?.dispatch == 'function'

showUnknownError = ->
  # Show error in a primitive way if something went wrong during initialization
  if applicationInitialized()
    Screensmart.store.dispatch Screensmart.Actions.addMessage message
  else
    document.body.innerHTML = message

window.onerror = (_message, _filename, _lineno, _colno, error) ->
  showUnknownError()
  error.message += " store contents: #{prettyStoreContents()}"

  appsignal.sendError(error) if error && window.environment != 'development'

prettyStoreContents = ->
  storeContents = Screensmart.store.getState()
  JSON.stringify(storeContents, null, 2)

# Global jQuery AJAX error handler
$(document).ajaxError (event, xhr, settings, error ) ->
  { method, url, type } = settings
  { status } = xhr

  if window.environment == 'development' || window.environment == 'test'
    console.log "#{type} #{url} failed: #{error}"
    console.log JSON.stringify(xhr: xhr, settings: settings)
  else
    appsignal.sendError new Error "#{type} #{url} failed: #{error}"
