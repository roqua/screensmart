module Events
  class ResponseFinished < Event
    event_attributes :answer_values,
                     results: :json_array
  end
end
