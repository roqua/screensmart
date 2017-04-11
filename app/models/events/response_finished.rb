module Events
  class ResponseFinished < Event
    event_attributes :answer_values,
                     :demographic_info,
                     results: :array
  end
end
