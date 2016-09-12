# Without this data filter, jQuery would not accept empty responses on a JSON post,
# which would force the server to send a meaningless message(e.g. { status: 'ok' })
# when all that is needed is a 201 "created" HTTP status
# from https://github.com/django-tastypie/django-tastypie/issues/886#issuecomment-29858414
$.ajaxSetup
  dataFilter: (data, type) ->
    data = null if type == 'json' && data == ''
    data

# Global jQuery configuration
$.ajaxSetup
  headers:
    'X-CSRF-Token': window.csrfToken
    'X-Key-Inflection': 'camel' # Let server know that we prefer camelCase attribute names
                                # See https://www.viget.com/articles/introducing-olivebranch
  contentType: 'application/json'
  dataType: 'json'


# Shorthand for our standard way of submitting data through jQuery
$.postJSON = (url, data, args = {}) ->
  $.ajax
    url: url
    method: 'POST'
    data: JSON.stringify data
    args...

$.putJSON = (url, data, args = {}) ->
  $.ajax
    url: url
    method: 'PUT'
    data: JSON.stringify data
    args...
