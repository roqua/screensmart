class Answer < BaseModel
  attr_accessor :id, :value

  validates_inclusion_of :id, in: RPackage.question_ids
  validates_numericality_of :value, only_integer: true

  def question
    q = Question.new id: id
    q.answer_value = value if value.present?
    q
  end
end
