# Normally, jQuery would not accept empty responses on a JSON post,
# which would force the server to send a meaningless message(e.g. { status: 'ok' })
# when all that is needed is a "201 CREATED" status code
# from https://github.com/django-tastypie/django-tastypie/issues/886#issuecomment-29858414
$.ajaxSetup
  dataFilter: (data, type) ->
    data = null if type == 'json' && data == ''
    data

$.postJSON = (url, data, args = {}) ->
  $.ajax
    url: url
    method: 'POST'
    data: JSON.stringify data
    args...
