module Events
  class AnswerSet < Event
    jsonb_accessor(
      :data,
      question_key: :string,
      answer_value: :integer
    )
  end
end
