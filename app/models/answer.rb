class Answer < BaseModel
  attr_accessor :key, :value

  validates_inclusion_of :key, in: RPackage.question_keys
  validates_numericality_of :value, only_integer: true

  def question
    q = Question.new key: key
    q.answer_value = value if value.present?
    q
  end
end
