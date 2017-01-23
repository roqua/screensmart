# Global shorthands for frequently used jQuery methods
window.merge = (objects...) ->
  $.extend {}, objects...
window.deepCopy = (originalObject, into = {}) ->
  $.extend(true, into, originalObject)
