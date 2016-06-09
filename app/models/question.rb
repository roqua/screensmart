class Question < BaseModel
  attr_accessor :id, :answer_value

  validates_inclusion_of :id, in: -> (_) { RPackage.question_ids },
                              message: '`%{value}` not found'

  def text
    ensure_valid do
      RPackage.question_by_id(id)['text']
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
    Answer.new id: id, value: answer_value
  end

  def data_from_r
    RPackage.question_by_id(id)
  end
end
