module Events
  class ResponseFinished < Event
    event_attributes :answer_values,
                     estimate: :float,
                     variance: :float,
                     estimate_interpretation: :string,
                     warning: :string
  end
end
