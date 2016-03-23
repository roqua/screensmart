class Question < BaseModel
  attr_accessor :key, :answer_value

  validates_inclusion_of :key, in: RPackage.question_keys,
                               message: '`%{value}` not found'

  def text
    ensure_valid do
      RPackage.question_by_key(key)['text']
    end
  end

  def answer_option_set
    AnswerOptionSet.new(
      id: data_from_r['answer_option_set_id'],
      answer_options: data_from_r['answer_options'].map do |attributes|
        AnswerOption.new(attributes)
      end
    )
  end

  def answer
    Answer.new key: key, value: answer_value
  end

  def data_from_r
    RPackage.question_by_key(key)
  end
end
