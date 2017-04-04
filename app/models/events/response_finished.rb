module Events
  class ResponseFinished < Event
    event_attributes :answer_values,
                     domain_results: :array
  end
end
