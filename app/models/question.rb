class Question < BaseModel
  attr_accessor :id, :answer_value

  validates_inclusion_of :id, in: -> (_) { RPackage.question_ids },
                              message: '`%{value}` not found'

  # accessors for attributes defined by R package
  %w( text intro answer_options ).each do |r_attribute|
    define_method r_attribute do
      ensure_valid do
        data_from_r[r_attribute]
      end
    end
  end

  def answer_option_set
    AnswerOptionSet.new(
      id: data_from_r['answer_option_set_id'],
      answer_options: answer_options.map do |attributes|
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

  def self.find(id)
    new id: id
  end
end
