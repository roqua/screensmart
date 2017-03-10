module Events
  class ResponseFinished < Event
    event_attributes :answer_values,
                     results: :array
  end
end
