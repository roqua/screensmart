class Answer < BaseModel
  attr_accessor :id, :value

  validates :id, inclusion: {in: ->(_) { RPackage.question_ids }}
  validates :value, numericality: {only_integer: true}

  def question
    q = Question.new id: id
    q.answer_value = value if value.present?
    q
  end
end
