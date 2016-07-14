module Events
  class AnswerSet < Event
    jsonb_accessor(
      :data,
      question_key: :string,
      answer_value: :integer
    )

    # Return the last given answer for each question that already has been answered
    def self.last_answers_for(response_uuid)
      question_keys_for(response_uuid).map do |question_key|
        where(response_uuid: response_uuid).data_contains(question_key: question_key).order(created_at: :desc).limit(1)
      end.flatten
    end

    def self.question_keys_for(response_uuid)
      where(response_uuid: response_uuid).map(&:question_key).uniq
    end
  end
end
