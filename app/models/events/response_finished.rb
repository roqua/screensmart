module Events
  class ResponseFinished < Event
    event_attributes :answer_values,
                     results: :array

    def results
      OpenStruct.new self[:results]
    end
  end
end
