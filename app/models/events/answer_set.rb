module Events
  class AnswerSet < Event
    event_attributes domain_id: :string,
                     question_id: :string,
                     answer_value: :integer

    # Key-value pair of answers for a given response UUID
    def self.answer_values_for(response_uuid, domain_id)
      last_answers_for(response_uuid, domain_id).map do |event|
        [event.question_id, event.answer_value]
      end.to_h
    end

    # Return the last given answer for each question that already has been answered
    def self.last_answers_for(response_uuid, domain_id)
      question_keys_for(response_uuid, domain_id).map do |question_id|
        where(response_uuid: response_uuid).data_contains(domain_id: domain_id, question_id: question_id)
                                           .order(created_at: :desc).limit(1)
      end.flatten
    end

    def self.question_keys_for(response_uuid, domain_id)
      where(response_uuid: response_uuid).data_contains(domain_id: domain_id).map(&:question_id).uniq
    end
  end
end
