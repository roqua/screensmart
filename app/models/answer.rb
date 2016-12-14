class Answer < BaseModel
  attr_accessor :id, :domain_id, :value

  validates_inclusion_of :id, in: -> (_) { RPackage.question_ids }
  validates_inclusion_of :domain_id, in: -> (_) { RPackage.domain_ids }
  validates_numericality_of :value, only_integer: true

  def question
    q = Question.new id: id, domain_id: domain_id
    q.answer_value = value if value.present?
    q
  end
end
