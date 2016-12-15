module Events
  class ResponseFinished < Event
    event_attributes results: :array
  end
end
